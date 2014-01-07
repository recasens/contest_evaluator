cd /Users/mingot/Projectes/2013_mit/matlab/url-connection-matlab

[detector, images] = getdetector(73)

im = images{1,1}{1,1};

f = features(im2double(im),6)








% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% POST DETECTOR
% username = 'ramon'
% password = 'ramon'
% 
% 
% url = 'http://127.0.0.1:8000/detectors/api/'
% params = {'name','tbd','target_class','tbd','is_public','True','sizes','tbd','weights','tbd','support_vectors','tbd'};
% %"name=tbd&target_class=tbd&is_public=True&sizes=tbd&weights=tbd&support_vectors=tbd"
% %{"name":"tbd","target_class":"tbd","is_public":"True","sizes":"tbd","weights":"tbd","support_vectors":"tbd","average_image":""};
% 
% [queryString,header] = http_paramsToString(params,1); 
% 
% authString = ['Basic ',base64encode([username,':',password])]
% authHeader = http_createHeader('Authorization',authString);
% 
% % header = [header, authHeader]
%  
% % For POST:
% urlread2(url,'POST',queryString,header)
