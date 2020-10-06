function [mean_density_Plot, mean_RGBdensity_Plot, sensor_results] = plot_mean_density(data_list_results,sensor_results,max_Kinect_ID,num_of_param_list,marker_Sensors,marker_Size,colour_Sensors,font_Name,font_Size,code_dir,idcs,n)
cfg;

%% Plot Resolution results
mean_density_Plot=figure('Position', [10 10 600 500]);
mean_RGBdensity_Plot=figure('Position', [10 10 600 500]);

% Quadratic fitting of Num of Points and Num of RGB Points
for Kinect_ID = 1:max_Kinect_ID
    %Comput R^2 of mean_density  for each sensor by quadratic fitting
    lux = data_list_results(data_list_results(:,4)==Kinect_ID,9);
    mean_density = data_list_results(data_list_results(:,4)==Kinect_ID,num_of_param_list+3);
    if n==1
        [p1, p2, sensor_results(Kinect_ID).Rsq_mean_density] = linear_fitting_eval(lux,mean_density);
        sensor_results(Kinect_ID).p_mean_density = [p1, p2];
    elseif n==2
        [p1, p2, p3, sensor_results(Kinect_ID).Rsq_mean_density] = quadratic_fitting_eval(lux,mean_density);
        sensor_results(Kinect_ID).p_mean_density = [p1, p2, p3];
    else
        disp('Error: Type of density curve fitting not specified. Set n=1 for linear fitting and n=2 for quadratic fitting');
        break;
    end

    
    %Comput R^2 of mean_RGBdensity  for each sensor by quadratic fitting
    mean_RGBdensity = data_list_results(data_list_results(:,4)==Kinect_ID,num_of_param_list+4);
    if n==1
        [p1, p2, sensor_results(Kinect_ID).Rsq_mean_RGBdensity] = linear_fitting_eval(lux,mean_RGBdensity);
        sensor_results(Kinect_ID).p_mean_RGBdensity = [p1, p2];
    else 
        [p1, p2, p3, sensor_results(Kinect_ID).Rsq_mean_RGBdensity] = quadratic_fitting_eval(lux,mean_RGBdensity);
        sensor_results(Kinect_ID).p_mean_RGBdensity = [p1, p2, p3];
    end
    
    %Fitting curve    
    x_values = 0.1:0.5:max(lux);
    mean_density_fit = polyval(sensor_results(Kinect_ID).p_mean_density,x_values);
    mean_RGBdensity_fit = polyval(sensor_results(Kinect_ID).p_mean_RGBdensity,x_values);
    
    %mean_density Plot
    figure(mean_density_Plot);
    if Kinect_ID > 1
        hold on
    end
    semilogx(lux, mean_density, marker_Sensors{Kinect_ID},...
            'MarkerSize',marker_Size,...
            'MarkerEdgeColor','black',...
            'MarkerFaceColor',colour_Sensors(Kinect_ID,:));
%     plot(lux, mean_density, marker_Sensors{Kinect_ID},...
%             'MarkerSize',marker_Size,...
%             'MarkerEdgeColor',colour_Sensors(Kinect_ID,:),...
%             'MarkerFaceColor',colour_Sensors(Kinect_ID,:));
    hold on
    L1 = semilogx(x_values, mean_density_fit,...
        	'Color',colour_Sensors(Kinect_ID,:));
%     L1 = plot(x_values, mean_density_fit,...
%         	'Color',colour_Sensors(Kinect_ID,:));
    L1.Annotation.LegendInformation.IconDisplayStyle = 'off';
    hold off
    grid on

    
    
    %Plot mean_RGBdensity
    figure(mean_RGBdensity_Plot);
    if Kinect_ID > 1
        hold on
    end
    semilogx(lux, mean_RGBdensity, marker_Sensors{Kinect_ID},...
            'MarkerSize',marker_Size,...
            'MarkerEdgeColor','black',...
            'MarkerFaceColor',colour_Sensors(Kinect_ID,:));
%     plot(lux, mean_RGBdensity, marker_Sensors{Kinect_ID},...
%             'MarkerSize',marker_Size,...
%             'MarkerEdgeColor',colour_Sensors(Kinect_ID,:),...
%             'MarkerFaceColor',colour_Sensors(Kinect_ID,:));
        
    hold on
    L2 = semilogx(x_values, mean_RGBdensity_fit,...
        	'Color',colour_Sensors(Kinect_ID,:));
%     L2 = plot(x_values, mean_RGBdensity_fit,...
%         	'Color',colour_Sensors(Kinect_ID,:));
    L2.Annotation.LegendInformation.IconDisplayStyle = 'off';
    hold off
    grid on
    
end

figure(mean_density_Plot);
xlabel('Illuminance (lx)')
ylabel('Mean density (points m^{-3})');
%title('Num. of points');
if n==1
    legend(strcat('K2S1    ','    (R^{2}=',num2str(sensor_results(1).Rsq_mean_density,2),9,'    y=',num2str(sensor_results(1).p_mean_density(1),2),'x+',...
                                                                                            num2str(sensor_results(1).p_mean_density(2),2),')'),...
           strcat('K2S2    ','    (R^{2}=',num2str(sensor_results(2).Rsq_mean_density,2),9,'    y=',num2str(sensor_results(2).p_mean_density(1),2),'x+',...
                                                                                            num2str(sensor_results(2).p_mean_density(2),2),')'),...
           strcat('K2S3    ','    (R^{2}=',num2str(sensor_results(3).Rsq_mean_density,2),9,'    y=',num2str(sensor_results(3).p_mean_density(1),2),'x+',...
                                                                                            num2str(sensor_results(3).p_mean_density(2),2),')'),...
           'Location','Southwest');
elseif n==2
    legend(strcat('K2S1    ','    (R^{2}=',num2str(sensor_results(1).Rsq_mean_density,2),9,'    y=',num2str(sensor_results(1).p_mean_density(1),2),'x^{2}+',...
                                                                                                num2str(sensor_results(1).p_mean_density(2),2),'x+',...
                                                                                                num2str(sensor_results(1).p_mean_density(3),2),')'),...
               strcat('K2S2    ','    (R^{2}=',num2str(sensor_results(2).Rsq_mean_density,2),9,'    y=',num2str(sensor_results(2).p_mean_density(1),2),'x^{2}+',...
                                                                                                num2str(sensor_results(2).p_mean_density(2),2),'x+',...
                                                                                                num2str(sensor_results(2).p_mean_density(3),2),')'),...
               strcat('K2S3    ','    (R^{2}=',num2str(sensor_results(3).Rsq_mean_density,2),9,'    y=',num2str(sensor_results(3).p_mean_density(1),2),'x^{2}+',...
                                                                                                num2str(sensor_results(3).p_mean_density(2),2),'x+',...
                                                                                                num2str(sensor_results(3).p_mean_density(3),2),')'),...
               'Location','Southwest');  
end


set(gca, 'FontName', font_Name,'FontSize',font_Size);
if n==1
    print(fullfile(code_dir(1:idcs(end)-1),'results','03-mean_density_Plot_linearFit.png'), '-dpng', '-r600');
elseif n==2
    print(fullfile(code_dir(1:idcs(end)-1),'results','03-mean_density_Plot_quadraticFit.png'), '-dpng', '-r600');
end   

figure(mean_RGBdensity_Plot);
xlabel('Illuminance (lx)')
ylabel('Mean density (points m^{-3})');
%title('Num. of RGB points');
if n==1
    legend(strcat('K2S1    ','    (R^{2}=',num2str(sensor_results(1).Rsq_mean_RGBdensity,2),9,'    y=',num2str(sensor_results(1).p_mean_RGBdensity(1),2),'x+',...
                                                                                                num2str(sensor_results(1).p_mean_RGBdensity(2),2),')'),...
               strcat('K2S2    ','    (R^{2}=',num2str(sensor_results(2).Rsq_mean_RGBdensity,2),9,'    y=',num2str(sensor_results(2).p_mean_RGBdensity(1),2),'x+',...
                                                                                                num2str(sensor_results(2).p_mean_RGBdensity(2),2),')'),...
               strcat('K2S3    ','    (R^{2}=',num2str(sensor_results(3).Rsq_mean_RGBdensity,2),9,'    y=',num2str(sensor_results(3).p_mean_RGBdensity(1),2),'x+',...
                                                                                                num2str(sensor_results(3).p_mean_RGBdensity(2),2),')'),...
               'Location','Southwest');
elseif n==2
    legend(strcat('K2S1    ','    (R^{2}=',num2str(sensor_results(1).Rsq_mean_RGBdensity,2),9,'    y=',num2str(sensor_results(1).p_mean_RGBdensity(1),2),'x^{2}+',...
                                                                                                num2str(sensor_results(1).p_mean_RGBdensity(2),2),'x+',...
                                                                                                num2str(sensor_results(1).p_mean_RGBdensity(3),2),')'),...
               strcat('K2S2    ','    (R^{2}=',num2str(sensor_results(2).Rsq_mean_RGBdensity,2),9,'    y=',num2str(sensor_results(2).p_mean_RGBdensity(1),2),'x^{2}+',...
                                                                                                num2str(sensor_results(2).p_mean_RGBdensity(2),2),'x+',...
                                                                                                num2str(sensor_results(2).p_mean_RGBdensity(3),2),')'),...
               strcat('K2S3    ','    (R^{2}=',num2str(sensor_results(3).Rsq_mean_RGBdensity,2),9,'    y=',num2str(sensor_results(3).p_mean_RGBdensity(1),2),'x^{2}+',...
                                                                                                num2str(sensor_results(3).p_mean_RGBdensity(2),2),'x+',...
                                                                                                num2str(sensor_results(3).p_mean_RGBdensity(3),2),')'),...
               'Location','Southwest');
end


       
set(gca, 'FontName', font_Name,'FontSize',font_Size);
if n==1
    print(fullfile(code_dir(1:idcs(end)-1),'results','04-mean_RGBdensity_Plot_linearFit.png'), '-dpng', '-r600');
elseif n==2
    print(fullfile(code_dir(1:idcs(end)-1),'results','04-mean_RGBdensity_Plot_quadraticFit.png'), '-dpng', '-r600');
end   


end