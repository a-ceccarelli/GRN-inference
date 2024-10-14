%%

%% initialize and get filename

clear all;

global machine
% machine='UNIX';
machine='Windows';

% POI cell to analyze
% ROI_labels={'a'};
 ROI_labels={'a', 's', 'd','f', 'g', 'h','j', 'k', 'l','p'};

%%
channels={'dapi','A594','Cy5'};
%channels={'dapi','A594'};
extension=['.tif'];

[filename,path]=uigetfile('dapi*.*', 'DialogTitle', 'F:\MB\N2');
n_expt=sscanf(filename, 'dapi%d');

% get expt number from filename
for i=1:length(channels)
    qstr=[channels{i} '%d'];
    n=sscanf(filename, qstr);
    if ~isempty(n)
        n_expt=n;
    end
end

fprintf('annotating: %s\n', filename)

% load stacks of all channels
for i=1:length(channels)
    infile=sprintf(['%s%03d' extension], channels{i}, n_expt);
    
    tmp = tiffread27([path infile]);
    data(i).im = cat(3, tmp.data);
end

clear tmp i

%% get the POIs for this worm

% initialize POIs or load if already existing
ana_path=[path 'analyzed/'];
outfile=sprintf('POI%04d.mat', n_expt);
if exist([ana_path outfile],'file')
    load([ana_path outfile], 'POI');
else
    POI=[];
end

% find POIs

ths=[5e-4 1e-5 1e-5];
getPOI;

% save POI data

% check if directory exists, if not create it
ana_path=[path 'analyzed/'];
if ~exist(ana_path, 'file')
    mkdir(ana_path);
end


% write POI data to .MAT file in <ana_path>
save([ana_path sprintf('POI%04d.mat', n_expt)], 'POI');

%% find Region Of Interest for each POI

W=400;
ths=[5e-4 1e-5 1e-5];

ana_path=[path 'analyzed/'];
infile=sprintf('POI%04d.mat', n_expt);
load([ana_path infile], 'POI');

% if exists, load ROI data for this worm
for n=1:length(ROI_labels)
    outfile=sprintf('ROI_%s_%04d.mat', ROI_labels{n}, n_expt);
    if exist([ana_path outfile],'file')
        load([ana_path outfile], 'roi');
        ROI_data(n).data=roi;
        ROI_data(n).lbl=ROI_labels{n};
    else
        % if not there, initialize
        for z=1:size(data(1).im,3)
            ROI_data(n).data{z}.ROI=[];
            ROI_data(n).lbl=ROI_labels{n};
        end
    end
end
%

% get ROI for each POI
for i=1:length(ROI_labels)
    % initialize AC ROI or load if already existing

    % find coordinates of current point of interests, use to clip image

    % first, find labels among POIs
    r=find([POI.lbl]==ROI_labels{i});
    if ~isempty(r)
        % find coordinates, average if >1 cells with same label (eg Pn.px)
        for j=1:length(r)
            xAC(j)=POI(r(j)).pos(1); yAC(j)=POI(r(j)).pos(2); zAC(j)=POI(r(j)).pos(3);
        end
        xAC=mean(xAC); yAC=mean(yAC); zAC=mean(zAC);
    
        % set range for zoomed-in ROI image
        range=round([yAC-W/2 yAC+W/2; xAC-W/2 xAC+W/2]);

        % get ROI for each z slice
        ROI_data = getROI_for_each_slice(data, i, ROI_data, POI, range, zAC, ths);
    end
end

% save ROI data

% check if directory exists, if not create it
ana_path=[path 'analyzed/'];
if isempty(ls(ana_path))
    mkdir(ana_path);
end

% write ROI data to .MAT file in <ana_path>
for n=1:length(ROI_data)
    outfile=sprintf('ROI_%s_%04d.mat', ROI_data(n).lbl, n_expt);
    roi=ROI_data(n).data;
    save([ana_path outfile], 'roi');
end

% save([ana_path outfile], 'ROI_data');
