% This is a demo . 
%
% In this illustration,a 4-channel recording was simulated for 3 subjects. Each recording 
% is a mixture of an early response,a late response, and white noise. 
%
% The late response has the same waveform across subjects and is captured by the first ISCCA
% component. The waveform of the early response slightly varies across subjects and is captured 
% by the second ISCCA component. The noise signal is captured by the 3rd and the 4th ISCCA 
% components. The early response is simulated by a sawtooth signal. Its phase is identical within
% each subject across channels but varies across subjects. Both the early and the late responses 
% have random polarity and amplitude in each channel.

% In this illustration, since the data have only 4 channels, the DSS dimension reduction step is
% omitted and the mCCA is applied to the 4-channel data directly.


clear;close all;
randn('seed',0);rand('seed',.5);% random seed


amp = 1; % singal amplitude
nsubj = 3; % 3 subjects
nch = 4; % 4 channels

% generate random data
randn_values(1:2:2*nsubj,:) = randn(nsubj,nch)*2;
randn_values(2:2:2*nsubj,:) = randn(nsubj,nch);
randn_values(3,:) = -randn_values(3,:);
rand_values2 = randn(nch,2000,nsubj)*0.02;
rand_values = randn(2,2000)*0.1;

X = zeros(nch,2000,nsubj);
S = [zeros(1,400) amp*sin(2*pi*(1/400)*(1:200)) zeros(1,400)];
for subj = 1:nsubj
    npeak = floor(subj*(200/(nsubj+1)));
    si = [zeros(1,400) linspace(0,amp,npeak) linspace(amp,0,200-npeak) zeros(1,400)];
    ns=randn(4,2)*rand_values(:,:);
    ns=zscore(ns')'/20;
    X(:,:,subj) = [si'*randn_values(2*subj-1,:); S'*randn_values(2*subj,:)]' + ns +rand_values2(:,:,nsubj);
end
for ch=1:nch
  X(ch,:,:)=X(ch,:,:)+ch;
end

% plot the simulative waveform
figure(1);
for subj =1:nsubj
    subplot(nsubj,1,subj);
    plot(squeeze(X(:,:,subj))');
    axis tight;
    ylim([-1 7])
end


% The spatial filter is calculated and applyed to the simulative data
isc_count = 4; % remain 4 components
W=msetcca(X,isc_count);
for plotindex=1:isc_count
    W0=real(W(:,plotindex,:));
    for subj=1:size(X,3)
        TX(:,subj)=X(:,:,subj)'*W0(:,:,subj);
    end
    ISC_data(:,:,plotindex) = TX; 
end

dss_isc_cp = ISC_data;

% plot four ISCCA components
figure(2);

for subj =1:nsubj
    subplot(nsubj,1,subj);hold on
    plot(zscore(squeeze(ISC_data(:,subj,1))));
    plot(zscore(squeeze(ISC_data(:,subj,2)))-5*1.4);
    plot(zscore(squeeze(ISC_data(:,subj,3)))-10*1.4);
    plot(zscore(squeeze(ISC_data(:,subj,4)))-15*1.4);
    axis tight;
end

