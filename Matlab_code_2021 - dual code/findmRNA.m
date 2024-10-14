%% for image processing and spot detection
clear

global machine stage  extension thresholds
machine='UNIX';
%machine='Windows';

% set to smFISH channel
rnaChn={'Cy5_'};
extension='.tif';

%rnaChn2={'Red'}
%extension='.tif';

% set saturated pixel percentage for contrast 
%thresholds=[4e-4, 1e-5, 5e-4, 1e-4];
thresholds=[4e-4, 1e-5, 5e-4]; 
%%
geneDir = '/Users/alicja/Desktop';
path = imageloading(geneDir);
ana_path = [path,'analyzed',filesep];

% extract all labelled worm numbers from POI file names
poiList = dir([ana_path,filesep,'POI*.mat']);
%poiList = string(poiList);
%poiList = ls([ana_path,filesep,'POI*.mat']);
%poiList = struct2cell(poiList.(name));
%poiList = string(poiList);
%exptAll = cellfun(@(x) sscanf(x,'POI%d.mat'),poiList).';
exptAll = cellfun(@(x)sscanf(x,'POI%d.mat'),{poiList.name});

% if a specific expt needs to be check, change
% exptAll = worm number;
clear poiList

% if a specific expt needs to be check, change
% exptAll = worm number;

%%
% create gaussian filtered mask image of each ROI
createMask (exptAll, path, rnaChn)

%%
% pick a threshold by selecting spots
manualThreshold(exptAll, path, rnaChn)

%%
% find regional maxima
detectSpots(exptAll, ana_path, rnaChn)
%%
%create a second mask 

%createMaskR (exptAll, path, rnaChn2)

%%
%get manual threshold for Red channel
%manualThresholdR(exptAll, path, rnaChn2)

%%
% detect spots for red channel

%detectSpotsR(exptAll, ana_path, rnaChn2)
%%
save_SpotData(exptAll, ana_path)
%%
%save_SpotDataR(exptAll, ana_path)
