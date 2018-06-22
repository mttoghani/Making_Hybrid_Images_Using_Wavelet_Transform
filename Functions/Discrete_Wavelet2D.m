function [cA, cH, cV, cD] = Discrete_Wavelet2D(M, h1, h2)
% [cA, cH, cV, cD] = Discrete_Wavelet2D(M, h1, h2)
% 
% This functions return the wavelet transform of M using h1 and h2 as the
% filters
% 
% Inputs:
% 
% M:  input image
% 
% h1: impulse response of filter h1
% 
% h2: impulse response of filter h2
% 
% cA,cH,cV,cD: Four matrices of the same size which are the wavelet 
%              transforms of M

%%% Filtering rows of original image with h1
L           = Matrix_Col_Filter(M', h1)';
% Downsampling
L           = L(:, 2:2:end);

%Filtering columns of output with h1
cA          = Matrix_Col_Filter(L, h1);

%Downsampling
cA          = cA(2:2:end, :);

%Filtering Columns of output with h2
cH          = Matrix_Col_Filter(L ,h2);
%Downsampling
cH          = cH(2:2:end, :);


%%% Filtering rows of original image with h2
H           = Matrix_Col_Filter(M', h2)';
%Downsampling
H           = H(:, 2:2:end);

%Filtering columns of output image with h1
cV          = Matrix_Col_Filter(H, h1);

%Downsampling
cV          = cV(2:2:end, :);

%filtering columns of output image with h2
cD          = Matrix_Col_Filter(H, h2);

%Downsampling
cD          = cD(2:2:end, :);
