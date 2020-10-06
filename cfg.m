function cfg
%Load cache data?
load_cache = 1; % Set 1 if you want to load the results of the last data processed or 0 if you want to process all the data from the begining.

%processing parameters
radius_NN = 0.03; % Radius in m of points considered neighbours when computing point cloud density. This number was selected equal to the leaves width.

%plot parameters
colour_Sensors = [0.5, 0.5, 0.5 ; 0.64, 0.08, 0.18 ; 0.47,0.67,0.19];
marker_Sensors = {'diamond','square','^'};
marker_Size = 6;
line_Width = 1.5;
font_Name = 'Palatino Linotype';
font_Size = 10;
Sensor_name = {'K2S1','K2S2','K2S3','K2S4','K2S5'};

    
assignin('base','load_cache',load_cache);
assignin('base','radius_NN',radius_NN);
assignin('base','colour_Sensors',colour_Sensors);
assignin('base','marker_Sensors',marker_Sensors);
assignin('base','marker_Size',marker_Size);
assignin('base','line_Width',line_Width);
assignin('base','font_Name',font_Name);
assignin('base','font_Size',font_Size);
assignin('base','Sensor_name',Sensor_name);

end