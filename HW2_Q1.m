%%% HW2_Q1.m - Complete the procedure of separating HW2_mix.wav into 3 songs

%% Clean variables and screen
close all;
clear;
clc;

%% Visualization parameters (Change it if you want)
% Some Tips:
% (Tip 1) You can change the axis range to make the plotted result more clearly 
% (Tip 2) You can use subplot function to show multiple spectrums / shapes in one figure
titlefont = 15;
fontsize = 13;
LineWidth = 1.5;

%% 1. Read in input audio file ( audioread )
% y_input: input signal, fs: sampling rate
[y_input, fs] = audioread('HW2_Mix.wav');
%%% Plot example : plot the input audio
% The provided function "make_spectrum" generates frequency
% and magnitude. Use the following example to plot the spectrum.
[frequency, magnitude] = makeSpectrum(y_input, fs);
figure(1);
plot(frequency, magnitude, 'LineWidth', LineWidth); 
title('Input', 'fontsize', titlefont);
set(gca, 'fontsize', fontsize)

%% 2. Filtering 
% (Hint) Implement my_filter here
% [...] = myFilter(...);
[outputSignal_lowpass, outputFilter_lowpass] = myFilter(y_input, fs, 2001, "Blackman", "low-pass", 400);
[outputSignal_highpass, outputFilter_highpass] = myFilter(y_input, fs, 2001, "Blackman", "high-pass", 800);
[outputSignal_bandpass, outputFilter_bandpass] = myFilter(y_input, fs, 2001, "Blackman", "bandpass", [400 800]);
%%% Plot the shape of filters in Time domain
Ts = 1/fs;
dt_Filter = 0:Ts:2000/fs;
figure(2);
subplot(3,1,1);
plot(dt_Filter, outputFilter_lowpass);
title('Low-Pass Filter in Time Domain', 'fontsize', titlefont);
subplot(3,1,2);
plot(dt_Filter, outputFilter_highpass);
title('High-Pass Filter in Time Domain', 'fontsize', titlefont);
subplot(3,1,3);
plot(dt_Filter, outputFilter_bandpass);
title('Band-Pass Filter in Time Domain', 'fontsize', titlefont);
%%% Plot the spectrum of filters (Frequency Analysis)
[frequency_filter_lowpass, fraction_lowpass] = makeSpectrum(outputFilter_lowpass, fs);
[frequency_filter_highass, fraction_highpass] = makeSpectrum(outputFilter_highpass, fs);
[frequency_filter_bandpass, fraction_bandpass] = makeSpectrum(outputFilter_bandpass, fs);
figure(3);
subplot(3,1,1)
plot(frequency_filter_lowpass, fraction_lowpass);
title('Low-Pass Filter in Frequency Domain', 'fontsize', titlefont);
axis([0, 1200, 0, 1.5]);
subplot(3,1,2)
plot(frequency_filter_highass, fraction_highpass);
title('High-Pass Filter in Frequency Domain', 'fontsize', titlefont);
axis([0, 1200, 0, 1.5]);
subplot(3,1,3)
plot(frequency_filter_bandpass, fraction_bandpass);
title('Band-Pass Filter in Frequency Domain', 'fontsize', titlefont);
axis([0, 1200, 0, 1.5]);
%% 3. Save the filtered audio (audiowrite)
% Name the file 'FilterName_para1_para2.wav'
% para means the cutoff frequency that you set for the filter

% audiowrite('FilterName_para1_para2.wav', output_signal1, fs);
audiowrite("LowPass_400.wav", outputSignal_lowpass, fs);
audiowrite("HighPass_800.wav", outputSignal_highpass, fs);
audiowrite("BandPass_400_800.wav", outputSignal_bandpass, fs);
%%% Plot the spectrum of filtered signals
[frequency_lowpass, magnitude_lowpass] = makeSpectrum(outputSignal_lowpass, fs);
[frequency_highass, magnitude_highpass] = makeSpectrum(outputSignal_highpass, fs);
[frequency_bandpass, magnitude_bandpass] = makeSpectrum(outputSignal_bandpass, fs);
figure(4);
subplot(3,1,1)
plot(frequency_lowpass, magnitude_lowpass);
title('LowPass\_400.wav in Frequency Domain', 'fontsize', titlefont);
axis([0, 2000, 0, inf]);
subplot(3,1,2)
plot(frequency_highass, magnitude_highpass);
title('HighPass\_800.wav in Frequency Domain', 'fontsize', titlefont);
axis([0, 2000, 0, inf]);
subplot(3,1,3)
plot(frequency_bandpass, magnitude_bandpass);
title('BandPass\_400\_800.wav in Frequency Domain', 'fontsize', titlefont);
axis([0, 2000, 0, inf]);
%% 4, Reduce the sample rate of the three separated songs to 2kHz.
[P,Q] = rat(2000/fs);
resample_outputSignal_lowpass = resample(outputSignal_lowpass, P, Q);
resample_outputSignal_highpass = resample(outputSignal_highpass, P, Q);
resample_outputSignal_bandpass = resample(outputSignal_bandpass, P, Q);

%% 4. Save the files after changing the sampling rate
audiowrite("LowPass_400_2kHZ.wav", resample_outputSignal_lowpass, 2000);
audiowrite("HighPass_800_2kHZ.wav", resample_outputSignal_highpass, 2000);
audiowrite("BandPass_400_800_2kHZ.wav", resample_outputSignal_bandpass, 2000);


%% 5. one-fold echo and multiple-fold echo (slide #69)
one_fold_echo_outputSignal_lowpass = zeros(length(outputSignal_lowpass),1);
for n = 0:length(outputSignal_lowpass)-1
    if n - 3200 < 0
        one_fold_echo_outputSignal_lowpass(n+1) = outputSignal_lowpass(n+1) + 0;
    else    
        one_fold_echo_outputSignal_lowpass(n+1) = outputSignal_lowpass(n+1) + 0.8* outputSignal_lowpass(n-3200+1);
    end
end

mutiple_fold_echo_outputSignal_lowpass = zeros(length(outputSignal_lowpass), 1);
for n = 0:length(outputSignal_lowpass)-1
    if n - 3200 < 0
        mutiple_fold_echo_outputSignal_lowpass(n+1) = outputSignal_lowpass(n+1) + 0;
    else    
        mutiple_fold_echo_outputSignal_lowpass(n+1) = outputSignal_lowpass(n+1) + 0.8* mutiple_fold_echo_outputSignal_lowpass(n-3200+1);
    end
end

%% 5. Save the echo audios  'Echo_one.wav' and 'Echo_multiple.wav'
audiowrite("Echo_one.wav", one_fold_echo_outputSignal_lowpass, fs);

%normalize the "mutiple_fold_echo_outputSignal_lowpass" for preventing
%clipping
mutiple_fold_echo_outputSignal_lowpass = mutiple_fold_echo_outputSignal_lowpass / max(abs(mutiple_fold_echo_outputSignal_lowpass));
audiowrite("Echo_multiple.wav", mutiple_fold_echo_outputSignal_lowpass, fs);

