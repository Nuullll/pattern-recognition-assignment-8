% kmeans
%% load test set
load('testSet.txt');

%% kmeans initialization
init(:,:,1) = [-4.822 4.607; -0.7188 -2.493; 4.377 4.864];
init(:,:,2) = [-3.594 2.857; -0.6595 3.111; 3.998 2.519];
init(:,:,3) = [-0.7188 -2.493; 0.8458 -3.59; 1.149 3.345];
init(:,:,4) = [-3.276 1.577; 3.275 2.958; 4.377 4.864];

K = size(init,1);

pick = 4;
centers = init(:,:,pick);

categories = zeros(size(testSet,1),1);

%% kmeans iteration kernel
distances = zeros(length(categories),K);
iter = 1;
centers_log = [];
for cat = 1:K
    centers_log(:,:,cat) = centers(cat,:);
end

while 1 
    iter = iter + 1;
    
    for cat = 1:K
        distances(:,cat) = sqrt(sum((testSet - centers(cat,:)).^2,2));
    end
    [~,categories] = min(distances,[],2);
    
    % calculate new centers
    tmp = centers;
    error = 0;
    for cat = 1:K
        I = find(categories == cat);
        centers(cat,:) = mean(testSet(I,:));
        error = error + sum(sum((testSet(I,:)-mean(testSet(I,:))).^2));
        centers_log(iter,:,cat) = centers(cat,:);
    end
    
    if centers == tmp
        break
    end
end

%% plot
figure;
hold on;
scatter(testSet(:,1),testSet(:,2),30,categories,'Filled');
for cat = 1:K
    h = scatter(centers_log(:,1,cat),centers_log(:,2,cat),100,flip(copper(iter)),'^');
    h.LineWidth = 2;
end

title(sprintf('iteration=%d, error=%f',iter-1,error));