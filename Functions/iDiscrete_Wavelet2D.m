function [X] = iDiscrete_Wavelet2D(cA, cH, cV, cD, h3, h4)
% [X] = iDiscrete_Wavelet2D(cA, cH, cV, cD, h3, h4)
% 
% This is the 2d inverse wavelet transform. 
% 
% Inputs: 
% 
% cA,cH,cV,cD:  Four matrices of the same size which are wavelet transforms
%               of the original image
% 
% h3,h4:        lowpass and highpass reconstrution filters respectively
% 
% Output:
% 
% X:            the inverse wavelet transform of input


%Check to see four images have exactly the same dimension
if (~( sum(size(cA)  == size(cH)) ==2 &&...
   sum(size(cA)  == size(cV)) ==2 &&...
   sum(size(cA)  == size(cD)) ==2 ))
   error(message('Matrix dimensions must agree'));
end

fl               = length(h3);


% The size of the output should be twice the size of the input minus the
% filter length
s                = 2*size(cA) - fl + 2;


X                = ups_filt(cA, h3, h3, s)+ ...
                   ups_filt(cH, h4, h3, s)+ ...
                   ups_filt(cV, h3, h4, s)+ ...
                   ups_filt(cD, h4, h4, s);

end

%-------------------------------------------------------%
% Inline Function(s)
%-------------------------------------------------------%
%This function is basically an uprate function
%It enters zeros in between consecutive signal samples and the applies a
%filter. It applies 'rfilt' for the rows and 'cfilt' for the columns. 

function y = ups_filt(x, rfilt, cfilt, s)
% Upsampling rows
    y            = upsmpl(x')';


% Applying row filter
    y            = Matrix_Col_Filter(y, rfilt);


% Upsampling Columns
    y            = upsmpl(y);


% Applying column filter
    y            = Matrix_Col_Filter(y', cfilt)';

% Eventually choose the center part of matrix
    y            = Matrix_Center(y, s);

end


%%% This function enters zeros in between consecutive samples of the matrix
%%% X (both rows and columns)
function [y] = upsmpl(x)
    s            = size(x);
    siz          = [s(1), (2*s(2)-1)];
    y            = zeros(siz);
    y(:,1:2:end) = x;
end