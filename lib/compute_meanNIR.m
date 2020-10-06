function  [mean_NIR, std_NIR, mean_NIRc, std_NIRc] = compute_meanNIR(point_cloud)

    dist_sq = sum(point_cloud(:,1:3).^2,2);
    NIRc = point_cloud(:,7).*dist_sq;
    mean_NIR = mean(point_cloud(:,7));
    mean_NIRc = mean(NIRc);
    std_NIR = std(point_cloud(:,7));
    std_NIRc = std(NIRc);
    
end
