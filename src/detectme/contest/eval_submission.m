function [ap,prec,rec] = eval_submission(train_detector, test_set)

initial_scale=0.5
cls='TrainContest';


%Get detector
model1 = format_detector(train_detector);
model1.class=cls;

% test detector
threshold = -1000;
[rec,prec, ap, BB, ids, score, tp] = eval_svm_parfor(test_set, model1, threshold);

end




