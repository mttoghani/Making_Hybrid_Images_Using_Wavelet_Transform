% This is the main file which should be run to produce the outputs. If this
% is your first time with MATLAB, either press F5 or click on the green
% triangular button (RUN).
%
% In this file you may change values of the following variables
%   "section_enable"
%   "image_selector"
%   "rgb_or_gray"
%   "number_of_steps"
%   "set_selector"
%
% Your main task in this project is to edit the following m files
%   'Recons_Filter.m'
%   'Frequency_Response.m'
%   'Matrix_Col_Filter.m'
%   'Block_Diagram_Implementation.m'
%   'SNR_Compute.m'
%   'Compress_Image.m'
%
% located in "DSP Final Project/Functions/". Please avoid modifying
% other parts of this code and other files.

%% Initialization 

% This part is to clear the command window, remove all the pre-defined
% parameters and close all open figures
clear all;
close all;
clc;


% Adding functions and input-images path to the matlab directory
addpath(genpath('Input_images'));
addpath(genpath('Functions'));
addpath(genpath('Signals'));
addpath(genpath('Results'));

% Loading decomposition filters
load('Reconstruction_Filters.mat');
load('Decomposition_Filters.mat');
load('Signal.mat');


%% Section Enable

% Choose the section to run due to Readme file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%                          You can change section enable                         %%%%%%%
%%%%%%%                                      _||_                                      %%%%%%%
%%%%%%%                                      \  /                                      %%%%%%%
%%%%%%%                                       \/                                       %%%%%%%

section_enable        = 3;
                            % 1: 1D Signal Decomposiotion & Reconstruction
                            % 2: Imgage Compression using 2D Wavelet transform
                            % 3: HYBRID Image Maker

%%%%%%%                                       /\                                       %%%%%%%
%%%%%%%                                      /  \                                      %%%%%%%
%%%%%%%                                       ||                                       %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


switch section_enable
    case 1
        %% 1D Signal Decomposiotion & Reconstruction
        
        % Here you should design the recontruction filters h3 and h4
        % Implement the script below
        Recons_Filter;
        
        % Save the reconstruction filters you designed
        save('Signals/Reconstruction_Filters.mat', 'h3', 'h4');

        % Here you should plot the FFT response of the four filters you just 
        % desgined
        % Implement the script below
        
        h             = [h1; h2; h3; h4];
        Frequency_Response;
        
        
        figure(1);
        plot(linspace (-pi, pi, size(H, 2)),  H);
        xlim([-pi pi]);
        title('Filters Frequency Response');
        legend('H1', 'H2', 'H3', 'H4');
        saveas(1, 'Results/Section1/Filters_Frequency_Response', 'jpg');
        
        
        
        % Now you have to implement the block digram provided in the readme
        % file.
        % 'Signal' is a test signal we have provided as input to the block
        % diagram. 'recontructed_singal' is the output of the block diagram
        % Implement the function below
        reconstructed_signal            = Block_Diagram_Implementation (h1,h2,h3,h4,Signal);

        
        % Now we are going to test the correctness of the designed filters
        % by plotting 'Signal' and 'reconstructed_signal' 
        % If you have designed h3 and h4 correctly, 'Signal' and
        % 'reconstructed_signal' will be equal. 
        figure(2);
        hold on ; 
        plot (1:length(Signal) ,Signal, 'r');
        plot (1:length(reconstructed_signal) ,reconstructed_signal, 'black--');
        xlim([1 length(Signal)]);
        title('Block Diagram Result');
        legend('Original Signal', 'Reconstructed Signal');
        
        % Save the plot above
        saveas(2, 'Results/Section1/Block_Diagram_Result', 'jpg');
        
        
        % Compute SNR of the reconstructed_signal
        % You should implement the function SNR_Compute
        reconstructed_signal_SNR        = SNR_Compute(Signal, reconstructed_signal);
        disp(['reconstructed_signal_SNR = ', num2str(reconstructed_signal_SNR)]);
        
        
    case 2
        %% Imgage Compression using 2D Wavelet transform

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%          You can change "image_selector" and "number_of_steps" here            %%%%%%%
        %%%%%%%                                     _||_                                       %%%%%%%
        %%%%%%%                                     \  /                                       %%%%%%%
        %%%%%%%                                      \/                                        %%%%%%%

        number_of_steps             = 10;
                                        % number of 2D-wavelet transform
                                        % applied steps
        image_selector              = 30;
                                        % 1: Spring Landscape
                                        % 2: Autumn Landscape
                                        
        rgb_or_gray                 = 1;
                                        % 0: Gray
                                        % 1: RGB

        %%%%%%%                                      /\                                        %%%%%%%
        %%%%%%%                                     /  \                                       %%%%%%%
        %%%%%%%                                      ||                                        %%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        
        % Import Image
        if (rgb_or_gray == 1)
            img                     = im2double(imread([num2str(image_selector),'.jpg']));
        else
            img                     = im2double(rgb2gray(imread([num2str(image_selector),'.jpg'])));
        end
        
        %Show original image before compression
        figure(1); imshow(img);
        title('Original Image');
        saveas(1, 'Results/Section2/Original_Image', 'jpg');
        
        

        % Percentage of compression 
        Percent                     = round(12*exp([-1:-1:-3]))/100;

        [compressed_img,...
            img_wavelet,...
            compressed_SNR]         = Compress_Image...
            (img(:,:,1), h1, h2, h3, h4, number_of_steps, Percent);
     
        if (size(img,3) > 1)
            for k = 2:size(img,3)
                [compressed_img(:, :, k),...
                img_wavelet(:, :, k),...
                ~]                  = Compress_Image...
                (img(:,:,k), h1, h2, h3, h4, number_of_steps, Percent);
            end
        end
        
        
        % Show different levels of compression
        Image_index                       = 1;
        for i = 1:length(compressed_SNR)
            Image_index                   = Image_index + 1;
            if (size(img,3) > 1)
                compressed_image(:, :, 1) = compressed_img{1, i, 1};
                compressed_image(:, :, 2) = compressed_img{1, i, 2};
                compressed_image(:, :, 3) = compressed_img{1, i, 3};
            else
                compressed_image          = compressed_img{i};
            end
            figure(Image_index); imshow(compressed_image);
            title(  ['Compression Percent = ', num2str(Percent(i)*100), '%']  );
            saveas(Image_index, ['Results/Section2/Compressed_Image', num2str(Image_index-1)], 'jpg');
        end
        Image_index                       = Image_index + 1;
        
        
        
        % Plot SNR values Vs Compression factoe
        figure(Image_index); stem(Percent, compressed_SNR, 'magenta');
        title('SNR per Percent of Compressed Image');
        xlabel('Percent');
        ylabel('SNR');
        saveas(Image_index, 'Results/Section2/SNR_Diagram', 'jpg');
        
        
        
        
        Image_index                       = Image_index + 1;
        % Show wavelet of image
        figure; imshow(img_wavelet);
        title(   ['Wavelet Transform by n = ', num2str(number_of_steps), ' steps']   );
        saveas(Image_index, 'Results/Section2/Wavelet_Transform', 'jpg');
        
        
    case 3
        %% HYBRID Image Maker
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%                       You can change "set_selector" here                       %%%%%%%
        %%%%%%%                                      _||_                                      %%%%%%%
        %%%%%%%                                      \  /                                      %%%%%%%
        %%%%%%%                                       \/                                       %%%%%%
        
        
        % rgb_or_gray
                                                % 0: Gray
                                                % 1: RGB
        
                                                
        % number_of_steps
                                                % number of 2D-wavelet transform
                                                % applied steps
        
                                                
        % image_selector1
        
        
        
        
        set_selector                        = 1;
                                                % 1 : Man/Woman
                                                % 2 : Baby/Grandpa
                                                
      
        switch set_selector
            case 1
                
                image_selector1             = 3;
                image_selector2             = 4;
                number_of_steps             = 4;
                rgb_or_gray                 = 1;
                       
                
            case 2
                
                image_selector1             = 5;
                image_selector2             = 6;
                number_of_steps             = 5;
                rgb_or_gray                 = 1;
                                                
                
        end
        %%%%%%%                                       /\                                       %%%%%%%
        %%%%%%%                                      /  \                                      %%%%%%%
        %%%%%%%                                       ||                                       %%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        % Import Image
        if (rgb_or_gray == 1)
            img1                            = im2double(imread([num2str(image_selector1),'.jpg']));
            img2                            = im2double(imread([num2str(image_selector2),'.jpg']));
        else
            img1                            = im2double(rgb2gray(imread([num2str(image_selector1),'.jpg'])));
            img2                            = im2double(rgb2gray(imread([num2str(image_selector2),'.jpg'])));
        end
        
        % Fix Image Sizes
        images_min_size = min (size(img1(:, :, 1)), size(img2(:, :, 1)));
        
        im1(:, :, 1)                        = imresize(img1(:, :, 1), images_min_size);
        im2(:, :, 1)                        = imresize(img2(:, :, 1), images_min_size);
        
        if (size(img1,3) > 1)
            for k = 2:size(img1,3)
                im1(:, :, k)                = imresize(img1(:, :, k), images_min_size);
                im2(:, :, k)                = imresize(img2(:, :, k), images_min_size);
            end
        end
        
        % Show the two images we plan on creating a hybrid image from
        figure(1);
        subplot(1,2,1); imshow(im1);
        subplot(1,2,2); imshow(im2);
        saveas(1, 'Results/Section3/Pictures', 'jpg');
        
        
        % create hybrid images
        [hybrid_img(:, :, 1)]               = Hybrid_Image_Maker(im1(:, :, 1), im2(:, :, 1),...
                                        h1, h2, h3, h4, number_of_steps);
        if (size(im1,3) > 1)
            for k = 2:size(im1,3)
                [hybrid_img(:, :, k)]       = Hybrid_Image_Maker(im1(:, :, k), im2(:, :, k),...
                                        h1, h2, h3, h4, number_of_steps);
            end
        end
                            
                            
        figure(2); imshow(hybrid_img);
        title('Hybrid Image');
        
        % save results
        saveas(2, 'Results/Section3/Hybrid_Image', 'jpg');
        
        
end