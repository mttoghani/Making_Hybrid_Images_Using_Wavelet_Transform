function y = Matrix_Center(x, s)
% y = Matrix_Center(x, s)
% 
% This function takes an input matrix x and and returns a matrix with size
% s that is in the center of x
% 
% Inputs:
% 
% x:    Input Matrix
% 
% s:    a 1*2 vector containing size of the matrix at the center of x
% 
% Outputs
% 
% y:    A matrix with size s extracted from the center of x


siz                 = size(x);
first               = [0 0];
last                = [0 0];

first(1)            = floor( (siz(1) - s(1))/2 ) + 1 ;
first(2)            = floor( (siz(2) - s(2))/2 ) + 1 ;

last(1)             = first(1) + s(1) - 1;
last(2)             = first(2) + s(2) - 1;

y                   = x( first(1):last(1), first(2):last(2));
