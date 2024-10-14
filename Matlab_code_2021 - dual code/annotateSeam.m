clear
echo off

global machine stage channels extension ROI_labels thresholds
machine='UNIX';
%machine='Windows';

%channels={'dapi','Cy5_','GFP','Red'};
channels={'dapi','Cy5_','GFP'};
extension='.tif';
%ROI_labels={'a','s','d'};
ROI_labels={'a','s','d','f','g','h','j','k','l','n','m','t','y','u','i','o','p','1','2','3','5','6','7','8','9','0','e','v','b','+','.','<','-',',','r' };

% set saturated pixel percentage for contrast (DAPI, Cy5, GFP)
%thresholds=[5e-4, 1e-5, 15e-4,1e-4];
thresholds=[5e-4, 1e-5, 15e-4];
% master folder 
geneDir = '/Users/alicja/Desktop';

%%
% load images
% change subfolder structure here 
[path, exptNo, images] = imageloading(geneDir);

% create analysis folder
ana_path=[path,'analyzed',filesep];
if ~exist(ana_path, 'dir')
    mkdir(ana_path);
end
%%
POI = recordPOI(ana_path, images, exptNo);

%%
recordROI(ana_path, images, exptNo);

%%


% savetext(POI,exptNo);
disp(exptNo)
annotateSeam;

%%
% msg = sprintf('Do you want to Continue processing? current experiment is %s',explbl);
% dlg = questdlg(msg, 'Continue', 'End', 'End');
% if strcmpi(dlg, 'Continue')
%     coreloop
% else
%     msg = sprintf('Do you want to detect spots?');
%     dlg = questdlg(msg, 'Yes', 'No', 'No');
%     if strcmpi(dlg, 'Yes')
%         findmRNA
%     else
%     end
%     disp(exptNo)
%     pos_lbl = sprintf('%c',POI.lbl);
%     disp(pos_lbl)
%     disp('End')
% end