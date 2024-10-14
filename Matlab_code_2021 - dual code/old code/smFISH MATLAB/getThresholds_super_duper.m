%%
% this function is better than the standard one that use the # spots vs
% threshold plot. Here, I show spots around the AC and determine the threshold
% by clicking on individual spots

function getThresholds_super_duper (n_expt, path, channels) 

%%
% clear all;
% chn=2;
% n_expt=5;
% channels={'A594', 'Cy5'};
% path='E:\Jeroen\fixed_worms\7-26-2010\Egl-17_A594_Lag-2_Cy5\';

global machine

extension='.tif';
W=200; H=200;

% which cell to center on
% lbl='a','b';
 lbl='a';

%% load POI data and find P6.p

ana_path=[path '/analyzed/'];
load([ana_path sprintf('POI%04d.mat', n_expt)], 'POI');

n=-1;
for i=1:length(POI)
    if POI(i).lbl==lbl
        n=i;
    end
end

x=POI(n).pos(1);
y=POI(n).pos(2);
z=POI(n).pos(3);
ROI=round([x-W/2 y-H/2 W H]);

%% load previously collected threshold data

outfile=sprintf('spotThresholds%04d.mat', n_expt);
if exist([ana_path outfile],'file')
    load([ana_path outfile], 'data', 'spotThreshold', 'W', 'H', 'lbl');
else
    data=[];
    for chn=1:length(channels)
        data(chn).spots=[];
    end
    th=666e66;
end
%% loop over all channels

for chn=1:length(channels)

%% find threshold by clicking on proper spots

    cont=1;

    if ~isempty(data(chn).spots)
        nn=size(data(chn).spots,1);
        th=spotThreshold(chn);
    else
        nn=0;
        th=666e66;
    end
    th
    
    [im, im_f, im2] = getStack(path, channels{chn}, ROI, extension, n_expt, z);
    bwl=im_f>=th;

    if strcmp(machine, 'UNIX')
        % this position gives largest possible window on my MacBook
        figure('position', [600 0 650 630]); axes('position', [0.01 0.01 0.99 0.99]);
    end

    while cont
        cla;
        A=mat2gray(im);
        if strcmp(machine, 'UNIX')
            imshow(makeRGB(A+0.2*bwl,A,A)); hold on;
        elseif strcmp(machine, 'Windows')
            imshow(makeRGB(A+0.2*bwl,A,A), 'In', 300); hold on;
        end
        title(sprintf('expt:%d', n_expt));

        if nn>0
            r=find(data(chn).spots(:,3)==z);
            q=find(data(chn).spots(:,3)~=z);
            if ~isempty(r)
                plot(data(chn).spots(r,1), data(chn).spots(r,2), 'or');
            end
            if ~isempty(q)
                plot(data(chn).spots(q,1), data(chn).spots(q,2), 'ow');
            end
        end        
        hold off;

        [x,y,b]=ginput(1);

        if b==27
            cont=0;
        elseif (b==127 & strcmp(machine, 'Windows')) | (b==8 & strcmp(machine, 'UNIX'))
            % find spots to delete
            mindist2=66e6; del=-1;
            for i=1:nn
                X=data(chn).spots(i,1); Y=data(chn).spots(i,2);
                dist2=(X-x)^2+(Y-y)^2;
                if dist2<mindist2
                   mindist2=dist2;
                   del=i;
                end
            end

            % delete it
            data(chn).spots(del,:)=[];
            nn=nn-1;

            % recalculate threshold
            if ~isempty(data(chn).spots)
                th=min(data(chn).spots(:,4));
            else
                th=66e6;
            end
            bwl=im_f>=th;
            
        elseif b==119 || b==114
            % 119: w - z=z+1
            % 114: r - z=z+5
            if b==119
                dz=1;
            else
                dz=5;
            end
            z=z+dz;
            if z>29
                z=29;
            end
            
            [im, im_f, im2] = getStack(path, channels{chn}, ROI, extension, n_expt, z);
            bwl=im_f>=th;

        elseif b==113 || b==101
            % 113: q - z=z-1
            % 101: e - z=z-5
            if b==113
                dz=1;
            else
                dz=5;
            end
            z=z-dz;
            if z<1
                z=1;
            end
            
            [im, im_f, im2] = getStack(path, channels{chn}, ROI, extension, n_expt, z);
            bwl=im_f>=th;

        else
            nn=nn+1;
            x=round(x);
            y=round(y);
            data(chn).spots(nn,1)=x;
            data(chn).spots(nn,2)=y;
            data(chn).spots(nn,3)=z;
            data(chn).spots(nn,4)=im2(y,x);

            th=min(data(chn).spots(:,4));
            fprintf('chn:%d ', chn);
            for i=1:nn
                fprintf('%d ', data(chn).spots(i,4));
            end
            fprintf(', th=%d\n', th);

            bwl=im_f>=th;
        end
    end

%%
    spotThreshold(chn)=th;
    close(gcf);
end

%% save data

outfile=sprintf('spotThresholds%04d.mat', n_expt);
save([ana_path outfile], 'data', 'spotThreshold', 'W', 'H', 'lbl');

end

function [im, im_f, im2] = getStack(path, channel, ROI, extension, n_expt, z)

    infile=sprintf(['%s%03d' extension], channel, n_expt);
    
    tmp = tiffread27([path '/' infile], z);
    im = imcrop(tmp.data, ROI);
    clear tmp;

    % filter to find spots
    H = -fspecial('log',15,1.5);
    im_f = imfilter(im,H,'replicate');

    % dilate image, used to find brightest spot within 2 pixels distance
    % later on
    se = strel('disk',2);
    im2 = imdilate(im_f,se);

end