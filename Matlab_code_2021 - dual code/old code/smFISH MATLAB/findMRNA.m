  
%%
clear all
%channels={'A594'};
channels={'Cy5'};

global machine
% machine='UNIX';
machine='Windows';

% get directory containing data
path=uigetdir;

% find all stacks that have annotated worm data
ana_path=[path '/analyzed/'];
n_expts=[];

tmp=ls([ana_path 'POI*.mat']);
if strcmp(machine, 'Windows')
    % in Windows, merge all filenames in one string, as is done for UNIX
    tmp=reshape(tmp',1,[]);
end
POI_files=regexp(tmp, 'POI\d+.mat', 'match');
for i=1:length(POI_files)
    n_expts=[n_expts sscanf(POI_files{i},'POI%d.mat')];    
end

%% log-filter mRNA imaging data and get # spot vs threshold histogram data

for i=1:length(n_expts)
    filterSpotData (n_expts(i), path, channels) 
end

%% manually get thresholds
for i=1:length(n_expts)
%     getThresholds (n_expts(i), path, channels) 
%     getThresholds_super (n_expts(i), path, channels) 
    getThresholds_super_duper (n_expts(i), path, channels) 
end

%% find spot coordinates using manual thresholds

for i=1:length(n_expts)
    findSpots (n_expts(i), path, channels) 
end

%% get # mRNA for each ROI


for i=1:length(n_expts)
%   getMRNAperVPC (n_expts(i), path, channels) 
    getMRNAperROI (n_expts(i), path, channels);
    
end

save_SpotData([path filesep 'analyzed']);