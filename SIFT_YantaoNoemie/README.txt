                     SCALE INVARIANT FEATURE TRANSFORM IMPLEMENTATION

                               YANTAO ZHENG, NOEMIE PHULPIN 
                          
                          yantaozheng@gmail.com, S0600506@nus.edu.sg

This is a MATLAB implementation of the SIFT keypoint detector and descriptor [1]. 


FUNCTIONS

The implementation consists of the following functions. They are organized in the folders based on the functionality. 

These functions are self-contained and can be utilized independently. 

do_gaussian: generate Gaussian scale space of input image
do_diffofg: generate Difference of Gaussian (DoG) scale space 
do_localmax: select local extrema as the potential keypoints
do_extrefine: refine the keypoints by discarding the ones with low contrast and along an edge
do_orientation: compute the orientation of a support region of keypoint
do_descriptor: compute the descriptor of a keypoint based on image gradients. 
do_match: match two images based on the nearest neighbor principle and spatial consistency.
do_sift: generate the SIFT descriptors for a given input image. It basically executes all the functions above. 


RUN THE PROGRAM

If the purpose of using this software is to compute SIFT descriptors of images, users only need to handle do_sift function. 
do_sift takes an image as input and generate keypoints and descriptors as output. Detailed structures about input/output can be found
in the program header comments. 

There are several demo programs avaiable. They are the examples to run the SIFT programs. 

Execute the demos as below:
From MATLAB prompt
  > do_demo_1
  
  

IMPORTANT PARAMETERS

The performance of SIFT image matching depends on several parameters.

In do_sift function, tuning the following parameters can achive different number of SIFT keypoints and descriptors;
and therefore, different matching performance. The values are the default ones given by Lowe. 

S=3 ; 				Number of sub-levels per octave
omin= -1 ; 			Starting octave number
O = 4;     			Max octave level

thresh = 0.04 / S / 2 ;     	Contrast response threshold
r = 15 ;		    	Edge response threshold

NBP = 4 ;			Number of spatial bins
NBO = 8 ;			Number of orientation bins

  

[1] D. G. Lowe, "Distinctive image features from scale-invariant
    keypoints," IJCV, vol. 2, no. 60, pp. 91 110, 2004.