function oframes = do_orientation(...
                        oframes, ...
                        octave, ...
                        S, ...
                        smin, ...
                        sigma0 )
% this function computes the major orientation of the keypoint (oframes).
% Note that there can be multiple major orientations. In that case, the
% SIFT keys will be duplicated for each major orientation
% Author: Yantao Zheng. Nov 2006.  For Project of CS5240

frames = [];                  
win_factor = 1.5 ;  
NBINS = 36;
histo = zeros(1, NBINS);
[M, N, s_num] = size(octave); % M is the height of image, N is the width of image; num_level is the number of scale level of the octave

key_num = size(oframes, 2);
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
    angles(:,:,si) = mod(atan(gradient_y ./ (eps + gradient_x)) + 2*pi, 2*pi);
end


% round off the cooridnates and 
x = oframes(1,:);
y = oframes(2,:) ;
s = oframes(3,:);

x_round = floor(oframes(1,:) + 0.5);
y_round = floor(oframes(2,:) + 0.5);
scales = floor(oframes(3,:) + 0.5) - smin;


for p=1:key_num
    s = scales(p);
    xp= x_round(p);
    yp= y_round(p);
    sigmaw = win_factor * sigma0 * 2^(double (s / S)) ;
    W = floor(3.0* sigmaw);
    
    for xs = xp - max(W, xp-1): min((N - 2), xp + W)
        for ys = yp - max(W, yp-1) : min((M-2), yp + W)
            dx = (xs - x(p));
            dy = (ys - y(p));
            if dx^2 + dy^2 <= W^2 % the points are within the circle
               wincoef = exp(-(dx^2 + dy^2)/(2*sigmaw^2));
               bin = round( NBINS *  angles(ys, xs, s+ 1)/(2*pi) + 0.5);

               histo(bin) = histo(bin) + wincoef * magnitudes(ys, xs, s+ 1);
            end
            
        end
    end
    
    theta_max = max(histo);
    theta_indx = find(histo> 0.8 * theta_max);
    
    for i = 1: size(theta_indx, 2)
        theta = 2*pi * theta_indx(i) / NBINS;
        frames = [frames, [x(p) y(p) s theta]'];        
    end   
end

oframes = frames;
% for each keypoint