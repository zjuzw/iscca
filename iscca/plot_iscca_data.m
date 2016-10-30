clear;clc;close all;
load('.\ISC\isc_data');
f=1:1.8e3;f=f-1;f=f/1.8e3;f=f*200;
%%
figure(1);
for cp=1:6
    subplot(6,1,cp);
    plot(isc_data(:,:,cp),'color',[1 1 1]*.8);hold on;
    plot(mean(isc_data(:,:,cp),2),'k','linewidth',2);
end
%%
figure(2);
for cp=1:6
    subplot(6,1,cp);
    fft_data = abs(fft(isc_data(1:1.8e3,:,cp)));
    plot(f,fft_data,'color',[1 1 1]*.8);hold on;
    plot(f,mean(fft_data,2),'k','linewidth',2);
    xlim([.5 4.5])
end
%%
figure(3);
for cp=1:6
    subplot(6,1,cp);
    fft_data = abs(fft(isc_data(1:1.8e3,:,cp)));
    fft_timemean_data = abs(fft(mean(isc_data(1:1.8e3,:,cp),2)));
    plot(f,fft_data,'color',[1 1 1]*.8);hold on;
    plot(f,mean(fft_data,2),'k','linewidth',2);
    xlim([.5 4.5])
end