function [Illuminance_and_wind_conditions_Plot] = plot_illuminance_and_wind_conditions(data_list_results,max_Kinect_ID,marker_Sensors,marker_Size, colour_Sensors,font_Name,font_Size,code_dir,idcs)

Illuminance_and_wind_conditions_Plot = figure;
for Kinect_ID = 1:max_Kinect_ID
    t = hours(data_list_results(data_list_results(:,4)==Kinect_ID,2))+minutes(data_list_results(data_list_results(:,4)==Kinect_ID,3));
    lux = data_list_results(data_list_results(:,4)==Kinect_ID,9);
    figure(Illuminance_and_wind_conditions_Plot);
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
figure(Illuminance_and_wind_conditions_Plot);
ax = gca;
ax.YLim=[0,60000];
ax.YTick=[0,10000,20000,30000,40000,50000,60000];
wind = data_list_results(data_list_results(:,4)==1,10);
t = hours(data_list_results(data_list_results(:,4)==1,2))+minutes(data_list_results(data_list_results(:,4)==1,3));
yyaxis right
plot(t,wind,'-*','Color',[0,0.45,0.74],'MarkerSize',4);
ax2 = gca;
ax2.YColor=[0,0.45,0.6];
ax2.YLim=[0,9];
ax2.YTick=[0,1.5,3,4.5,6,7.5,9];
ylabel('Wind speed (m s^{-1})');
yyaxis left
xtickformat('hh:mm')
grid on
xlabel('Hour of the day')
ylabel('Illuminance (lx)');
legend('K2S1 illuminance','K2S2 illuminance','K2S3 illuminance','wind speed');
set(gca, 'FontName', font_Name,'FontSize',font_Size);
print(fullfile(code_dir(1:idcs(end)-1),'results','00-Illuminance_and_wind_conditions_Plot.png'), '-dpng', '-r600');

end