function [precision_Plot] = plot_precision(data_list_results,max_Kinect_ID, colour_Sensors,Sensor_name,num_of_param_list,font_Name,font_Size,code_dir,idcs)


precision_Plot = figure('Position', [10 10 500 900]);
for Kinect_ID = 1:max_Kinect_ID
    
    subplot(max_Kinect_ID,1,Kinect_ID);
    lux = data_list_results(data_list_results(:,4)==Kinect_ID,9);
    mean_error = data_list_results(data_list_results(:,4)==Kinect_ID,num_of_param_list+11).*1000;
    std = data_list_results(data_list_results(:,4)==Kinect_ID,num_of_param_list+12).*1000;

    n = length(data_list_results(data_list_results(:,4)==Kinect_ID,2));
    year = repmat(2014,1,n);
    month = repmat(11,1,n);
    day = repmat(6,1,n);
    hour = data_list_results(data_list_results(:,4)==Kinect_ID,2)';
    minutes = data_list_results(data_list_results(:,4)==Kinect_ID,3)';
    sdate = datenum(year,month,day,hour,minutes,minutes);

    tt=min(sdate):0.001:max(sdate);
    [sdate_unique,ia,~] = unique(sdate);
    curve = fit(sdate_unique',lux(ia),'smoothingspline','SmoothingParam',0.99999);
    yy = feval(curve, tt');

    yyaxis right
    lux(end)=NaN;
    yy(end)=NaN;
    L1 = patch(tt,yy,yy,'EdgeColor',[0,0.45,0.74],'EdgeAlpha',0.3,'LineWidth',1);
    L1.Annotation.LegendInformation.IconDisplayStyle = 'off';
    hold on
    plot(sdate,lux,'*','MarkerSize',4,'MarkerEdgeColor',[0,0.45,0.74]);
    hold on
    
    ax = gca;
    ax.YColor=[0,0.45,0.6];
    ax.YLim=[0,60000];
    %ax.YScale='log';
    %ax.YTick = [0, 1, 10, 100, 1000, 10000];
    ylabel('Illuminance (lx)');
    set(gca, 'FontName', font_Name,'FontSize',font_Size);

    yyaxis left
    errorbar(sdate, mean_error, std,'s','MarkerSize',8,'MarkerEdgeColor','black','MarkerFaceColor',colour_Sensors(Kinect_ID,:),'Color','black','LineWidth',1);
    ax2 = gca;
    ax2.YColor=[0 0 0];
    ax2.YLim=[-100,150];
    box(ax2,'on')
    datetick('x','HH:MM')
    xlabel('Hour of the day')
    ylabel('Precision (mm)');
    legend(strcat(Sensor_name{Kinect_ID},' error'),'Illuminance');
    set(gca, 'FontName', font_Name,'FontSize',font_Size);
end

print(fullfile(code_dir(1:idcs(end)-1),'results','06-Precision(Repeatability)_Plot.png'), '-dpng', '-r600');


end