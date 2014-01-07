%%%Load all the test_sets and put it in a vector
addpath(genpath('/home/ubuntu/eval_script/'))
initial_scale=0.5
cls='TrainContest';
%server = 'http://detectme.csail.mit.edu/'
server = 'http://128.52.128.116/'


NUM_CLASSES = 10;

class_name = ['person ' ; 'cat    ' ; 'bicycle' ; 'car    ' ; 'bottle ' ; 'chair  ' ; 'table  ';'sofa   ';'monitor';'mug    ']
class_name=cellstr(class_name)

test_id = zeros(NUM_CLASSES,4);

test_id(1,:) =  [141 141 141 141]; %Person
test_id(2,:) =  [141 141 141 141]; %cat
test_id(3,:) =  [141 141 141 141]; %Bicycle
test_id(4,:) =  [141 141 141 141]; %Car
test_id(5,:) =  [141 141 141 141]; %Bottle
test_id(6,:) =  [141 141 141 141]; %Chair
test_id(7,:) =  [141 141 141 141]; %Table
test_id(8,:) =  [141 141 141 141]; %Sofa
test_id(9,:) =  [141 141 141 141]; %Monitor
test_id(10,:) = [141 141 141 141]; %Mug

[~, test_all] = getdetector(test_id(1,1));
test_set = format_dataset(test_all, cls);
for i=2:size(test_id,2)
    [~, test_par] = getdetector(test_id(1,i));
    test_set_par = format_dataset(test_par, cls);
    test_set = [test_set test_set_par];
end
 test_struct = struct(char(class_name(1)),test_set); 
 
for i=2:NUM_CLASSES
    [~, test_all] = getdetector(test_id(i,1));
    test_struct.(char(class_name(i))) = format_dataset(test_all, cls);
    for j=2:size(test_id,2)
        [~, test_par] = getdetector(test_id(i,j));
        test_set_par = format_dataset(test_par, cls);
        test_struct.(char(class_name(i))) = [test_struct.(char(class_name(i))) test_set_par];
    end
end


last_iteration = datenum(1970,1,1,0,0,0);


%%Infinite Loop
while(1)
    %%Download Detector
    [new_detectors] = getdetectors_since(last_iteration);
    last_iteration = now; 
    NUM_PLAYERS = size(new_detectors,2);   
        
    for j=1:NUM_PLAYERS
        det = new_detectors{j};
        str = strtok(det.name,'_');
        index= find(ismember(class_name,str));
        if(size(index,1)>0)
            if(det.number_images<31)
	    	[ap,prec,rec] = eval_submission(det, test_struct.(char(class_name(index))));
            	url    = strcat(server,'leaderboard/api/performance/');
            	params = {'average_precision' num2str(ap) 'precision' mat2str(prec) 'recall' mat2str(rec) 'detector' num2str(det.id)};
            	[paramString,header] = http_paramsToString(params,1);
            	[output,extras] = urlread2(url,'POST',paramString,header);
	    end
        end
         
	end
    pause(60*10);
end



