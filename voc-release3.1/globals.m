% Set up global variables used throughout the code

% directory for caching models, intermediate data, and results
cachedir = '/Users/a/Documents/MIT/CSAIL/voccache/';

% directory for LARGE temporary files created during training
tmpdir = '/Users/a/Documents/MIT/CSAIL/temp/';

% dataset to use
VOCyear = '2012';

% directory with PASCAL VOC development kit and dataset
VOCdevkit = ['/Users/mingot/Downloads/VOCdevkit/'];

% which development kit is being used
% this does not need to be updated
VOCdevkit2006 = false;
VOCdevkit2007 = false;
VOCdevkit2008 = false;
VOCdevkit2012 = false;
switch VOCyear
  case '2006'
    VOCdevkit2006=true;
  case '2007'
    VOCdevkit2007=true;
  case '2008'
    VOCdevkit2008=true;
case '2012'
    VOCdevkit2012=true;
    
end

