%%
function findSpots (n_expt, path, channels) 

%%
% clear all
% channels={'alexa','Cy5'};
% path='E:/Jeroen/11-10-2009/lin-12_A594_hlh-3_Cy5_N2_24_40hr/';
% 
% n_expt=11;

global machine

%% find all ROIs for which filteredSpotData exists

ana_path=[path '/analyzed/'];

% read in all ROI files for current expt
tmp=ls(sprintf('%sfilteredSpotData_*_%04d.mat', ana_path, n_expt));
if strcmp(machine, 'Windows')
    % in Windows, merge all filenames in one string, as is done for UNIX
    tmp=reshape(tmp',1,[]);
end

% find all labels that follow <ROI_>
lbl=regexp(tmp, '(?<=filteredSpotData_).', 'match');

%% load thresholds

infile=sprintf('spotThresholds%04d.mat', n_expt);
load([ana_path infile], 'spotThreshold');

%%

fprintf('\t#%d -- Finding spots\n', n_expt); 

fprintf('\t\tROI: '); 
for n=1:length(lbl)

    fprintf('%c ', lbl{n}); 
    
    % first, get filtered spot data
    infile=sprintf('filteredSpotData_%c_%04d.mat', lbl{n}, n_expt);
    load([ana_path infile], 'data_filtered', 'ROI_BB');

    for i=1:length(channels)
    
        clear rm;
        
        % find regional intensity maxima
        for z=1:size(data_filtered(i).im,3)

            % only accept pixel that are above the threshold
            tmp=double(data_filtered(i).im(:,:,z));
            bwl = tmp>spotThreshold(i);
            tmp=bwl.*tmp;

            % find regional maxima to separate spots that touch
            % if there are non-zero pixels, find regional max
            if ~isempty( find(tmp>0) ) 
                rm(:,:,z)=imregionalmax(tmp);
            else
                % oherwise, just leave as all zeroes
                rm(:,:,z)=tmp;
            end

%             subplot(2,1,1), imshow(mat2gray(tmp))
%             subplot(2,1,2), imshow(rm(:,:,z))
%             getframe
        end
        
        % find regional maxima and their coordinates
        [lab,m] = bwlabeln(rm);
        rp=regionprops(lab,'Centroid');

        
        % save coordinates and number of spots
        if length(rp)>0
            for j=1:length(rp)
                spotCoordinates(i).data(j,:)=rp(j).Centroid;
            end

            % convert spot (x,y) coordinates from ROI coordinates to full image coordinates
            for j=1:2
                spotCoordinates(i).data(:,j)=spotCoordinates(i).data(:,j)+ROI_BB(j)-1;
            end

            % save total number of spots in ROI
            n_mRNA(i)=length(rp);
        else
            spotCoordinates(i).data=[];
            n_mRNA(i)=0;
        end

    end    

    % save spot data
    outfile=sprintf('spotData_%c_%04d.mat', lbl{n}, n_expt);
    save([ana_path outfile], 'spotCoordinates', 'n_mRNA');

end
fprintf('\n'); 
