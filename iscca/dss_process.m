clear;clc
addpath('func');
% Sixteen healthy young adults participated in the experiments with different filename.
subname={'R0463A','R0618A','R0601A','R0615A','R0622A','R0638A','R0642A','R0639A','R0759','R0761','R0763','R0764','R0767','R0768','R0769','R0772'};
% b and a are coefficients of the filter that will be applied.
% The filter is applied when estimating the DSS coefficients.
[b,a]=butter(4,[0.7 6]/100);
if ~isdir('.\DSS\')
    mkdir('.\DSS\');
end
for subj=1:length(subname)
    clear filenameIn filenameOut
    % Each file contains data collected in one experimental condition.
    % filenamesIn is a cell array containing the names of all the files
    % that need to be analyzed.
    % filenamesOut is a cell array containing the names for output files.
    % size(filenamesOut) must equals size(filenamesIn)
    % The DSS transform of each input file will be save to the corresponding
    % output file, as a variable called dsscomp.
    % dsscomp is time by component by trial.

    for condi = 1
        filenameIn{condi}=['.\Sensor\' subname{subj} '-CleanTap2-' num2str(1)];
        filenameOut{condi}=['.\DSS\' subname{subj} '-DSSot-' num2str(1)];
    end
    % Design and apply DSS filters to a set of files.
    % In this example, we chose the first 157 channels with timerange between 197 
    % and 2196 from 'clean' and we just saved the first 10 DSS components.
    Sensor2DSS_OutlierRMV(filenameIn,'clean',filenameOut,10,b,a,197:2196,1:157);
end
