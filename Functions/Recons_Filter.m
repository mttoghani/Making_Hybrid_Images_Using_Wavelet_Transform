%% Recons_Filter 
% This script designs the reconstruction filters
%
% As indicated in the project readme file, you have to derive h3 and h4 by
%
% hand. h3 and h4 will be functions of h1 and h2.
%
% When this cript is finished running you must have two new
%
% varibales called h3 and h4 which are the reconstruction filters you
%
% have designed. 
 
 
h3          = zeros(size(h1));
h4          = zeros(size(h1));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%                              Write your code here                              %%%%%%%
%%%%%%%                                      _||_                                      %%%%%%%
%%%%%%%                                      \  /                                      %%%%%%%
%%%%%%%                                       \/                                       %%%%%%%

pow         = (-1).^[1:length(h1)];
h3          = (h2 .* pow);
h4          = -(h1 .* pow);

%%%%%%%                                       /\                                       %%%%%%%
%%%%%%%                                      /  \                                      %%%%%%%
%%%%%%%                                       ||                                       %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%