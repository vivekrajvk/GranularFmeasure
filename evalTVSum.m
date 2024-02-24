function [ mean_f1,max_f1,sum_length,mAP,ypred ] = evalTVSum(DSno,data,filname,budget)
%evalTVSum: Evalautes the results passed by comparing with GT
%The category-wise evaluation code can be found here: https://github.com/yalesong/tvsum/tree/master/matlab

%load ydata-tvsum50.mat; % load the dataset
load(fullfile('GT', [filname '.mat']))

%refers to the shot boundary
boundfile=fullfile('GT','');

%A nx2 matrix, storing starting and end frames of the segment
segment_results = load(fullfile(boundfile,strcat(filname,'_bound')),'bound');%inferSegments(results);

% fprintf('Computing prediction performance of [ %s ]\n', ...
%     filname);


% Get prediction label
pred_lbl = convertScores(nFrames,data);

% Get predicted shot segments
pred_seg = segment_results.bound;

% Get ground-truth label
gt_lbl = user_score;

% Compute pairwise f1 scores
 ypred = solve_knapsack( pred_lbl, pred_seg, budget );
% %alternately we can keep our ranking list here. for basic Rordering
% evaluation
%ypred=pred_lbl;

for k = 1:size(gt_lbl,2)
    if DSno==3%for Cosum dataset
        ytrue{k}= gt_lbl(:,k);
    else
        ytrue{k} = solve_knapsack( gt_lbl(:,k), pred_seg, budget );
    end
    cp{k} = classperf(ytrue{k},ypred,'Positive',1,'Negative',0);
end


prec = cellfun(@(x) x.PositivePredictiveValue, cp);
rec  = cellfun(@(x) x.Sensitivity, cp);
f1 = max(0,2*(prec.*rec) ./(prec+rec));

%mean_f1 = sum(f1) / size(gt_lbl,2);
%returning all f-measures
mean_f1 = f1;
max_f1=max(f1);
sum_length=nnz(ypred)/numel(pred_lbl);
%mAP
mAP=sum(prec) / size(gt_lbl,2);

% fprintf(FILEID,'%s,%6.4f,%6.4f,%6.4f,%6.4f\n',filname,mean_f1,sum_length,max_f1,mAP);
% fclose(FILEID);
end

function out=convertScores(nFrames,input)
%convert the ranked frames into score list
if isstruct(input)
    summary=zeros(nFrames,1);
    [~,C]=size(input);
    rows=size(input(C).groupid,1);
    
    for k=1:rows
        indx=cell2mat(input(C).groupid(k,2));
        summary(indx(indx<=nFrames))=input(C).groupid{k,1};
        
    end
else
    if length(input)>=nFrames
        summary=input(1:nFrames);
    else
        
        summary=input;
        summary(end+1:nFrames)=0;
    end
end

out=summary;


end