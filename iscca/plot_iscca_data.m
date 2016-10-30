clear;clc;close all;
load('.\ISC\isc_data');
% The MEG signals were decimated to 200 Hz
f=1:2e3;f=f-1;f=f/2e3;f=f*200;
t = 1:2000;t=t/200;
% Response waveform
figure(1);
for cp=1:6
    subplot(3,2,cp);
    plot(t,isc_data(:,:,cp),'color',[1 1 1]*.8);hold on;
    plot(t,mean(isc_data(:,:,cp),2),'k','linewidth',2);
    xlabel('time');
    ylabel('power');
end
% Response spectrum
figure(2);
for cp=1:6
    subplot(3,2,cp);
    fft_data = abs(fft(isc_data(:,:,cp)));
    plot(f,fft_data,'color',[1 1 1]*.8);hold on;
    plot(f,mean(fft_data,2),'k','linewidth',2);
    xlim([.5 4.5])
    xlabel('Frequency');
    ylabel('Amplitude (a.u.)');  
end