clear;clc;
addpath('func');
% sixteen files with different filename
subname={'R0463A','R0618A','R0601A','R0615A','R0622A','R0638A','R0642A','R0639A','R0759','R0761','R0763','R0764','R0767','R0768','R0769','R0772'};
% low-pass filter(24Hz cut-off frequency)
h=fir1(100,24/100);

X=[];Y=[];

% crete new folder
if ~isdir('.\ISC\')
    mkdir('.\ISC\');
end
for subj=1:length(subname)
    xx = [];
    % Each file contains data collected in one experimental condition.
    for condi = 1   
        filenameIn = ['.\DSS\' subname{subj} '-DSSot-' num2str(condi)];      
        load(filenameIn)
        xx=[xx mean(dsscomp(197:2196,:,:),3)']; % averaged over trials
    end
    xx=filtfilt(h,1,xx')'; % zero-phase digital filtering
    X=cat(3,X,xx); 
end

% eliminate noise peaks
for subj=1:size(X,3)
    for ch=1:size(X,1)
        sig=X(ch,:,subj);
        sig=sig-median(sig);
        sy=sqrt(median(sig.^2));
        sig(abs(sig)>sy*9)=0;
        X(ch,:,subj)=sig;
    end
end

remain_count = 6; % remaining 6 components after applying mcca

% W is the spatial filter which extracts the neural response component consistent 
% over subjects by considering the data from all subjects simultaneously.
W=msetcca(X,remain_count);
for cp=1:remain_count
    W1=W(:,cp,:);
    for subj=1:size(X,3)
        TX(:,subj)=X(:,:,subj)'*W1(:,:,subj);
    end
    isc_data(:,:,cp) = TX;
end

save('.\ISC\isc_data','isc_data','W');

