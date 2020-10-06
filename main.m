clc
clear
tic
%setting path's
code_dir = pwd;
addpath("lib");
idcs = strfind(code_dir,filesep);
datadir = fullfile(code_dir(1:idcs(end)-1),'data');
if ~isfolder(fullfile(code_dir(1:idcs(end)-1),'results'))
   mkdir(fullfile(code_dir(1:idcs(end)-1),'results'))
end
if ~isfolder(fullfile(code_dir(1:idcs(end)-1),'results','cache'))
   mkdir(fullfile(code_dir(1:idcs(end)-1),'results','cache'))
end
% Load configuration
cfg;

if load_cache %set load_cache variable at cfg.m file.
    cache_file = fullfile(code_dir(1:idcs(end)-1),'results','cache','lightness_and_distance_evaluation_workspace.mat');
    if isfile(fullfile(code_dir(1:idcs(end)-1),'results','cache','lightness_and_distance_evaluation_workspace.mat'))
        load(fullfile(code_dir(1:idcs(end)-1),'results','cache','lightness_and_distance_evaluation_workspace.mat'));
    else
        disp('Error: No cache file found. All the data will be processed again');
        load_cache = 0;
    end
end

if ~load_cache
        % Initialize times
        T_load_data = 0;
        T_resulution = 0;
        T_precision = 0;
        T_color = 0;
        T_NIR = 0;
        T_settings = toc;

        %read data list
        t=toc;
        [data_list_num,data_list_txt,data_list_raw] = xlsread(fullfile(datadir,'data_list.csv')); 
        [data_list_dist_eval_num,data_list_dist_eval_txt,data_list_dist_eval_raw] = xlsread(fullfile(datadir,'data_list_dist_eval.csv')); 
        data_list_results = data_list_num;
        data_list_dist_results = data_list_dist_eval_num;
        data_list_dist_eval_results = data_list_dist_eval_num;
        num_of_param_list = size(data_list_num,2);
        T_load_data = T_load_data + toc-t;

        t = toc;
        max_trial_ID = max(data_list_num(:,1));
        row_ID = 1;
        T_settings = T_settings + toc - t;

        %% Point clouds processing (lightness evaluation)
        % Results structure: 
            % Resolution: data_list_results(:,num_of_param_list+1:num_of_param_list+4) = [Num_of_points, Num_of_RGBpoints, mean_density, mean_RGB_density]
            % Accuracy: data_list_results(:,num_of_param_list+5:num_of_param_list+10) = [dist_1_acc, dist_2_acc, dist_3_acc, dist_4_acc, dist_5_acc, dist_6_acc]
            % Precision: data_list_results(:,num_of_param_list+11:num_of_param_list+12) = [mean_error,std_error]
            % Color:  data_list_results(:,num_of_param_list+13:num_of_param_list+15) = [mean_H, mean_S, mean_V]
            % NIR:  data_list_results(:,num_of_param_list+16:num_of_param_list+19) = [mean_NIR, std_NIR, mean_NIRc, std_NIRc]

        for trial_ID = 1:max_trial_ID

            t = toc;
            trial_rows = data_list_num(:,1)==trial_ID;
                max_Kinect_ID = max(data_list_num(trial_rows,4));
                disp(strcat('Processing trial',9,num2str(trial_ID)));
                T_settings = T_settings + toc - t;

            for Kinect_ID = 1:max_Kinect_ID %One iteration per capture (one capture may have more than one repetition)

                t = toc;
                disp(strcat(9,'Sensor',9,num2str(Kinect_ID)));
                Kinect_ID_rows = data_list_num(:,1)==trial_ID & data_list_num(:,4)==Kinect_ID ; 
                rep_rows = unique(Kinect_ID_rows.*(1:size(Kinect_ID_rows,1))');
                rep_rows(rep_rows == 0)=[];

                % Read all repetitions of a capture
                rep_ID = 1;
                point_clouds(size(rep_rows,1)) = struct();
                T_settings = T_settings + toc - t;
                for row_ID = rep_rows'
                    disp(strcat(9,9,'Rep.',9,num2str(rep_ID)));
                    if isfile(fullfile(datadir,'point_clouds',char(data_list_txt(row_ID+1,8))))
                        % Read pointcloud
                        t = toc;
                        point_clouds(rep_ID).data = readmatrix(fullfile(datadir,'point_clouds',char(data_list_txt(row_ID+1,8))));
                        point_clouds(rep_ID).row_ID = row_ID;
                        T_load_data = T_load_data + toc - t;

                        % Compute point cloud resolution (number of points and
                        % point cloud density)
                        t = toc;
                        [Num_of_points, Num_of_RGBpoints, mean_density, mean_RGB_density, ~, ~] = point_cloud_resolution(point_clouds(rep_ID).data,radius_NN);
                        data_list_results(row_ID,num_of_param_list+1:num_of_param_list+4)=[Num_of_points, Num_of_RGBpoints, mean_density, mean_RGB_density];
                        clear Num_of_points Num_of_RGBpoints mean_density mean_RGB_density  
                        T_resulution = T_resulution + toc - t;

                        % Colour assessment
                        t = toc;
                        [mean_H, mean_S, mean_V] = compute_meanColorHSV(point_clouds(rep_ID).data);
                        data_list_results(row_ID,num_of_param_list+13:num_of_param_list+15)=[mean_H, mean_S, mean_V];
                        T_color = T_color + toc - t;

                        % NIR assessment
                        t = toc;
                        [mean_NIR, std_NIR, mean_NIRc, std_NIRc] = compute_meanNIR(point_clouds(rep_ID).data);
                        data_list_results(row_ID,num_of_param_list+16:num_of_param_list+19)=[mean_NIR, std_NIR, mean_NIRc, std_NIRc];
                        T_NIR = T_NIR + toc - t;

                    else
                       disp(strcat('Error: File ', fullfile(datadir,'point_clouds',char(data_list_txt(rep_rows(row_ID)+1,8))), 'not found'))
                    end
                    rep_ID = rep_ID + 1;
                end

                % Repeatability assessment (precision)
                disp(strcat(9,9,'Computing Repeatability Precision'));
                t = toc;
                [mean_error,std_error] = repeatability_assessment(point_clouds);
                data_list_results(rep_rows',num_of_param_list+11:num_of_param_list+12)=repmat([mean_error,std_error],size(rep_rows,1),1);
                T_precision = T_precision + toc - t;





                clear point_clouds
            end





            trial_ID = trial_ID + 1;

        end
        t = toc;
        save(fullfile(code_dir(1:idcs(end)-1),'results','cache','lightness_evaluation_workspace.mat'))
        T_settings = T_settings + toc - t;
        sensor_results(max_Kinect_ID) = struct(); %Struct used for plots

        %% Point clouds processing (distance evaluation)
        disp('Distance evaluation:');
        for i=1:2
            disp(strcat(9,'Distance ', num2str(data_list_dist_eval_num(i,5)),' m'));
            % Read pointcloud
            t = toc;
            point_cloud_dist(i).data = readmatrix(fullfile(datadir,'point_clouds',char(data_list_dist_eval_txt(i+1,8))));
            point_cloud_dist(i).distance = data_list_dist_eval_num(i,5);
            point_cloud_dist(i).y_min = min(point_cloud_dist(i).data(:,2));
            point_cloud_dist(i).y_max = max(point_cloud_dist(i).data(:,2));
            T_load_data = T_load_data + toc - t;

            % Compute point cloud resolution (number of points and
            % point cloud density)
            t = toc;
            [Num_of_points, Num_of_RGBpoints, mean_density, mean_RGB_density, std_density, std_RGB_density] = point_cloud_resolution(point_cloud_dist(i).data,radius_NN);
            data_list_dist_eval_results(i,num_of_param_list+1:num_of_param_list+4)=[Num_of_points, Num_of_RGBpoints, mean_density, mean_RGB_density];
            point_cloud_dist(i).std_density = std_density;
            point_cloud_dist(i).std_RGB_density = std_RGB_density;
            T_resulution = T_resulution + toc - t;

            % Colour assessment
            t = toc;
            [mean_H, mean_S, mean_V] = compute_meanColorHSV(point_cloud_dist(i).data);
            data_list_dist_eval_results(i,num_of_param_list+13:num_of_param_list+15)=[mean_H, mean_S, mean_V];
            T_color = T_color + toc - t;

            % NIR assessment
            t = toc;
            if data_list_dist_eval_num(i,5)==1.5
                [mean_NIR, std_NIR, mean_NIRc, std_NIRc] = compute_meanNIR(point_cloud_dist(i).data-[0 1 0 0 0 0 0]); %moving the point cloud considering the sensor position
                dist_sq = sum((point_cloud_dist(i).data(:,1:3)-[0 1 0]).^2,2);
            else
                [mean_NIR, std_NIR, mean_NIRc, std_NIRc] = compute_meanNIR(point_cloud_dist(i).data);
                dist_sq = sum(point_cloud_dist(i).data(:,1:3).^2,2);
            end
            point_cloud_dist(i).data(:,8) = point_cloud_dist(i).data(:,7).*dist_sq;
            point_cloud_dist(i).NIR_min = min(point_cloud_dist(i).data(:,7));
            point_cloud_dist(i).NIR_max = max(point_cloud_dist(i).data(:,7));
            point_cloud_dist(i).NIRc_min = min(point_cloud_dist(i).data(:,8));
            point_cloud_dist(i).NIRc_max = max(point_cloud_dist(i).data(:,8));
            data_list_dist_eval_results(i,num_of_param_list+16:num_of_param_list+19)=[mean_NIR, std_NIR, mean_NIRc, std_NIRc];
            T_NIR = T_NIR + toc - t;

        end
        t = toc;
            disp(strcat(9,'Distance evaluation results'));
            disp(strcat(9,9,'Point cloud density mean (2.5 m / 1.5 m):',9,num2str(data_list_dist_eval_results(1,num_of_param_list+3)),'points m^{-3} / ',...
                                                                    num2str(data_list_dist_eval_results(2,num_of_param_list+3)),'points m^{-3}'));
            disp(strcat(9,9,'Point cloud density std (2.5 m / 1.5 m):',9,num2str(point_cloud_dist(1).std_density),'points m^{-3} / ',...
                                                                    num2str(point_cloud_dist(2).std_density),'points m^{-3}'));
            disp(strcat(9,9,'Mean H (2.5 m / 1.5 m):',9,num2str(data_list_dist_eval_results(1,num_of_param_list+13)),' / ',...
                                                                    num2str(data_list_dist_eval_results(2,num_of_param_list+13))));
            disp(strcat(9,9,'Mean S (2.5 m / 1.5 m):',9,num2str(data_list_dist_eval_results(1,num_of_param_list+14)),' / ',...
                                                                    num2str(data_list_dist_eval_results(2,num_of_param_list+14))));
            disp(strcat(9,9,'Mean V (2.5 m / 1.5 m):',9,num2str(data_list_dist_eval_results(1,num_of_param_list+15)),' / ',...
                                                                    num2str(data_list_dist_eval_results(2,num_of_param_list+15))));
            disp(strcat(9,9,'Mean NIR (2.5 m / 1.5 m):',9,num2str(data_list_dist_eval_results(1,num_of_param_list+16)),' / ',...
                                                                    num2str(data_list_dist_eval_results(2,num_of_param_list+16))));   
            disp(strcat(9,9,'Std NIR (2.5 m / 1.5 m):',9,num2str(data_list_dist_eval_results(1,num_of_param_list+17)),' / ',...
                                                                    num2str(data_list_dist_eval_results(2,num_of_param_list+17))));   
            disp(strcat(9,9,'Mean NIRc (2.5 m / 1.5 m):',9,num2str(data_list_dist_eval_results(1,num_of_param_list+18)),' / ',...
                                                                    num2str(data_list_dist_eval_results(2,num_of_param_list+18))));    
            disp(strcat(9,9,'Std NIRc (2.5 m / 1.5 m):',9,num2str(data_list_dist_eval_results(1,num_of_param_list+19)),' / ',...
                                                                    num2str(data_list_dist_eval_results(2,num_of_param_list+19))));                       
        save(fullfile(code_dir(1:idcs(end)-1),'results','cache','lightness_and_distance_evaluation_workspace.mat'))
        T_settings = T_settings + toc - t;
end
                                                        
%% Plot Illuminance conditions
[Illuminance_and_wind_conditions_Plot] = plot_illuminance_and_wind_conditions(data_list_results,max_Kinect_ID,marker_Sensors,marker_Size, colour_Sensors,font_Name,font_Size,code_dir,idcs);
%% Plot Resolution results
[Num_of_points_Plot, Num_of_RGBpoints_Plot, sensor_results] = plot_number_of_points(data_list_results,sensor_results,max_Kinect_ID,...
                                                                                    num_of_param_list,marker_Sensors,marker_Size,...
                                                                                    colour_Sensors,font_Name,font_Size,code_dir,idcs,1);
                                                                                
[mean_density_Plot, mean_RGBdensity_Plot, sensor_results] = plot_mean_density(data_list_results,sensor_results,max_Kinect_ID,...
                                                                                    num_of_param_list,marker_Sensors,marker_Size,...
                                                                                    colour_Sensors,font_Name,font_Size,code_dir,idcs,1);
                                                                                
%% Plot accuracy

%% Plot precision
[precision_Plot] = plot_precision(data_list_results,max_Kinect_ID, colour_Sensors,Sensor_name,num_of_param_list,font_Name,font_Size,code_dir,idcs);

%% Plot spectral results
[colorNIR_Plot] = plot_colour_and_NIR(data_list_results,max_Kinect_ID,num_of_param_list,font_Name,font_Size,code_dir,idcs);
 
%% Plot Penetrability (distance assessment)
[penetrability_Plot] = plot_penetrability (point_cloud_dist,font_Name,font_Size,code_dir,idcs);

%% Plot NIR distribution (distance assessment)
[NIR_distribution_Plot,NIRc_distribution_Plot] = plot_NIR_distribution(point_cloud_dist,font_Name,font_Size,code_dir,idcs);





 
 

