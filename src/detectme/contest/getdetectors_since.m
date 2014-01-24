function [detector] = getdetectors_since(time)

% Get detector and associated annotated images from server

    server = 'http://detectme.csail.mit.edu/';
    %server = 'http://128.52.128.116/';
    unix_time = floor((time-datenum(1970,1,1,0,0,0))*86400);
    
    % Get detector data
    detectorURL = strcat(server,'detectors/api/lastupdated/',num2str(unix_time),'/?format=json');
    
    detectorJSON = urlread2(detectorURL);
    detector = loadjson(detectorJSON);
    if(size(detector,1)>0)
        for i=1:size(detector,2)
            detector{i}.weights = loadjson(detector{i}.weights);
            detector{i}.sizes = loadjson(detector{i}.sizes);
            detector{i}.bias = detector{i}.weights(end);
            detector{i}.weights = detector{i}.weights(1:end-1);
        end
    end

end
