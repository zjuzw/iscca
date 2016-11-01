function W=msetcca0(X,K)
% function W=msetcca(X,K)
% Multiset Canonical Correlation Analysis for learning joint spatial filters
% Input:  X -- EEG data (time x channel x subject)
%              K -- Number of extracted joint spatial filters
% Output: W -- Joint spatial filters in the columns
% 
% created by Yu Zhang, ECUST, 2013.2.12
% modified by Nai Ding, ZJU, 2015
% 
% Reference: 
%     [1] Wen Zhang, Nai Ding.
%      Time-domain analysis of neural tracking of hierarchical linguistic structures.
%      NeuroImage (in revision).
%     
%     [2] Y. Zhang, G. Zhou, J. Jin, X. Wang, A. Cichocki. 
%      Frequency recognition in SSVEP-based BCI using multiset canonical correlation analysis.
%      International Journal of Neural Systems, 24(4): 1450013, (14 pages), 2014.


nchannel=size(X,1);
W=zeros(size(X,1),K,size(X,3));
N_trial=size(X,3);

% Multiset CCA for learning joint spatial filters W
Y=[];
MaskZ = [];
for n=1:N_trial
    Y=[Y;X(:,:,n)];
    MaskZ = blkdiag(MaskZ,ones(nchannel));
end

R=cov(Y.');
S=R.*MaskZ;
[tempW,~]=eigs(R,S,K);


for n=1:N_trial
    W(:,:,n)=tempW((n-1)*nchannel+1:n*nchannel,:)./norm(tempW((n-1)*nchannel+1:n*nchannel,:));
end




