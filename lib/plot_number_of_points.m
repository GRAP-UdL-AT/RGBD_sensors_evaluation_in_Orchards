function [Num_of_points_Plot, Num_of_RGBpoints_Plot, sensor_results] = plot_number_of_points(data_list_results,sensor_results,max_Kinect_ID,num_of_param_list,marker_Sensors,marker_Size,colour_Sensors,font_Name,font_Size,code_dir,idcs,n)
cfg;

%% Plot Resolution results
Num_of_points_Plot=figure;
Num_of_RGBpoints_Plot=figure;

% Quadratic fitting of Num of Points and Num of RGB Points
for Kinect_ID = 1:max_Kinect_ID
    %Comput R^2 of Num_of_points  for each sensor by quadratic fitting
    lux = data_list_results(data_list_results(:,4)==Kinect_ID,9);
    Num_of_points = data_list_results(data_list_results(:,4)==Kinect_ID,num_of_param_list+1);
    if n==1
        [p1, p2, sensor_results(Kinect_ID).Rsq_Num_of_points] = linear_fitting_eval(lux,Num_of_points);
        sensor_results(Kinect_ID).p_Num_of_points = [p1, p2];
    elseif n==2
        [p1, p2, p3, sensor_results(Kinect_ID).Rsq_Num_of_points] = quadratic_fitting_eval(lux,Num_of_points);
        sensor_results(Kinect_ID).p_Num_of_points = [p1, p2, p3];
    else
        disp('Error: Type of Num. of points curve fitting not specified. Set n=1 for linear fitting and n=2 for quadratic fitting');
        break;
    end

    
    %Comput R^2 of Num_of_RGBpoints  for each sensor by quadratic fitting
    Num_of_RGBpoints = data_list_results(data_list_results(:,4)==Kinect_ID,num_of_param_list+2);
    if n==1
        [p1, p2, sensor_results(Kinect_ID).Rsq_Num_of_RGBpoints] = linear_fitting_eval(lux,Num_of_RGBpoints);
        sensor_results(Kinect_ID).p_Num_of_RGBpoints = [p1, p2];
    else
        [p1, p2, p3, sensor_results(Kinect_ID).Rsq_Num_of_RGBpoints] = quadratic_fitting_eval(lux,Num_of_RGBpoints);
        sensor_results(Kinect_ID).p_Num_of_RGBpoints = [p1, p2, p3];
    end
    
    %Fitting curve    
    x_values = 0.1:0.5:max(lux);
    Num_of_points_fit = polyval(sensor_results(Kinect_ID).p_Num_of_points,x_values);
    Num_of_RGBpoints_fit = polyval(sensor_results(Kinect_ID).p_Num_of_RGBpoints,x_values);
    
    %Num_of_points Plot
    figure(Num_of_points_Plot);
    if Kinect_ID > 1
        hold on
    end
    semilogx(lux, Num_of_points, marker_Sensors{Kinect_ID},...
            'MarkerSize',marker_Size,...
            'MarkerEdgeColor','black',...
            'MarkerFaceColor',colour_Sensors(Kinect_ID,:));
    hold on
    L1 = semilogx(x_values, Num_of_points_fit,...
        	'Color',colour_Sensors(Kinect_ID,:));
    L1.Annotation.LegendInformation.IconDisplayStyle = 'off';
    hold off
    grid on

    
    
    %Plot Num_of_RGBpoints
    figure(Num_of_RGBpoints_Plot);
    if Kinect_ID > 1
        hold on
    end
    semilogx(lux, Num_of_RGBpoints, marker_Sensors{Kinect_ID},...
            'MarkerSize',marker_Size,...
            'MarkerEdgeColor','black',...
            'MarkerFaceColor',colour_Sensors(Kinect_ID,:));
    hold on
    L2 = semilogx(x_values, Num_of_RGBpoints_fit,...
        	'Color',colour_Sensors(Kinect_ID,:));
    L2.Annotation.LegendInformation.IconDisplayStyle = 'off';
    hold off
    grid on
    
end

figure(Num_of_points_Plot);
xlabel('Illuminance (lx)')
ylabel('Num. of points');
%title('Num. of points');
if n==1
    legend(strcat('K2S1    ','    (R^{2}=',num2str(sensor_results(1).Rsq_Num_of_points,2),9,'    y=',num2str(sensor_results(1).p_Num_of_points(1),2),'x+',...
                                                                                            num2str(sensor_results(1).p_Num_of_points(2),2),')'),...
           strcat('K2S2    ','    (R^{2}=',num2str(sensor_results(2).Rsq_Num_of_points,2),9,'    y=',num2str(sensor_results(2).p_Num_of_points(1),2),'x+',...
                                                                                            num2str(sensor_results(2).p_Num_of_points(2),2),')'),...
           strcat('K2S3    ','    (R^{2}=',num2str(sensor_results(3).Rsq_Num_of_points,2),9,'    y=',num2str(sensor_results(3).p_Num_of_points(1),2),'x+',...
                                                                                            num2str(sensor_results(3).p_Num_of_points(2),2),')'),...
           'Location','Southwest');
elseif n==2
    legend(strcat('K2S1    ','    (R^{2}=',num2str(sensor_results(1).Rsq_Num_of_points,2),9,'    y=',num2str(sensor_results(1).p_Num_of_points(1),2),'x^{2}+',...
                                                                                            num2str(sensor_results(1).p_Num_of_points(2),2),'x+',...
                                                                                            num2str(sensor_results(1).p_Num_of_points(3),2),')'),...
           strcat('K2S2    ','    (R^{2}=',num2str(sensor_results(2).Rsq_Num_of_points,2),9,'    y=',num2str(sensor_results(2).p_Num_of_points(1),2),'x^{2}+',...
                                                                                            num2str(sensor_results(2).p_Num_of_points(2),2),'x+',...
                                                                                            num2str(sensor_results(2).p_Num_of_points(3),2),')'),...
           strcat('K2S3    ','    (R^{2}=',num2str(sensor_results(3).Rsq_Num_of_points,2),9,'    y=',num2str(sensor_results(3).p_Num_of_points(1),2),'x^{2}+',...
                                                                                            num2str(sensor_results(3).p_Num_of_points(2),2),'x+',...
                                                                                            num2str(sensor_results(3).p_Num_of_points(3),2),')'),...
           'Location','Southwest');
end
set(gca, 'FontName', font_Name,'FontSize',font_Size);
if n==1
    print(fullfile(code_dir(1:idcs(end)-1),'results','01-Num_of_points_Plot_linearFit.png'), '-dpng', '-r600');
elseif n==2
    print(fullfile(code_dir(1:idcs(end)-1),'results','01-Num_of_points_Plot_quadraticFit.png'), '-dpng', '-r600');
end

figure(Num_of_RGBpoints_Plot);
xlabel('Illuminance (lx)')
ylabel('Num. of points');
%title('Num. of RGB points');
if n==1
    legend(strcat('K2S1    ','    (R^{2}=',num2str(sensor_results(1).Rsq_Num_of_RGBpoints,2),9,'    y=',num2str(sensor_results(1).p_Num_of_RGBpoints(1),2),'x+',...
                                                                                            num2str(sensor_results(1).p_Num_of_RGBpoints(2),2),')'),...
           strcat('K2S2    ','    (R^{2}=',num2str(sensor_results(2).Rsq_Num_of_RGBpoints,2),9,'    y=',num2str(sensor_results(2).p_Num_of_RGBpoints(1),2),'x+',...
                                                                                            num2str(sensor_results(2).p_Num_of_RGBpoints(2),2),')'),...
           strcat('K2S3    ','    (R^{2}=',num2str(sensor_results(3).Rsq_Num_of_RGBpoints,2),9,'    y=',num2str(sensor_results(3).p_Num_of_RGBpoints(1),2),'x+',...
                                                                                            num2str(sensor_results(3).p_Num_of_RGBpoints(2),2),')'),...
           'Location','Southwest');
elseif n==2
    legend(strcat('K2S1    ','    (R^{2}=',num2str(sensor_results(1).Rsq_Num_of_RGBpoints,2),9,'    y=',num2str(sensor_results(1).p_Num_of_RGBpoints(1),2),'x^{2}+',...
                                                                                            num2str(sensor_results(1).p_Num_of_RGBpoints(2),2),'x+',...
                                                                                            num2str(sensor_results(1).p_Num_of_RGBpoints(3),2),')'),...
           strcat('K2S2    ','    (R^{2}=',num2str(sensor_results(2).Rsq_Num_of_RGBpoints,2),9,'    y=',num2str(sensor_results(2).p_Num_of_RGBpoints(1),2),'x^{2}+',...
                                                                                            num2str(sensor_results(2).p_Num_of_RGBpoints(2),2),'x+',...
                                                                                            num2str(sensor_results(2).p_Num_of_RGBpoints(3),2),')'),...
           strcat('K2S3    ','    (R^{2}=',num2str(sensor_results(3).Rsq_Num_of_RGBpoints,2),9,'    y=',num2str(sensor_results(3).p_Num_of_RGBpoints(1),2),'x^{2}+',...
                                                                                            num2str(sensor_results(3).p_Num_of_RGBpoints(2),2),'x+',...
                                                                                            num2str(sensor_results(3).p_Num_of_RGBpoints(3),2),')'),...
           'Location','Southwest');    
end

set(gca, 'FontName', font_Name,'FontSize',font_Size);
if n==1
    print(fullfile(code_dir(1:idcs(end)-1),'results','02-Num_of_RGBpoints_Plot_linearFit.png'), '-dpng', '-r600');
elseif n==2
    print(fullfile(code_dir(1:idcs(end)-1),'results','02-Num_of_RGBpoints_Plot_quadraticFit.png'), '-dpng', '-r600');
end


end