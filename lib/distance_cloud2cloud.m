function points_dist = distance_cloud2cloud(ptCloud_1, ptCloud_2)

    
    if size(ptCloud_1,1)>size(ptCloud_2,1)
        ref_pc = ptCloud_1;
        comp_pc = ptCloud_2;
    else
        ref_pc = ptCloud_2;
        comp_pc = ptCloud_1;
    end
        
    points_dist = zeros(size(comp_pc,1),1);
    ptCloud_ref=pointCloud(ref_pc(:,1:3));
    
    for i = 1:size(comp_pc,1)
        [~,points_dist(i)] = findNearestNeighbors(ptCloud_ref,comp_pc(i,1:3),1);
    end

end
