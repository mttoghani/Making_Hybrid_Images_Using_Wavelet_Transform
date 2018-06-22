function [hybrid_img] = Hybrid_Image_Maker...
                    (orig_img1, orig_img2, h1, h2, h3, h4, number_of_steps)
% [hybrid_img] = Hybrid_Image_Maker...
%                  (orig_img1, orig_img2, h1, h2, h3, h4, number_of_steps)
% 
% This function creates hybird images
% 
% Inputs: 
% 
% orig_img1: First image which you will see from far away up
% 
% orig_img2: Second image which you will see from close up
% 
% h1,h2:     Low pass and high pass filter respectively used in the wavelet
%            transform
% 
% h3,h4:     High pass and low pass filters respectively used in the inverse
%            wavelet transform
% 
% number_of_steps: number of steps we take the wavelet transform from the
%            both images
% 
% Outputs:
% 
% hybrid_img:The hybrid image of 'orig_img1' and 'orig_img2'



% we pad zeros to the matrices so that they have a new size. This helps us
% avoid problems when taking inverse wavelet transform
img1 = Matrix_Extend(orig_img1, length(h1), number_of_steps);
img2 = Matrix_Extend(orig_img2, length(h1), number_of_steps);

% number of steps hase to be a positive number
if (number_of_steps<1)
   error(message('Number of steps must be at least 1'));
end

% Create a 1*numberofsteps cell array for each of the four outputs of the
% wavelet transform
cA1 = cell(1,number_of_steps);
cH1 = cell(1,number_of_steps);
cV1 = cell(1,number_of_steps);
cD1 = cell(1,number_of_steps);

% Take the wavelet transform of the first image
[cA1{1}, cH1{1}, cV1{1}, cD1{1}] = Discrete_Wavelet2D(img1, h1, h2);

% Take the wavelet transform number_of_steps times from the first image
for i = 2:number_of_steps
    [cA1{i}, cH1{i}, cV1{i}, cD1{i}] = Discrete_Wavelet2D(cA1{i-1}, h1, h2);
end

cA2 = cell(1,number_of_steps);
cH2 = cell(1,number_of_steps);
cV2 = cell(1,number_of_steps);
cD2 = cell(1,number_of_steps);

% Take the wavelet transform of the first image
[cA2{1}, cH2{1}, cV2{1}, cD2{1}] = Discrete_Wavelet2D(img2, h1, h2);

% Take the wavelet transform number_of_steps times from the first image
for i = 2:number_of_steps
    [cA2{i}, cH2{i}, cV2{i}, cD2{i}] = Discrete_Wavelet2D(cA2{i-1}, h1, h2);
end

cA3 = cA2;
cH3 = cH2;
cV3 = cV2;
cD3 = cD2;

% replacing wavelet of first image into second image
cA3{number_of_steps} = cA1{number_of_steps};

% Recontructing second image
for i = number_of_steps:-1:2
    cA3{i-1} = iDiscrete_Wavelet2D(cA3{i}, cH3{i}, cV3{i}, cD3{i}, h3, h4);
end

hybrid_img = Matrix_Center( iDiscrete_Wavelet2D(...
    cA3{1}, cH3{1}, cV3{1}, cD3{1}, h3, h4), size(orig_img1));