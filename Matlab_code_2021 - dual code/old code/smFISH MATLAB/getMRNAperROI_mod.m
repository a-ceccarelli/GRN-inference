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
filename='/Volumes/SAMSUNG/new data.txt';
fid=fopen(filename, 'w');

for n=1:length(lbl)

    infile=sprintf('spotData_%c_%04d.mat', lbl{n}, n_expt);
    
    load([ana_path infile], 'n_mRNA');
    fprintf(fid, 't%c\t%d\n', lbl(n), n_mRNA)
    
    %fprintf(fid, 't%d\t%c\t%d\n', lbl(n), n_expt, n_RNA);
    
    %fprintf(fid, '%c   %04d   %i\n',lbl(n), n_expt, n_RNA);
     
    % label (n in Pn.pxx)
    ROI(n).lbl=lbl{n};
    % number of mRNA spots for each channel in each Pn.p cell
    ROI(n).n_mRNA=n_mRNA;
    % number of cells in VPC lineage: 1, Pn.p; 2, Pn.px; 3, Pn.pxx
    %r=find([POI.lbl]==sprintf('%c',lbl{n}));
    %ROI(n).n_cells=length(r);
    
    
    
end

%for i=1:length(infile)
       % fprintf(fid, 't%d\t%c\t%d\n', infile{i});
    %end
%end

fclose(fid);

%% save data

fprintf('\t#%d -- Saving ROI mRNA data\n\n', n_expt); 

outfile=sprintf('ROI_mRNA%04d.mat', n_expt);
save([ana_path outfile], 'ROI');
