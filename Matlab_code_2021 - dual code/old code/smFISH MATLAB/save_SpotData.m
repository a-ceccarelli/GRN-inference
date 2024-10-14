function save_SpotData(folder)

         
files = dir([folder filesep '*.mat']);
            num_files = length(files);
            if 0 ~= num_files
                file_names = cell(1,num_files);
                for k = 1:num_files
                    file_names{k} = char(files(k).name);
                end
            else
                return, 
            end;               

            if isempty(file_names) || 0 == numel(file_names), return, end;
            
            % leave only files containing needed prefix
            fnames = [];
                       for i = 1 : num_files
                           cur_name = file_names{i};
                           if strfind(cur_name,'spotData_')
                               fnames = [cellstr(cur_name) fnames];
                           end
                       end
            file_names = fnames;                                 
            num_files = numel(file_names);
            %
            
            caption = {'index' 'ROI attribute' '#Experiment' 'C1' 'C2' 'C3'};
            caption2 = {'ROI attribute' '#Experiment' 'n_mRNA'};
            
            DATA = [];            
            DATA2 = [];            
            
            for i = 1 : num_files                    
                
                load([folder filesep file_names{i}]);
                
                str = file_names{i};
                %spotData_s_0008.mat
                str = strrep(str,'.mat','');
                str = strrep(str,'spotData','');
                s = strsplit(str,'_');
                attribute = s{2};
                N_expt = str2num(s{3});
                                                                
                for k=1:n_mRNA
                    C1 = spotCoordinates.data(k,1);
                    C2 = spotCoordinates.data(k,2);
                    C3 = spotCoordinates.data(k,3);                    
                    rec = { num2str(k) attribute num2str(N_expt)  num2str(C1) num2str(C2) num2str(C3)};
                    DATA = [ DATA; rec ];                                        
                end
                
                rec2 = { attribute num2str(N_expt)  num2str(n_mRNA)};
                DATA2 = [ DATA2; rec2 ];
                                
            end
            
            DATA = [caption; DATA];
            savename = [folder filesep ['extended_mRNA_data ' datestr(now,'yyyymmddTHHMMSS') '.xls']];
            xlswrite(savename,DATA);
            
            DATA2 = [caption2; DATA2];
            savename = [folder filesep ['mRNA_data ' datestr(now,'yyyymmddTHHMMSS') '.xls']];
            xlswrite(savename,DATA2);
                        
end