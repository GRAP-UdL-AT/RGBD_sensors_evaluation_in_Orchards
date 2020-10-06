function [NIR_distribution_Plot,NIRc_distribution_Plot] = plot_NIR_distribution(point_cloud_dist,font_Name,font_Size,code_dir,idcs)

    NIR_distribution_Plot = figure('Position', [10 10 400 250]);
    NIR_min = min([point_cloud_dist(1).NIR_min , point_cloud_dist(2).NIR_min]);
    NIR_max = max([point_cloud_dist(1).NIR_max , point_cloud_dist(2).NIR_max]);
    point_cloud_dist(1).NIR_mean = mean(point_cloud_dist(1).data(:,7)-NIR_min);
    point_cloud_dist(1).NIR_std = std(point_cloud_dist(1).data(:,7)-NIR_min);
    point_cloud_dist(2).NIR_mean = mean(point_cloud_dist(2).data(:,7)-NIR_min);
    point_cloud_dist(2).NIR_std = std(point_cloud_dist(2).data(:,7)-NIR_min);


    edges = 0:500:(ceil(NIR_max/1000)*1000);
    histogram(point_cloud_dist(1).data(:,7),edges,'Normalization','probability','FaceColor',[0.04,0.32,0.51]);
    hold on
    histogram(point_cloud_dist(2).data(:,7),edges,'Normalization','probability','FaceColor',[0.85,0.33,0.10]);
    ax=gca;
    %ax.XLim = [0, (floor(NIR_max/1000)*1000)];
    ax.XLim = [0, 12000];
    ax.YLim = [0, 0.5];
    line([point_cloud_dist(1).NIR_mean point_cloud_dist(1).NIR_mean],get(ax,'YLim'),'LineStyle','-.','LineWidth',2,'Color',[0.03,0.22,0.35])
    line([point_cloud_dist(2).NIR_mean point_cloud_dist(2).NIR_mean],get(ax,'YLim'),'LineStyle','-.','LineWidth',2,'Color',[0.60,0.23,0.07])
    legend(strcat('K2S4 (',num2str(point_cloud_dist(1).distance),' m):',...
                    9,' Mean NIR = ',num2str(point_cloud_dist(1).NIR_mean,'%.0f'),'  ;',...
                    ' \sigma = ', num2str(point_cloud_dist(1).NIR_std,'%.0f'),' '),...
           strcat('K2S5 (',num2str(point_cloud_dist(2).distance),' m):',...
                    9,' Mean NIR = ',num2str(point_cloud_dist(2).NIR_mean,'%.0f'),'  ;',...
                    ' \sigma = ', num2str(point_cloud_dist(2).NIR_std,'%.0f'),' '));
    xlabel('NIR')
    set(gca, 'FontName', font_Name,'FontSize',font_Size);
    print(fullfile(code_dir(1:idcs(end)-1),'results','09-NIR_distirbution_Plot.png'), '-dpng', '-r600');



    NIRc_distribution_Plot = figure('Position', [10 10 400 250]);
    NIRc_min = min([point_cloud_dist(1).NIRc_min , point_cloud_dist(2).NIRc_min]);
    NIRc_max = max([point_cloud_dist(1).NIRc_max , point_cloud_dist(2).NIRc_max]);
    point_cloud_dist(1).NIRc_mean = mean(point_cloud_dist(1).data(:,8)-NIRc_min);
    point_cloud_dist(1).NIRc_std = std(point_cloud_dist(1).data(:,8)-NIRc_min);
    point_cloud_dist(2).NIRc_mean = mean(point_cloud_dist(2).data(:,8)-NIRc_min);
    point_cloud_dist(2).NIRc_std = std(point_cloud_dist(2).data(:,8)-NIRc_min);


    edges = 0:1000:(ceil(NIRc_max/10000)*10000);
    histogram(point_cloud_dist(1).data(:,8),edges,'Normalization','probability','FaceColor',[0.04,0.32,0.51]);
    hold on
    histogram(point_cloud_dist(2).data(:,8),edges,'Normalization','probability','FaceColor',[0.85,0.33,0.10]);
    ax=gca;
    %ax.XLim = [0, (floor(NIRc_max/10000)*10000)];
    ax.XLim = [0, 30000];
    ax.YLim = [0, 0.5];
    line([point_cloud_dist(1).NIRc_mean point_cloud_dist(1).NIRc_mean],get(ax,'YLim'),'LineStyle','-.','LineWidth',2,'Color',[0.03,0.22,0.35])
    line([point_cloud_dist(2).NIRc_mean point_cloud_dist(2).NIRc_mean],get(ax,'YLim'),'LineStyle','-.','LineWidth',2,'Color',[0.60,0.23,0.07])
    legend(strcat('K2S4 (',num2str(point_cloud_dist(1).distance),' m):',...
                    9,' Mean NIRc = ',num2str(point_cloud_dist(1).NIRc_mean,'%.0f'),'  ;',...
                    ' \sigma = ', num2str(point_cloud_dist(1).NIRc_std,'%.0f'),' '),...
           strcat('K2S5 (',num2str(point_cloud_dist(2).distance),' m):',...
                    9,' Mean NIRc = ',num2str(point_cloud_dist(2).NIRc_mean,'%.0f'),'  ;',...
                    ' \sigma = ', num2str(point_cloud_dist(2).NIRc_std,'%.0f'),' '));
    xlabel('NIRc')
    set(gca, 'FontName', font_Name,'FontSize',font_Size);
    print(fullfile(code_dir(1:idcs(end)-1),'results','10-NIRc_distirbution_Plot.png'), '-dpng', '-r600');


end
