function descriptors = do_descriptor(octave, ... % gaussian scale space of an octave
                                      oframes, ...  % frames containing keypoint coordinates and scale, and orientation
                                      sigma0, ...   % base sigma value
                                      S, ...        % level of scales in the octave
                                      smin, ...     
                                      varargin)

for k=1:2:length(varargin)
	switch lower(varargin{k})
      case 'magnif'
        magnif = varargin{k+1} ;
        
      case 'numspatialbins'
        NBP = varargin{k+1} ;  
        
      case  'numorientbins'
        NBO = varargin{k+1} ;   
        
      otherwise
        error(['Unknown parameter ' varargin{k} '.']) ;
     end
end 
      
                               
num_spacialBins = NBP;
num_orientBins = NBO;
key_num = size(oframes, 2);
% compute the image gradients 
[M, N, s_num] = size(octave); % M is the height of image, N is the width of image; num_level is the number of scale level of the octave
descriptors = [];
magnitudes = zeros(M, N, s_num);
angles = zeros(M, N, s_num);
% compute image gradients
for si = 1: s_num
    img = octave(:,:,si);
    dx_filter = [-0.5 0 0.5];
    dy_filter = dx_filter';
    gradient_x = imfilter(img, dx_filter);
    gradient_y = imfilter(img, dy_filter);
    magnitudes(:,:,si) =sqrt( gradient_x.^2 + gradient_y.^2);
%     if sum( gradient_x == 0) > 0
%         fprintf('00');
%     end
    angles(:,:,si) = mod(atan(gradient_y ./ (eps + gradient_x)) + 2*pi, 2*pi);
end

x = oframes(1,:);
y = oframes(2,:);
s = oframes(3,:);
% round off
x_round = floor(oframes(1,:) + 0.5);
y_round = floor(oframes(2,:) + 0.5);
scales =  floor(oframes(3,:) + 0.5) - smin;

for p = 1: key_num

    s = scales(p);
    xp= x_round(p);
    yp= y_round(p);
    theta0 = oframes(4,p);
    sinth0 = sin(theta0) ;
    costh0 = cos(theta0) ;
    sigma = sigma0 * 2^(double (s / S)) ;
    SBP = magnif * sigma;
    %W =  floor( sqrt(2.0) * SBP * (NBP + 1) / 2.0 + 0.5);
    W =   floor( 0.8 * SBP * (NBP + 1) / 2.0 + 0.5);
    
    descriptor = zeros(NBP, NBP, NBO);
    
    % within the big square, select the pixels with the circle and put into
    % the histogram. no need to do rotation which is very expensive
    for dxi = max(-W, 1-xp): min(W, N -2 - xp)
        for dyi = max(-W, 1-yp) : min(+W, M-2-yp)
            mag = magnitudes(yp + dyi, xp + dxi, s); % the gradient magnitude at current point(yp + dyi, xp + dxi)
            angle = angles(yp + dyi, xp + dxi, s) ;  % the gradient angle at current point(yp + dyi, xp + dxi)
            angle = mod(-angle + theta0, 2*pi);      % adjust the angle with the major orientation of the keypoint and mod it with 2*pi
            dx = double(xp + dxi - x(p));            % x(p) is the exact keypoint location (floating number). dx is the relative location of the current pixel with respect to the keypoint
            dy = double(yp + dyi - y(p));            % dy is the relative location of the current pixel with respect to the keypoint
            
            nx = ( costh0 * dx + sinth0 * dy) / SBP ; % nx is the normalized location after rotation (dx, dy) with the major orientation angle. this tells which x-axis spatial bin the pixel falls in 
            ny = (-sinth0 * dx + costh0 * dy) / SBP ; 
            nt = NBO * angle / (2* pi) ;
            wsigma = NBP/2 ;
            wincoef =  exp(-(nx*nx + ny*ny)/(2.0 * wsigma * wsigma)) ;
            
            binx = floor( nx - 0.5 ) ;
            biny = floor( ny - 0.5 ) ;
            bint = floor( nt );
            rbinx = nx - (binx+0.5) ;
            rbiny = ny - (biny+0.5) ;
            rbint = nt - bint ;
             
            for(dbinx = 0:1) 
               for(dbiny = 0:1) 
                   for(dbint = 0:1) 
                        % if condition limits the samples within the square
                        % width W. binx+dbinx is the rotated x-coordinate.
                        % therefore the sampling square is effectively a
                        % rotated one
                        if( binx+dbinx >= -(NBP/2) && ...
                            binx+dbinx <   (NBP/2) && ...
                            biny+dbiny >= -(NBP/2) && ...
                            biny+dbiny <   (NBP/2) &&  isnan(bint) == 0) 
                              
                              weight = wincoef * mag * abs(1 - dbinx - rbinx) ...
                                  * abs(1 - dbiny - rbiny) ...
                                  * abs(1 - dbint - rbint) ;
   
                              descriptor(binx+dbinx + NBP/2 + 1, biny+dbiny + NBP/2+ 1, mod((bint+dbint),NBO)+1) = ...
                                  descriptor(binx+dbinx + NBP/2+ 1, biny+dbiny + NBP/2+ 1, mod((bint+dbint),NBO)+1 ) +  weight ;
                        end
                   end
               end
            end

        end
            
    end
    descriptor = reshape(descriptor, 1, NBP * NBP * NBO);
    descriptor = descriptor ./ norm(descriptor);
            
            %Truncate at 0.2
    indx = find(descriptor > 0.2);
    descriptor(indx) = 0.2;
    descriptor = descriptor ./ norm(descriptor);
    
    descriptors = [descriptors, descriptor'];
end

  







