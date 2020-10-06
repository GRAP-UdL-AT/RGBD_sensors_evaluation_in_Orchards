function  [mean_H, mean_S, mean_V] = compute_meanColorHSV(point_cloud)

    mean_HSV = mean(rgb2hsv(point_cloud(:,4:6)./255));
    mean_H = mean_HSV(1);
    mean_S = mean_HSV(2);
    mean_V = mean_HSV(3);

end
