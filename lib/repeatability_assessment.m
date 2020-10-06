function [mean_error,std_error] = repeatability_assessment(point_clouds)
    points_dist=[];
    for i = 1:(size(point_clouds,2)-1)
        for j = (i+1):size(point_clouds,2)
            points_dist = [points_dist; distance_cloud2cloud(point_clouds(i).data, point_clouds(j).data)];       
        end   
    end
    
    mean_error = mean(points_dist);
    std_error = std(points_dist);



end
