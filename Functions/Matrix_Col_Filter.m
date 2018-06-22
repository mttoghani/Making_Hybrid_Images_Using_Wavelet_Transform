function [m_filtered] = Matrix_Col_Filter(m, filt)
% [m_filtered] = Matrix_Col_Filter(m, filt)
% 
% Matrix_Col_Filter filters columns of a matrix with 'filt'. This function
% regards each column of a Matrix M as an 1D signal and filters each column
% with the filter which has frequency response 'filt'.
% 
% Inputs:
% 
% m:            a*b matrix to be filtered
% 
% filt:         c*1 vecotr which is the impulse resopnse of the filter
% 
% Outputs:
% 
% m_filtered:   (a + c - 1) * b matrix which is the result of applying convolving 
%               'filter' to the colmuns of m 


m_filtered          = zeros(size(m, 1) + length(filt) - 1, size(m, 2));

if (size(filt,2) ~= 1)
    if(size(filt,1) == 1)
        filt        = filt';
    else
        error(message('Filter must be vector'));
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%                              Write your code here                              %%%%%%%
%%%%%%%                                      _||_                                      %%%%%%%
%%%%%%%                                      \  /                                      %%%%%%%
%%%%%%%                                       \/                                       %%%%%%%

fl                  = length(filt);
siz                 = size(m);
Filt_rep            = repmat(filt, 1, siz(2));
m_filtered          = ifft( fft(m, (fl + siz(1) -1))...
                .* fft(Filt_rep, (fl + siz(1) -1)) );

%%%%%%%                                       /\                                       %%%%%%%
%%%%%%%                                      /  \                                      %%%%%%%
%%%%%%%                                       ||                                       %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
