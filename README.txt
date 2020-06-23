1.makeSpectrum.m
function
用以產生frequency spectrum

2.myfilter.m
function
用以產生lowpass、bandpass、highpass的FIR filter

3.HW2_Q1

點開HW2_Q1.m這個script，然後點run執行
執行後會跑出
figure1 原始音檔的frequency spectrum
figure2 Filter 在 time domain的shape
figure3 Filter 在 frequency domain的分布
figure4 分出來的三個音檔的frequency spectrum

會產生
LowPass_400.wav
LowPass_400_2kHZ.wav
BandPass_400_800.wav
BandPass_400_800_2kHZ.wav
HighPass_800.wav
HighPass_800_2kHZ.wav
Echo_one.wav
Echo_multiple.wav

4.HW2_Q2
點開HW2_Q2.m這個script，然後點run執行
執行後會跑出
figure1 原始音檔的frequency spectrum
figure2 原始音檔在time domain的shape
figure3 原始音檔經過bit reduction和dithering後的frequency spectrum
figure4 原始音檔經過bit reduction和dithering後在time domain的shape
figure5 原始音檔經過bit reduction和dithering和noise shaping後的frequency spectrum
figure6 原始音檔經過bit reduction和dithering和noise shaping後在time domain的shape
figure7 Recover音訊的frequency spectrum
figure8 Recover音訊在time domain的shape

會產生
Tempest_8bit.wav
Tempest_Recover.wav