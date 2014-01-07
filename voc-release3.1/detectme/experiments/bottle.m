%%%%%%
% TEST 1:Test a 25 picture's train&test set of bottle
initial_scale=0.5
cls='ChairBase';
% test set 
[~, test_all] = getdetector(142);
test_set = format_dataset(test_all, cls);

% detector
[detector1, ~] = getdetector(145);
model1 = format_detector(detector1);
model1.class=cls;

% visualize detector
visualizeHOG(model1.rootfilters{1}.w);

% test detector
threshold = -1000;
[rec,prec, ap, BB, ids, score, tp] = eval_svm_parfor(test_set, model1, threshold);

% show top detections
figure;
for i=1:25
    subaxis(5,5,i, 'Spacing', 0.03, 'Padding', 0, 'Margin', 0);
    im = test_all{ids(i)}{1};
    im = imresize(im, initial_scale);
    bbox = round(BB(:,i));
    showboxes(im, bbox')
    text(bbox(1),bbox(2)-10,strcat('\color{red}',num2str(score(i))),'FontSize',16)
end
figure;
% Precision Recall curves
plot(rec,prec)
ylabel('Precision')
xlabel('Recall')
title(strcat('Class:', cls))
legend( strcat('DetectMe ','(', num2str(ap), ')'))

figure;
% show positive detections
j=1;
for i=1:size(score,1)
    if tp(i)==1
        subaxis(5,5,j, 'Spacing', 0.03, 'Padding', 0, 'Margin', 0);
        j = j+1;
        im = test_all{ids(i)}{1};
        im = imresize(im, initial_scale);
        bbox = round(BB(:,i));
        showboxes(im, bbox')
        text(bbox(1),bbox(2)-10,strcat('\color{green}',num2str(score(i))),'FontSize',16)
    end
end
figure;
% show top scores
scatter(1:size(score,1), score, [], tp, 'fill')

figure;
% execution
im = test_all{2}{1};
im_resize = imresize(im, 0.4);
bbox = process(im, model1, 2.7); % detect objects
showboxes(im, bbox);          % display results




