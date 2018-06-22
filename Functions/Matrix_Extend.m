function extended_matrix = Matrix_Extend(matrix, filter_len, number_of_steps)
% extended_matrix = Matrix_Extend(matrix, filter_len, number_of_steps)
% 
% This function pads zeros to 'matrix' such that its size is suitable for
% taking the wavelet transform and inverse transform 'number_of_steps' times
% 
% Inputs:
% 
% matrix:           input matrix
% 
% filter_len:       length of the filter used in wavelet tranform
% 
% number_of_steps:  number of steps we intend on running the wavelet
%                   transform
% 
% Outputs:
% 
% extended_matrix: Matrix with correct size



siz                     = size(matrix);
floor_fl                = floor((filter_len-1)/2);


%Each time wavelet transform is run the the size increases by filter_len-1
%(filterd)and then divided by two (downsampled)
for i = 1:number_of_steps
    siz                 = ceil( (siz + [filter_len-1, filter_len-1])/2);
end

for i = 1:number_of_steps
    siz                 = 2*(siz - [floor_fl, floor_fl]);
end


extended_matrix         = zeros(siz);
siz_2                   = size(matrix);
first                   = [0 0];
last                    = [0 0];


% Pad image with zeros
first(1)                = floor( (siz(1) - siz_2(1))/2 ) + 1 ;
first(2)                = floor( (siz(2) - siz_2(2))/2 ) + 1 ;

last(1)                 = first(1) + siz_2(1) - 1;
last(2)                 = first(2) + siz_2(2) - 1;

extended_matrix...
    (first(1):last(1),...
    first(2):last(2))   = matrix;