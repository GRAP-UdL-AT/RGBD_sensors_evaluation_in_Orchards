function [colorNIR_Plot] = plot_colour_and_NIR(data_list_results,max_Kinect_ID,num_of_param_list,font_Name,font_Size,code_dir,idcs)


    colorNIR_Plot = figure('Position', [10 10 600 900]);

    for Kinect_ID = 1:max_Kinect_ID
        ax(Kinect_ID) = subplot(max_Kinect_ID,1,Kinect_ID);
        lux = data_list_results(data_list_results(:,4)==Kinect_ID,9);
        H = data_list_results(data_list_results(:,4)==Kinect_ID,num_of_param_list+13);
        S = data_list_results(data_list_results(:,4)==Kinect_ID,num_of_param_list+14);
        V = data_list_results(data_list_results(:,4)==Kinect_ID,num_of_param_list+15);
        %NIR = data_list_results(data_list_results(:,4)==Kinect_ID,num_of_param_list+16)./4400;
        NIR = data_list_results(data_list_results(:,4)==Kinect_ID,num_of_param_list+16)./15000;
        NIRc = data_list_results(data_list_results(:,4)==Kinect_ID,num_of_param_list+18)./15000; 


        n = length(data_list_results(data_list_results(:,4)==Kinect_ID,2));
        year = repmat(2014,1,n);
        month = repmat(11,1,n);
        day = repmat(6,1,n);
        hour = data_list_results(data_list_results(:,4)==Kinect_ID,2)';
        minutes = data_list_results(data_list_results(:,4)==Kinect_ID,3)';
        sdate = datenum(year,month,day,hour,minutes,minutes);

        hold on
        yyaxis right
        hold on
        plot(sdate,lux,'-*','Color',[0,0.45,0.74],'MarkerSize',4);
        ax(Kinect_ID).YColor=[0,0.45,0.6];
        ax(Kinect_ID).YLim=[0,60000];
        ax(Kinect_ID).YScale='log';
        ax(Kinect_ID).YTick = [0, 1, 10, 100, 1000, 10000];
        ylabel('Illuminance (lx)');
        set(gca, 'FontName', font_Name,'FontSize',font_Size);

        yyaxis left
        plot(sdate,NIR,'-.','Color',[0.64,0.08,0.18],'LineWidth',1);
        plot(sdate,NIRc,'-','Color','r','LineWidth',1);
        C(:,:,1) = zeros(size(H,1),size(H,2));
        C(:,:,2) = zeros(size(H,1),size(H,2));
        C(:,:,3) = V;
        C(end,end,:) = NaN;
        patch(sdate,V,hsv2rgb(C),'EdgeColor','interp','LineWidth',3);
        hold on
        C(:,:,1) = ones(size(H,1),size(H,2));
        C(:,:,2) = S;
        C(:,:,3) = ones(size(H,1),size(H,2));
        C(end,end,:) = NaN;
        patch(sdate,S,hsv2rgb(C),'EdgeColor','interp','LineWidth',3);
        hold on
        C(:,:,1) = H;
        C(:,:,2) = ones(size(H,1),size(H,2));
        C(:,:,3) = ones(size(H,1),size(H,2));
        C(end,end,:) = NaN;
        patch(sdate,H,hsv2rgb(C),'EdgeColor','interp','LineWidth',3);

        ax(Kinect_ID).YLim = [0,1];
        ax(Kinect_ID).YColor=[0 0 0];
        box(ax(Kinect_ID),'on')
        datetick('x','HH:MM')
        xlabel('Hour of the day')
        ylabel(strcat('Colour (HSV) & NIR - K2S',num2str(Kinect_ID)));

        if Kinect_ID == 1
            colormap(ax(Kinect_ID),'HSV')
            H_bar=colorbar;
            H_bar.Label.String = 'Chroma (H)';
            H_bar.Label.Rotation = 0;
            H_bar.Label.Position = [0.574602955863589,1.113402598911954,0];
        elseif Kinect_ID == 2
            colormap(ax(Kinect_ID),hsv2rgb([ones(100,1),[0:0.01:0.99]',ones(100,1)]))
            S_bar=colorbar;
            S_bar.Label.String = 'Saturation (S)';    
            S_bar.Label.Rotation = 0;
            S_bar.Label.Position = [0.574602955863589,1.113402598911954,0];    
        elseif Kinect_ID == 3
            colormap(ax(Kinect_ID),'gray')
            V_bar=colorbar;
            V_bar.Label.String = 'Lightness (V)';   
            V_bar.Label.Rotation = 0;
            V_bar.Label.Position = [0.574602955863589,1.113402598911954,0];
        end

        set(gca, 'FontName', font_Name,'FontSize',font_Size);





        clear C


    end

    print(fullfile(code_dir(1:idcs(end)-1),'results','07-color_and_NIR_Plot.png'), '-dpng', '-r600');
    legend;
    print(fullfile(code_dir(1:idcs(end)-1),'results','07-color_and_NIR_Plot(legend).png'), '-dpng', '-r600');

end