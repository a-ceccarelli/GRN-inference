%%

function getMRNAperROI (n_expt, path, channels) 

%%
% clear all
% channels={'A594','Cy5'};
% extension=['.tif'];
% path='E:/Jeroen/8-13-2009/lin-12_A594_lag-1_Cy5_26-40hr';
% 
% n_expt=13;

global machine

%% load all the necessary data

ana_path=[path '/analyzed/'];

infile=sprintf('POI%04d.mat', n_expt);
load([ana_path infile], 'POI');

% read in all spotData files for current expt
tmp=ls(sprintf('%sspotData_*_%04d.mat', ana_path, n_expt));
if strcmp(machine, 'Windows')
    % in Windows, merge all filenames in one string, as is done for UNIX
    tmp=reshape(tmp',1,[]);
end

% find all labels that follow <spotData_>
lbl=regexp(tmp, '(?<=spotData_).', 'match');


%% for each Pn.p get # mRNA data

for n=1:length(lbl)

    infile=sprintf('spotData_%c_%04d.mat', lbl{n}, n_expt);
    load([ana_path infile], 'n_mRNA');

    % label (n in Pn.pxx)
    ROI(n).lbl=lbl{n};
    % number of mRNA spots for each channel in each Pn.p cell
    ROI(n).n_mRNA=n_mRNA;
    % number of cells in VPC lineage: 1, Pn.p; 2, Pn.px; 3, Pn.pxx
    r=find([POI.lbl]==sprintf('%c',lbl{n}));
    ROI(n).n_cells=length(r);
    
end

%% save data

fprintf('\t#%d -- Saving ROI mRNA data\n\n', n_expt); 

outfile=sprintf('ROI_mRNA%04d.mat', n_expt);
save([ana_path outfile], 'ROI');


DATA = [];
for n=1:length(lbl),
    
    infile=sprintf('spotData_%c_%04d.mat', lbl{n}, n_expt);
    load([ana_path infile], 'n_mRNA');
    
    % number of cells in VPC lineage: 1, Pn.p; 2, Pn.px; 3, Pn.pxx
    r=find([POI.lbl]==sprintf('%c',lbl{n}));
    n_cells=length(r);
    
    rec = {lbl{n} num2str(n_expt) num2str(n_mRNA) num2str(n_cells)};
    
    DATA = [DATA; rec];
    
end

disp(['number of experiment ' num2str(n_expt)]);

%caption = {'label' 'number of animal' 'number of mRNA' 'n_cells'};
%DATA = [caption; DATA];

xlswrite(['spotData_experiment_' num2str(n_expt) '_' datestr(now,'yyyy-mm-dd HH:MM:SS') '.xls'],DATA);


end





