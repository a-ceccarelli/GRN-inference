%%
function filterSpotData (n_expt, path, channels) 
%%

global machine

extension=['.tif'];
% n_expt=1;
H = -fspecial('log',15,1.5);

%% load annotation data
ana_path=[path '/analyzed/'];

%% find all ROIs that need to be analyzed for this expt

% read in all ROI files for current expt
tmp=ls(sprintf('%sROI_*_%04d.mat', ana_path, n_expt));
if strcmp(machine, 'Windows')
    % in Windows, merge all filenames in one string, as is done for UNIX
    tmp=reshape(tmp',1,[]);
end

% find all labels that follow <ROI_>
lbl=regexp(tmp, '(?<=ROI_).', 'match');

%% for each ROI, read data, filter and mask

fprintf('\t#%d -- Applying log filter\n\t\tROI: ', n_expt); 

for n=1:length(lbl)

    fprintf('%c ', lbl{n}); 

    clear data_filtered
    
    % read ROI from file
    infile=sprintf('%sROI_%c_%04d.mat', ana_path, lbl{n}, n_expt);
    load(infile, 'roi');    
    
%     im_ROI=zeros(1024,1024);
    
    % find ROI bounding box
    for z=1:length(roi)
        
        minX(z)=6e66; maxX(z)=-6e66;
        minY(z)=6e66; maxY(z)=-6e66;
        if ~isempty(roi{z}.ROI)
            % find min and max for x and y
            minX(z)=min(roi{z}.ROI(:,1));
            maxX(z)=max(roi{z}.ROI(:,1));
            minY(z)=min(roi{z}.ROI(:,2));
            maxY(z)=max(roi{z}.ROI(:,2));
            
%             tmp=roipoly(1024, 1024, roi{z}.ROI(:,1), roi{z}.ROI(:,2));
%             im_ROI=im_ROI|tmp;
        end
    end
    % now define bounding box for crop
    ROI_BB=round([min(minX) min(minY) max(maxX)-min(minX) max(maxY)-min(minY)]);
%     imshow(imcrop(im_ROI, ROI_BB));

    % for each z, filter and mask all fluorescence channels
    for z=1:length(roi)
        if ~isempty(roi{z}.ROI)
            
            % filter image for all channels
            for chn=1:length(channels)
                
                % read image
                infile=sprintf(['%s%03d' extension], channels{chn}, n_expt);
                tmp = tiffread27([path '/' infile], z);

                % construct ROI polygon
                mask=roipoly(1024, 1024, roi{z}.ROI(:,1), roi{z}.ROI(:,2));
                mask=imcrop(mask, ROI_BB);

                % crop original image
                im=imcrop(tmp.data, ROI_BB);
                % filter image
                im=imfilter(im,H,'replicate');
                % only select those pixels within the ROI
                im=im.*uint16(mask);

                % save result
                data_filtered(chn).im(:,:,z) = im;

            end
        else
            % if no ROI in this slice, just have empty image
            im=zeros(1024,1024);
            for chn=1:length(channels)
                data_filtered(chn).im(:,:,z)=imcrop(im, ROI_BB);
            end
        end
    end
    
    % save data in proper file
    outfile=sprintf('filteredSpotData_%c_%04d.mat', lbl{n}, n_expt);
    save([ana_path outfile], 'data_filtered', 'ROI_BB');

end
fprintf('\n');

% %% make ROI and find bounds within full image
% 
% % read in all the different ROIs and make total ROI
% ROInames='ROI';
% 
% % load AC ROI data
% infile=sprintf('%s%s%04d.mat', ana_path, ROInames, n_expt);
% load(infile, 'ROI_data');    
% 
% %%
% % find largest bounding box that contains the ROIs for all slices, use this
% % bounding box to crop full images
% 
% minX=6e66; maxX=-6e66;
% minY=6e66; maxY=-6e66;
% 
% im_ROI=zeros(1024,1024);
% for n=1:length(ROI_data)
%     for z=1:length(ROI_data(n).data)
%         if ~isempty(ROI_data(n).data{z}.ROI)
%             
%             ROIx=ROI_data(n).data{z}.ROI(:,1);
%             ROIy=ROI_data(n).data{z}.ROI(:,2);
%             
%             % get min and max of each ROI, find min and max of all
%             if min(ROIx)<minX
%                 minX=min(ROIx);
%             end
%             if max(ROIx)>maxX
%                 maxX=max(ROIx);
%             end
%             
%             if min(ROIy)<minY
%                 minY=min(ROIy);
%             end
%             if max(ROIy)>maxY
%                 maxY=max(ROIy);
%             end
%             
%         end
%     end
% end
% % define bounding box for crop
% ROI_BB=round([minX minY maxX-minX maxY-minY])
% 
% %% read data, filter and crop
% 
% H = -fspecial('log',15,1.5);
% 
% fprintf('\t#%d -- Applying log filter\n', n_expt); 
% 
% clear data_filtered
% for chn=1 %:length(channels)
%     for z=1:length(ROI_data(1).data)
% end    
% %%
%     
%     fprintf('\t\t %s: ', channels{chn}); 
% 
%     for z=1:length(ROI_data)
%         if ~isempty(ROI_data{z}.ROI)
%             
%             % read image
%             infile=sprintf(['%s%03d' extension], channels{chn}, n_expt);
%             tmp = tiffread27([path '/' infile], z);
% 
%             % construct ROI polygon
%             mask=roipoly(1024, 1024, ROI_data{z}.ROI(:,1), ROI_data{z}.ROI(:,2));
%             mask=imcrop(mask, ROI_BB);
%             
%             % crop original image
%             im=imcrop(tmp.data, ROI_BB);
%             % filter image
%             im=imfilter(im,H,'replicate');
%             % only select those pixels within the ROI
%             im=im.*uint16(mask);
%             
%             % save result
%             data_filtered(chn).im(:,:,z) = im;
%         else
%             % if no ROI in this slice, just have empty image
%             im=zeros(1024,1024);
%             data_filtered(chn).im(:,:,z)=imcrop(im, ROI_BB);
%         end
%         
%         fprintf('.'); 
% 
% %         imshow(mat2gray(data_filtered(chn).im(:,:,z)), 'In', 300)
% %         getframe
% 
%     end
%     fprintf('\n'); 
% end
% 
% 
% %% save filtered data
% 
% fprintf('\t#%d -- Saving data\n\n', n_expt);
% 
% outfile=sprintf('filteredSpotData%04d.mat', n_expt);
% save([ana_path outfile], 'data_filtered', 'ROI_BB');
% 
