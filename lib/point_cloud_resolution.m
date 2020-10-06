function [Num_of_points, Num_of_RGBpoints, mean_density, mean_RGB_density, std_density, std_RGB_density] = point_cloud_resolution(point_cloud,radius)

    Num_of_points = size(point_cloud,1);
    ptCloud = pointCloud(point_cloud(:,1:3));
    %find number of neighbours of each point in a given radius
    for i = 1:Num_of_points
        [indices,~] = findNeighborsInRadius(ptCloud,point_cloud(i,1:3),radius);
        point_cloud(i,8) = size(indices,1) / (4*pi()*(radius^3)/3); % point cloud density in a ROI around a single point
    end

    %compute mean_density
    mean_density = mean(point_cloud(:,8));
    std_density = std(point_cloud(:,8));

    %compute number of RGB points and mean density of RGB points
    RGB_point_cloud = point_cloud(~(point_cloud(:,4)==0 &  point_cloud(:,5)==0 & point_cloud(:,6)==255),:);   
    Num_of_RGBpoints = size(RGB_point_cloud,1);
    mean_RGB_density = mean(RGB_point_cloud(:,8));
    std_RGB_density = std(RGB_point_cloud(:,8));
    
end
