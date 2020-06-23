## Goal

[Spec](https://drive.google.com/file/d/12GCtrW4ueeLoFflplqQ2W-DxzLkm_cTY/view?usp=sharing)


## Explaination and What Will You Get

### makeSpectrum.m

function

To produce frequency spectrum of audio input.

### myfilter.m

function

To produce lowpass, bandpass, highpass FIR filters

### HW2_Q1.m

After run HW2_Q1, you will get 
  - (1) the frequency spectrum of original audio
  - (2) the filters' shape in time domain
  - (3) the filters' distribution in frequency domain
  - (4) frequency spectrum of three audio files which is seperate from the original audio file by using the filters

Files which will be produced
  - LowPass_400.wav
  - LowPass_400_2kHZ.wav
  - BandPass_400_800.wav
  - BandPass_400_800_2kHZ.wav
  - HighPass_800.wav
  - HighPass_800_2kHZ.wav
  - Echo_one.wav
  - Echo_multiple.wav

###HW2_Q2.m

After run HW2_Q2, you will get 
  - (1) the frequency spectrum of original audio
  - (2) the original audio's shape in time domain
  - (3) the frequency spectrum of original audio after bit reduction and dithering
  - (4) the time domain shape of original audio after bit reduction and dithering 
  - (5) the frequency spectrum of original audio after bit reduction, dithering, and noise shaping
  - (6) the time domain shape of original audio after bit reduction, dithering, and noise shaping
  - (7) the frequency spectrum after recovering the audio 
  - (8) the time domain shape after recovering the audio

Files which will be produced
  - Tempest_8bit.wav
  - Tempest_Recover.wav
