<<<<<<< HEAD

%%%Add all the test_sets and put it in a vector
addpath(genpath('/home/ubuntu/contest_evaluator'))
initial_scale=0.5;
=======
%%%Load all the test_sets and put it in a vector
addpath(genpath('/Users/a/Documents/MIT/CSAIL/matlab/contest_v0'))
initial_scale=0.5
>>>>>>> 4a4cb2c58f1af3f1a5b9035f0998dfd8e2cd1b30
cls='TrainContest';
server = 'http://detectme.csail.mit.edu/';

NUM_CLASSES = 10;

class_name = ['person ' ; 'cat    ' ; 'bicycle' ; 'car    ' ; 'bottle ' ; 'chair  ' ; 'table  ';'sofa   ';'monitor';'mug    '];
class_name=cellstr(class_name);

load('LBST.mat');

last_iteration = datenum(1970,1,1,5,0,0);

%%Infinite Loop
while(1)
    %%Download Detector
    last_iteration_ts = now;
    [new_detectors] = getdetectors_since(last_iteration);
    last_iteration = last_iteration_ts; 
    NUM_PLAYERS = size(new_detectors,2);
    if(size(new_detectors,1)==0)
	NUM_PLAYERS = 0;
    end
    if(NUM_PLAYERS>0)
    	for j=1:NUM_PLAYERS
        	det = new_detectors{j};
        	[cls_name,competition] = strtok(det.name,'_');
		if(size(competition,2)>2)
			if (strcmp(competition(2:end),'competition'))
        			index= find(ismember(class_name,cls_name));
        			if(size(index,1)>0)
            				if(det.number_images<31)
	    					[ap,prec,rec] = eval_submission(det, test_set_structure.(char(class_name(index))));
            					url    = strcat(server,'leaderboard/api/performance/');
            					params = {'average_precision' num2str(ap) 'precision' mat2str(prec) 'recall' mat2str(rec) 'detector' num2str(det.id)};
            					[paramString,header] = http_paramsToString(params,1);
            					[output,extras] = urlread2(url,'POST',paramString,header);
	    				end
        			end
         
			end
		end
     	end
    end
    pause(60);
end

