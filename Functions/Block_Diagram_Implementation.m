function [y] = Block_Digram_Implementation(h1, h2, h3, h4, x)
% [y] = Block_Digram_Implementation(h1, h2, h3, h4)
% 
% This function implements the block diagram provided in the readme file.
% 
% Before implementing this function you need to have implemented the
% function 'Matrix_Col_Filter' since you will need it in this script.
% 
% Inputs:
% 
% h1: impulse response of filter h1
% 
% h2: impulse response of filter h2
% 
% h3: impulse response of filter h3
% 
% h4: impulse response of filter h4
% 
% x : input signal to the block diagram
% 
% Output:
% 
% y : output signal of diagram


% Initialize

x3  = zeros(size(x));
x4  = zeros(size(x));



% Filter
x1  = Matrix_Col_Filter(x',h1)';
x2  = Matrix_Col_Filter(x',h2)';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%                              Write your code here                              %%%%%%%
%%%%%%%                                      _||_                                      %%%%%%%
%%%%%%%                                      \  /                                      %%%%%%%
%%%%%%%                                       \/                                       %%%%%%%

x1  = x1(1:2:end);
x2  = x2(1:2:end);

x3  = upsample(x1,2);
x4  = upsample(x2,2);

%%%%%%%                                       /\                                       %%%%%%%
%%%%%%%                                      /  \                                      %%%%%%%
%%%%%%%                                       ||                                       %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

y1  = Matrix_Col_Filter(x3',h3)';
y2  = Matrix_Col_Filter(x4',h4)';

y1  = Matrix_Center(y1, size(x));
y2  = Matrix_Center(y2, size(x));

y   = y1 + y2;
