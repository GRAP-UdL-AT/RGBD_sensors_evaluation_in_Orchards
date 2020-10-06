function [Illuminance_conditions_Plot] = plot_illuminance_conditions(data_list_results,max_Kinect_ID,marker_Sensors,marker_Size, colour_Sensors,font_Name,font_Size,code_dir,idcs)

Illuminance_conditions_Plot = figure;
for Kinect_ID = 1:max_Kinect_ID
    t = hours(data_list_results(data_list_results(:,4)==Kinect_ID,2))+minutes(data_list_results(data_list_results(:,4)==Kinect_ID,3));
    lux = data_list_results(data_list_results(:,4)==Kinect_ID,9);
    figure(Illuminance_conditions_Plot);
    if Kinect_ID > 1
        hold on
    end
    plot(t,lux, marker_Sensors{Kinect_ID},...
            'MarkerSize',marker_Size,...
            'MarkerEdgeColor','black',...
            'MarkerFaceColor',colour_Sensors(Kinect_ID,:));
    tt=(hours(data_list_results(1,2))+minutes(data_list_results(1,3))):minutes(5):(hours(data_list_results(end,2))+minutes(data_list_results(end,3)));
    [t_unique,ia,~] = unique(hours(t));
    curve = fit(t_unique,lux(ia),'smoothingspline','SmoothingParam',0.8);
    yy = feval(curve, hours(tt'));
    hold on
    L1 = plot(tt,yy,'Color',colour_Sensors(Kinect_ID,:));
    L1.Annotation.LegendInformation.IconDisplayStyle = 'off';
    hold off
end
figure(Illuminance_conditions_Plot);
xtickformat('hh:mm')
grid on
xlabel('Hour of the day')
ylabel('Illuminance (lx)');
legend('K2S1','K2S2','K2S3');
set(gca, 'FontName', font_Name,'FontSize',font_Size);
print(fullfile(code_dir(1:idcs(end)-1),'results','00-Illuminance_conditions_Plot.png'), '-dpng', '-r600');

end