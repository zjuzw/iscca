function Sensor2DSS_OutlierRMV(filenamesIn,dataname,filenamesOut,nodss,b,a,timerange,channels,regulation)

% function Sensor2DSS(filenamesIn,dataname,filenamesOut,nodss,b,a,timerange,channels,regulation)
% Design and apply DSS filters to a set of files.
% Each file contains data collected in one experimental condition
% The same set of DSS filters will be extracted and applied to all files.
% The DSS components of each file will be saved to a separate file.
% 
% input:
% 1. filenamesIn is a cell array containing the names of all the files
% that need to be analyzed.
% 
% 2. dataname is the name of the variable that contains data.
% The data has to be a 3-D matrix, time by channel by trial
% 
% 3. filenamesOut is a cell array containing the names for output files.
% size(filenamesOut) must equals size(filenamesIn)
% The DSS transform of each input file will be save to the corresponding
% output file, as a variable called dsscomp.
% dsscomp is time by component by trial.
% 
% 4. nodss is the number of DSS component saved to the output files
% 
% 5 (Optional): b and a are coefficients of the filter that will be applied.
% The filter is applied when estimating the DSS coefficients and
% not applied to the final output.
% The default value is 1 for a and b, i.e. not applying any filtering
% 
% 6 (Optional): timerange is a vector containing all time points involved
% in the DSS analysis. Default: all time points analyzed.
% 
% 7 (Optional): channels contains all the channels involved in the
% analysis. Default: all channels analyzed.
% 
% 8 (Optional): regulation is the regulation parameter for DSS, when
% converting the sphering correlation matrix. Default: 10^-10
% a regulation parameter larger than 10^-2 generally doesn't help
% 
% created by Nai Ding 11/14
% gahding@gmail.com
% 
% 
%%-- step one begins: parameter estimation (DSS)
if ~exist('a'), a=1;end
if ~exist('b'), b=1;end

% load data, filter data, and calculate autocorrelation matrices
% cmat1 is the sphering autocorrelation matrix
% cmat2 is the biased autocorrelation matrix
for fileno=1:length(filenamesIn)
    load(filenamesIn{fileno},dataname);
    data=eval(dataname);clear eval(dataname);disp(['loading file ' num2str(fileno)])
    

    for ch=1:size(data,2)
      y0=squeeze(data(:,ch,:));
      y0=y0-median(y0(:));
      sy=sqrt(median(y0(:).^2));
      y0(abs(y0)>sy*9)=0;
      data(:,ch,:)=y0;
    end

    for trl=1:1:size(data,3)
        data(:,:,trl)=filter(b,a,data(:,:,trl));
    end
    
    
    if exist('timerange'),data=data(timerange,:,:);end
    if exist('channels'),data=data(:,channels,:);end
    
    
    inducedclean=unfold(data);
    inducedclean = demean(inducedclean);
    cmat1(:,:,fileno)=inducedclean'*inducedclean;
    evokedclean=sum(data,3);
    evokedclean = demean(evokedclean);
    cmat2(:,:,fileno)=evokedclean'*evokedclean*size(data,3)^2;
end
% average over files
cmat2=mean(cmat2,3);cmat1=mean(cmat1,3);
if ~exist('regulation'),regulation=10.^-10;end
[todss,fromdss,ratio,pwr]=dss0(cmat1,cmat2,[],regulation);
dssinfo.todss=todss;dssinfo.fromdss=fromdss;dssinfo.ratio=ratio;dssinfo.pwr=pwr;
%%-- step one ends: parameter estimation (DSS)


%%-- step two starts: use parameters, i.e. todss, for data processing
for fileno=1:length(filenamesOut)
  load(filenamesIn{fileno},dataname)
  data=eval(dataname);clear eval(dataname);
  

  
  for ch=1:size(data,2)
    y0=squeeze(data(:,ch,:));
    y0=y0-median(y0(:));
    sy=sqrt(median(y0(:).^2));
    y0(abs(y0)>sy*9)=0;
    data(:,ch,:)=y0;
  end
  
  
  if exist('channels'),data=data(:,channels,:);end
  dsscomp=fold(unfold(data)*todss,size(data,1));   % DSS components
  clear data
  dsscomp=squeeze(dsscomp(:,1:nodss,:));
  try 
    save(filenamesOut{fileno},'dsscomp','dssinfo')
  catch
    fname=filenamesOut{fileno};
    maxposition=max(union(strfind(fname,'/'),strfind(fname,'\')));
    mkdir(fname(1:[maxposition-1]))
    save(filenamesOut{fileno},'dsscomp','dssinfo')
  end
  clear z*
end
disp('all finished');disp(' ')


