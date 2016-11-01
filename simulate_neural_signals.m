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

save neural_signals X
