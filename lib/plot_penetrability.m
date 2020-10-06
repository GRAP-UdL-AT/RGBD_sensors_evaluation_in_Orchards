function [penetrability_Plot] = plot_penetrability (point_cloud_dist,font_Name,font_Size,code_dir,idcs)

    penetrability_Plot = figure('Position', [10 10 500 300]);
    y_min = min([point_cloud_dist(1).y_min , point_cloud_dist(2).y_min]);
    y_max = max([point_cloud_dist(1).y_max , point_cloud_dist(2).y_max]);
    point_cloud_dist(1).Depth_mean = mean(point_cloud_dist(1).data(:,2)-y_min);
    point_cloud_dist(1).Depth_std = std(point_cloud_dist(1).data(:,2)-y_min);
    point_cloud_dist(2).Depth_mean = mean(point_cloud_dist(2).data(:,2)-y_min);
    point_cloud_dist(2).Depth_std = std(point_cloud_dist(2).data(:,2)-y_min);

    edges = 0:0.1:(ceil((y_max-y_min)*10)/10);
    histogram(point_cloud_dist(1).data(:,2)-y_min,edges,'Normalization','probability','FaceColor',[0.04,0.32,0.51]);
    hold on
    histogram(point_cloud_dist(2).data(:,2)-y_min,edges,'Normalization','probability','FaceColor',[0.85,0.33,0.10]);
    ax=gca;
    %ax.XLim = [0, (floor((y_max-y_min)*10)/10)];
    ax.XLim = [0, 4];
    line([point_cloud_dist(1).Depth_mean point_cloud_dist(1).Depth_mean],get(ax,'YLim'),'LineStyle','-.','LineWidth',2,'Color',[0.03,0.22,0.35])
    line([point_cloud_dist(2).Depth_mean point_cloud_dist(2).Depth_mean],get(ax,'YLim'),'LineStyle','-.','LineWidth',2,'Color',[0.60,0.23,0.07])
    legend(strcat('K2S4 (',num2str(point_cloud_dist(1).distance),' m):',...
                    9,' Mean depth = ',num2str(point_cloud_dist(1).Depth_mean,3),' m ;',...
                    ' \sigma = ', num2str(point_cloud_dist(1).Depth_std,3),' m'),...
           strcat('K2S5 (',num2str(point_cloud_dist(2).distance),' m):',...
                    9,' Mean depth = ',num2str(point_cloud_dist(2).Depth_mean,3),' m ;',...
                    ' \sigma = ', num2str(point_cloud_dist(2).Depth_std,3),' m'));
    xlabel('Depth (m)')
    set(gca, 'FontName', font_Name,'FontSize',font_Size);
    print(fullfile(code_dir(1:idcs(end)-1),'results','08-Penetrability_Plot.png'), '-dpng', '-r600');


end