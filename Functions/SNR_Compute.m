function [SNR] = SNR_Compute(signal, reconstructed_signal)
% [SNR] = SNR_Compute(signal, reconstructed_signal)
% 
% SNR_Compute calculates the logarithm of signal to noise ratio. 
% 
% In this function you need to compute the logarith of the ratio of the 
% average squared of the signal to the average square noise.
% 
% Inputs:
% 
% signal: Original signal
% 
% reconstructed_signal: Reconstructed signal which is equal to the original
%                       signal plus some noise
% Outputs:
% 
% SNR = SNR value in dB


SNR                  = 0;
reconstructed_signal = reconstructed_signal(:);
signal               = signal(:);


if ( length(signal) ~= length(reconstructed_signal) )
    error(message('Matrix dimensions must agree'));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%                              Write your code here                              %%%%%%%
%%%%%%%                                      _||_                                      %%%%%%%
%%%%%%%                                      \  /                                      %%%%%%%
%%%%%%%                                       \/                                       %%%%%%%

noise = reconstructed_signal - signal;
SNR = 10 * log10( sum(signal.^2) / sum(noise.^2) );

%%%%%%%                                       /\                                       %%%%%%%
%%%%%%%                                      /  \                                      %%%%%%%
%%%%%%%                                       ||                                       %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
