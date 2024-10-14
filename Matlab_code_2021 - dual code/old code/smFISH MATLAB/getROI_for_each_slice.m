% this routine gets a ROI for spots for each individual slice in a stack

function ROI_data = getROI_for_each_slice(data, n, ROI_data, POI, range, z0, thresholds)

    global machine

    % initialze variables
    Nz=size(data(1).im,3);
    chn=-1;
    cont=1;
    z=z0;

    % find coordinates for clipping image and offset
    im_ind=[];
    for i=1:2
        S=size(data(1).im,i);
        im_ind{i}=max(range(i,1),1):min(range(i,2),S(1));
    end
    % calculate offset (important when <range> falls outside image coords
    offsetX=im_ind{2}(1);
    offsetY=im_ind{1}(1);

    % if ROI already exists, transfer to clipped image coordinates
    for i=1:Nz
        if ~isempty(ROI_data(n).data{i}.ROI)
            ROI_data(n).data{i}.ROI(:,1)=ROI_data(n).data{i}.ROI(:,1)-offsetX;
            ROI_data(n).data{i}.ROI(:,2)=ROI_data(n).data{i}.ROI(:,2)-offsetY;
        end
    end

    % make new image to display
    im = makeImage(data, im_ind, z, thresholds, chn);
    
    if strcmp(machine, 'UNIX')
        % this position gives largest possible window on my MacBook
       figure('position', [300 0 650 630]); axes('position', [0.01 0.01 0.99 0.99]);
    end

    while cont==1

        % draw image of current channel
        cla; hold off;
        if strcmp(machine, 'UNIX')
            imshow(im); hold on;
        elseif strcmp(machine, 'Windows')
            imshow(im, 'InitialMagnification', 200); hold on;
        end
%         imshow(im); hold on;

        % plot POIs
        for i=1:length(POI)
            if POI(i).lbl ~= ROI_data(n).lbl
                plot(POI(i).pos(1)-offsetX, POI(i).pos(2)-offsetY, '.y');
            else
                plot(POI(i).pos(1)-offsetX, POI(i).pos(2)-offsetY, 'oy');
            end
        end
        
        % plot other ROIs
        for i=1:length(ROI_data)
            if i~=n
                if ~isempty(ROI_data(i).data{z}.ROI)
                    outlineX=[ROI_data(i).data{z}.ROI(:,1); ROI_data(i).data{z}.ROI(1,1)]-offsetX;
                    outlineY=[ROI_data(i).data{z}.ROI(:,2); ROI_data(i).data{z}.ROI(1,2)]-offsetY;
                    plot(outlineX, outlineY, '-y');
                end
            end
        end
        

        % plot current ROI
        if ~isempty(ROI_data(n).data{z}.ROI)
            outlineX=[ROI_data(n).data{z}.ROI(:,1); ROI_data(n).data{z}.ROI(1,1)];
            outlineY=[ROI_data(n).data{z}.ROI(:,2); ROI_data(n).data{z}.ROI(1,2)];
            plot(outlineX, outlineY, '-r');
        end
        title('Get VPC ROI');   

%         x=-1; y=-1; but=-1;
        [x,y,but]=ginput(1);

        if but==113 || but==101
            % 'q' - move up in stack with DZ=1
            % 'e' - move up in stack with DZ=5

            % find step size
            dz=1;
            if but==101
                dz=5;
            end
            % change z coordinate
            z=z-dz;
            if z<1
                z=1;
            end

            % make new image to display
            im = makeImage(data, im_ind, z, thresholds, chn);

        elseif but==119 || but==114
            % 'w' - move down in stack with DZ=1
            % 'r' - move down in stack with DZ=5

            % find step size
            dz=1;
            if but==114
                dz=5;
            end
            % change z coordinate
            z=z+dz;
            if z>Nz
                z=Nz;
            end

            % make new image to display
            im = makeImage(data, im_ind, z, thresholds, chn);

        elseif but==122 || but==120 || but == 99 || but == 118 || but == 98
            % 'z','x','c' - change channel to 1,2 or 3.

            % change channel
            if but==122
                chn=1;
            elseif but==120
                chn=2;
            elseif but==99
                if length(data)>=3
                    chn=3;
                end
            elseif but==118
                chn=0;
            elseif but==98
                chn=-1;
            end

            % make new image to display
            im = makeImage(data, im_ind, z, thresholds, chn);

        elseif but==1
            % 'LMB' - add ROI point

            ROI_data(n).data{z}.ROI(end+1,:)=[x; y];
        elseif but==3
            % 'RMB' - delete ROI point

            ROI_data(n).data{z}.ROI(end,:)=[];
        elseif but==61
            % '+' - copy ROI from slice above
            if z>1
                ROI_data(n).data{z}.ROI=ROI_data(n).data{z-1}.ROI;
            end

        elseif but==45
            % '_' - copy ROI from slice above
            if z<Nz
                ROI_data(n).data{z}.ROI=ROI_data(n).data{z+1}.ROI;
            end

        elseif (but==127 & strcmp(machine, 'Windows')) | (but==8 & strcmp(machine, 'UNIX'))
            % 'del' - delete ROI from current slice
            ROI_data(n).data{z}.ROI=[];
        elseif but==32
            % 'space' - center at z0
            z=z0;
            
            % make new image to display
            im = makeImage(data, im_ind, z, thresholds, chn);

        elseif but==27
            % 'ESC' - quit

            % check whether ROIs are defined for >2 slices around z0
            do_exit=1;
            for i=z0-2:z0+2
                if isempty(ROI_data(n).data{i}.ROI)
                    do_exit=0;
                end
            end
            if do_exit
                close(gcf);
                cont=0;
            else
                h=errordlg('ROI not defined for sufficient z slices!');
                uiwait(h);
            end
        end

    end

    %% change coordinates back to those in full image
    for i=1:Nz
        if ~isempty(ROI_data(n).data{i}.ROI)
            ROI_data(n).data{i}.ROI(:,1)=ROI_data(n).data{i}.ROI(:,1)+offsetX;
            ROI_data(n).data{i}.ROI(:,2)=ROI_data(n).data{i}.ROI(:,2)+offsetY;
        end
    end

end

function im = makeImage(data, im_ind, z, thresholds, chn)  

    if chn>0
        th=stretchlim(data(chn).im(im_ind{1},im_ind{2},z), thresholds(chn));
        im=imadjust(data(chn).im(im_ind{1},im_ind{2},z), th,[]);
    elseif chn==0
        % chn=0: combine all fluorescence channels but DAPI

        % initialize images for different channels
        for q=1:2
            tmp(:,:,q)=zeros(size(data(1).im(im_ind{1},im_ind{2},1)));
        end
        
        % get proper images from <data> array
        Nchn=length(data);
        for q=1:Nchn-1
            c=q+1;
            th=stretchlim(data(c).im(im_ind{1},im_ind{2},z), thresholds(c));
            tmp(:,:,q)=imadjust(data(c).im(im_ind{1},im_ind{2},z), th,[]);
        end
        im=makeRGB(mat2gray(tmp(:,:,1)), mat2gray(tmp(:,:,2)),[]);
        
    elseif chn==-1
        % chn=-1: combine all fluorescence channels
        % initialize images for different channels
        for q=1:3
            tmp(:,:,q)=zeros(size(data(1).im(im_ind{1},im_ind{2},1)));
        end
        
        % get proper images from <data> array
        Nchn=length(data);
        for q=1:Nchn
            th=stretchlim(data(q).im(im_ind{1},im_ind{2},z), thresholds(q));
            tmp(:,:,q)=imadjust(data(q).im(im_ind{1},im_ind{2},z), th,[]);
        end
        im=makeRGB(mat2gray(tmp(:,:,2)), mat2gray(tmp(:,:,3)), mat2gray(tmp(:,:,1)) );
        
    end
        
end
