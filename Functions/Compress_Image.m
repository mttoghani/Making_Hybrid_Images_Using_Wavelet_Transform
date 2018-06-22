function [compressed_img, img_wavelet, compressed_SNR] = Compress_Image...
    (orig_img, h1, h2, h3, h4, number_of_steps, Percent)
% [compressed_img, img_wavelet, compressed_SNR] = Compress_Image...
%    (orig_img, h1, h2, h3, h4, number_of_steps, Percent)
% 
% This function takes as input an image and compresses it by first taking
% the wavelet transform 'number_of_steps' times and keeping only a
% percentage of the coeffiecients while zeroing the other coefficients
% 
% Inputs:
% ori_img:  Image to be compressed
% 
% h1,h2:    Low pass and high pass filter respectively used in the wavelet
%           transform
% 
% h3,h4:    High pass and low pass filters respectively used in the inverse
%           wavelet transform
% 
% number_of_steps: number of steps we take the wavelet transform from the
%           original image
% 
% Percent:  1*m vector holding percentage values. There will be a different
%           output image for each compression value in this vector
% 
% Outputs:  
% 
% compressed_img:   A 1*m cell array holding the output images
% 
% img_wavelet:      An array which is the result of running the wavelet
%                   transform on 'orig_img' , 'number_of_steps' times
% 
% compressed_SNR:   A 1*m array holding SNR values for the compression
%                   rates


% Initilizing outputs
img_wavelet         = zeros(size(orig_img));
compressed_img      = cell(1,length(Percent));
compressed_SNR      = [];

%% Wavelet Transform
% Issue an error in case number of steps is not less than 1
if (number_of_steps<1)
   error(message('Number of steps must be at least 1'));
end


% Fix size of image so that we dont run into problems running I-Wavelet
% Do not remove this line
img                 = Matrix_Extend(orig_img, length(h1), number_of_steps);


% Create a 1*numberofsteps cell array for each of the four outputs of the
% wavelet transform
cA_orig             = cell(1,number_of_steps);
cH_orig             = cell(1,number_of_steps);
cV_orig             = cell(1,number_of_steps);
cD_orig             = cell(1,number_of_steps);


% Perform the transform number_of_steps timesz
[cA_orig{1},...
    cH_orig{1},...
    cV_orig{1},...
    cD_orig{1}]     = Discrete_Wavelet2D(img, h1, h2);


for i = 2:number_of_steps
    [cA_orig{i},...
        cH_orig{i},...
        cV_orig{i},...
        cD_orig{i}] = Discrete_Wavelet2D(cA_orig{i-1}, h1, h2);
end


%set image wavelet to be output of two low pass filters in the last step
img_wavelet         = cA_orig{number_of_steps};


% Perform matrix center on all the images
for i = number_of_steps:-1:2
    img_wavelet     = Matrix_Center([img_wavelet, cH_orig{i}; cV_orig{i},...
        cD_orig{i}], size(cD_orig{i - 1}));
end
img_wavelet         = [img_wavelet, cH_orig{1}; cV_orig{1}, cD_orig{1}];


%% Compression & SNR Calculation
% Comment
min_e               = 1e-5;
number              = 0;
valid_wavelet_coeff = img_wavelet(img_wavelet > min_e);
valid_wavelet_coeff = valid_wavelet_coeff(:) ;     
for percent = Percent
% Use this varianle for indexing image titles
    number          = number + 1;
    cA              = cA_orig;
    cH              = cH_orig;
    cV              = cV_orig;
    cD              = cD_orig;

    
    sorted_coeff    = zeros (size (valid_wavelet_coeff)) ;
    threshold       = 255 ;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%                              Write your code here                              %%%%%%%
%%%%%%%                                      _||_                                      %%%%%%%
%%%%%%%                                      \  /                                      %%%%%%%
%%%%%%%                                       \/                                       %%%%%%%

% Your job is to first sort 'valid_wavelet_coefficients' 
% and then find a threshhold. 
% If threshhold = a then only 'percent'% values of the
% coefficients in 'valid_wavelet_coefficients' are greater tham a

% Available variables:
% 'valid_wavelet_coefficients': is the vector containing the result of the
%                               algorithm sepcified in the readme file run 
%                               number_of_steps times
% 'percent':                    is a variable showing what percent of 
%                               coeffiecient we intend on keeping 

% Outputs of this part of code:
% sorted_coeff:     a vactor holding the sorted values of
%                   'valid_wavelet_coefficients'
% threshhold:       a threshhold such that only 'percent'% of the
%                   coefficeints in 'valid_wavelet_coefficients' are greater
%                   than 'theshhold'. 

    sorted_coeff    = sort(abs(valid_wavelet_coeff(:)),'descend');
    threshold       = sorted_coeff(floor(percent*length(sorted_coeff))+1);

%%%%%%%                                       /\                                       %%%%%%%
%%%%%%%                                      /  \                                      %%%%%%%
%%%%%%%                                       ||                                       %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% We now zero all the coefficients in the wavelet transform that are less
% than threshhold nad bigger than min_e

    for i = 1:number_of_steps
        cA{i} ( (cA{i}> min_e) &...
            (cA{i} < threshold) )       = 0;
        cH{i} ( (cH{i}> min_e) &...
            (cH{i} < threshold) )       = 0;
        cV{i} ( (cV{i}> min_e) &...
            (cV{i} < threshold) )       = 0;
        cD{i} ( (cD{i}> min_e) &...
            (cD{i} < threshold) )       = 0;
    end
    
% Reconstruct image by taking inverse wavelet transform
    for i = number_of_steps:-1:2
        cA{i-1}             = iDiscrete_Wavelet2D(cA{i}, cH{i}, cV{i}, cD{i}, h3, h4);
    end
    
% Take matrix_center as well in the last step of inverse wavelet transform    
    compressed_img{number} = Matrix_Center(iDiscrete_Wavelet2D(cA{1},...
        cH{1}, cV{1}, cD{1}, h3, h4), size(orig_img));
    
% compute SNR value of reconstructed images    
    compressed_SNR         = [compressed_SNR, SNR_Compute(orig_img, compressed_img{number})];
    
end