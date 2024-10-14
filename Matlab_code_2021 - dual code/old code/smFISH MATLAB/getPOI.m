Nz=size(data(1).im,3);
z=round(Nz/2);
chn=1;

th=stretchlim(data(chn).im(:,:,z), ths(chn));
im=imadjust(data(chn).im(:,:,z), th,[]);

if strcmp(machine, 'UNIX')
    % this position gives largest possible window on my MacBook
    figure('position', [300 0 650 630]); axes('position', [0.01 0.01 0.99 0.99]);
end

cont=1;
while cont==1
    
    % draw image of current channel
    cla;
    hold off;
    if strcmp(machine, 'UNIX')
        imshow(im); hold on;
    elseif strcmp(machine, 'Windows')
        imshow(im, 'InitialMagnification', 300); hold on;
    end
    
    % draw all POI labels
    for i=1:length(POI)
        plot(POI(i).pos(1),POI(i).pos(2), '.r');
        text(POI(i).pos(1)+10,POI(i).pos(2)-10, POI(i).lbl, 'Color', 'r');
    end
    title('Get POIs');   
    
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
        % make new image
        th=stretchlim(data(chn).im(:,:,z), ths(chn));
        im=imadjust(data(chn).im(:,:,z), th,[]);
        
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
        % make new image
        th=stretchlim(data(chn).im(:,:,z), ths(chn));
        im=imadjust(data(chn).im(:,:,z), th,[]);
    
    elseif but==122 || but==120 || but == 99
        % 'z','x','c' - change channel to 1,2 or 3.
        
        % change channel
        if but==122
            chn=1;
        elseif but==120
            chn=2;
        elseif but==99
            if length(channels)>=3
                chn=3;
            end
        end
        % make new image
        th=stretchlim(data(chn).im(:,:,z), ths(chn));
        im=imadjust(data(chn).im(:,:,z), th,[]);
    elseif (but==127 & strcmp(machine, 'Windows')) | (but==8 & strcmp(machine, 'UNIX'))
        % 'DEL' - delete closest POI
        
        % find closest POI
        mindist2=666666; del=-1;
        N_POI=length(POI);
        for i=1:N_POI
            dist2=(POI(i).pos(1)-x)^2+(POI(i).pos(2)-y)^2;
            if (dist2<mindist2)
                mindist2=dist2;
                del=i;
            end
        end
        
        % remove closest POI
        if del ~= N_POI
            % copy last POI into the position of the deleted POI
            POI(del)=POI(N_POI);
        end
        % delete the last one
        POI(N_POI)=[];
        N_POI=N_POI-1;
        
    elseif but==27
        % 'ESC' - quit POI annotation
        
        close(gcf);
        cont=0;
    else
        % add POI (point of interest) with the current button as label
        N_POI=length(POI);
        N_POI=N_POI+1;
        POI(N_POI).pos=[x y z];
        POI(N_POI).lbl=sprintf('%c', but);
    end

end