
% This m-file demoes the usage of SIFT functions. It generates SIFT keypionts and descriptors for one input image. 
% Author: Yantao Zheng. Nov 2006.  For Project of CS5240


% Add subfolder path.
main; 

img1_dir = 'demo-data/';

img1_file = 'object0024.view03.png';

I1=imreadbw([img1_dir img1_file]) ; 
I1_rgb = imread([img1_dir img1_file]) ; 
I1=imresize(I1, [240 320]);

I1_rgb =imresize(I1_rgb, [240 320]);
I1=I1-min(I1(:)) ;
I1=I1/max(I1(:)) ;

%fprintf('CS5240 -- SIFT: Match image: Computing frames and descriptors.\n') ;
[frames1,descr1,gss1,dogss1] = do_sift( I1, 'Verbosity', 1, 'NumOctaves', 4, 'Threshold',  0.1/3/2 ) ; %0.04/3/2



figure(11) ; clf ; plotss(dogss1) ; colormap gray ;
drawnow ;

figure(2) ; clf ;
imshow(I1_rgb) ; axis image ;

hold on ;
h=plotsiftframe( frames1 ) ; set(h,'LineWidth',1,'Color','g') ;
