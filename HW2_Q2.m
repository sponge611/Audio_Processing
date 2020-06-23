%%% HW2_Q2.m - bit reduction -> audio dithering -> noise shaping -> low-pass filter -> audio limiting -> normalization
%%% Follow the instructions (hints) and you can finish the homework

%% Clean variables and screen
clear all;close all;clc;

%% Visualization parameters (Change it if you want)
% Some Tips:
% (Tip 1) You can change the axis range to make the plotted result more clearly 
% (Tip 2) You can use subplot function to show multiple spectrums / shapes in one figure
titlefont = 15;
fontsize = 13;
LineWidth = 1.5;

%% 1. Read in input audio file ( audioread )
[input, fs] = audioread('Tempest.wav');


%%% Plot the spectrum of input audio
[frequency, magnitude] = makeSpectrum(input, fs);
figure(1);
plot(frequency, magnitude, 'LineWidth', LineWidth); 
title('Input Spectrum', 'fontsize', titlefont);

%%% Plot the shape of input audio
Ts = 1/fs;
dt = 0:Ts:(length(input)-1)/fs;
figure(2);
plot(dt,input);
title('Input Shape', 'fontsize', titlefont);

%% 2. Bit reduction
% (Hint) The input audio signal is double (-1 ~ 1)

bit_reduction_output = zeros(length(input), 2);
for j = 1:2
    for i = 1:length(input)
        bit_reduction_output(i,j) = round(128*input(i,j))*(1/128);
        if bit_reduction_output(i,j) == 1
            bit_reduction_output(i,j) = floor(128*input(i,j))*(1/128);
        end
        if bit_reduction_output(i,j) == 1
            bit_reduction_output(i,j) = floor(128*input(i,j)-0.1)*(1/128); %To kill ampitude "1" in original signal, because floor(1) is still 1. 
        end
    end
end


%%% Save audio (audiowrite) Tempest_8bit.wav
% (Hint) remember to save the file with bit = 8
audiowrite("Tempest_8bit.wav", bit_reduction_output, fs, "BitsPerSample", 8);


%% 3. Audio dithering
% (Hint) add random noise
dithered_bit_reduction_output = zeros(length(input), 2);

for j = 1:2
    for i = 1:length(input)
        dithered_bit_reduction_output(i,j) = bit_reduction_output(i,j) +  (-1 + (1+1)*rand)/128;
    end
end

%%% Plot the spectrum of the dithered result
[dithered_bit_reduction_frequency, dithered_bit_reduction_magnitude] = makeSpectrum(dithered_bit_reduction_output, fs);
figure(3);
plot(dithered_bit_reduction_frequency, dithered_bit_reduction_magnitude, 'LineWidth', LineWidth); 
title('Dithered Result Spectrum', 'fontsize', titlefont);
figure(4);
plot(dt,dithered_bit_reduction_output);
title('Dithered Output Shape', 'fontsize', titlefont);

%% 4. First-order feedback loop for Noise shaping
% (Hint) Check the signal value. How do I quantize the dithered signal? maybe scale up first?
f_in = dithered_bit_reduction_output;
noise_shape_output = zeros(length(input),2);

c = 5;
for j = 1:2
    for i = 1:length(input)
        if i == 1   
            e = 0;
        else
            e = f_in(i-1,j) - noise_shape_output(i-1,j);
        end
        f_in(i,j) = f_in(i,j) + c * e;
        if f_in(i,j)*128 > 127 
            noise_shape_output(i,j) = 127;
        elseif f_in(i,j)*128 < -128
            noise_shape_output(i,j) = -128;
        else
            noise_shape_output(i,j) = f_in(i,j)*128;
        end
        noise_shape_output(i,j) = round(noise_shape_output(i,j));
        noise_shape_output(i,j) = noise_shape_output(i,j)/128;
    end
end



%%% Plot the spectrum of noise shaping
[noise_shape_frequency, noise_shape_magnitude] = makeSpectrum(noise_shape_output, fs);
figure(5);
plot(noise_shape_frequency, noise_shape_magnitude, 'LineWidth', LineWidth); 
title('Noise Shaping Result Spectrum', 'fontsize', titlefont);

figure(6);
plot(dt,noise_shape_output);
title('Noise Shaping Output Shape', 'fontsize', titlefont);

%% 5. Implement Low-pass filter
[noise_shape_output(:,1), ~] = myFilter(noise_shape_output(:,1), fs, 2001, "Blackman", "low-pass", 4500);
[noise_shape_output(:,2), ~] = myFilter(noise_shape_output(:,2), fs, 2001, "Blackman", "low-pass", 4500);

%% 6. Audio limiting

for j = 1:2
    for i = 1:length(input)
        if noise_shape_output(i,j)<0
            if noise_shape_output(i,j)<-0.9
                noise_shape_output(i,j) = -0.9;
            end
        else
            if noise_shape_output(i,j)>0.9
                noise_shape_output(i,j) = 0.9;
            end
        end
    end
end


%% 7. Normalization
MAX = max(abs(noise_shape_output));
peak = max(MAX);
normalization = 1 / peak;

recover_output = noise_shape_output * normalization;


%% 6. Save audio (audiowrite) Tempest_Recover.wav

audiowrite("Tempest_Recover.wav", recover_output, fs, "BitsPerSample", 8);

%%% Plot the spectrum of output audio
[recover_frequency, recover_magnitude] = makeSpectrum(recover_output, fs);
figure(7);
plot(recover_frequency, recover_magnitude, 'LineWidth', LineWidth); 
title('Recover Output Spectrum', 'fontsize', titlefont);

%%% Plot the shape of output audio
figure(8);
plot(dt,recover_output);
title('Recover Output Shape', 'fontsize', titlefont);

