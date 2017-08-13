d1 = xlsread('C:\Users\suggalvn\Downloads\data_banknote_authentication');
cm = cov(d1);

D10 = d1(d1(:,5)==0,:);
D11 = d1(d1(:,5)==1,:);
scatter(D10(:,1),D10(:,2),'k');
hold
scatter(D11(:,1),D11(:,2),'r');


TotalSize = size(d1,1);
Training = 800/TotalSize;
Validation = 200/TotalSize;
Testing = 1-(Training+Validation);
[TrainingIndexes, ValidationIndexes, TestingIndexes] = dividerand(TotalSize, Training, Validation, Testing);
TrainingSet = d1(TrainingIndexes, :);
ValidationSet = d1(ValidationIndexes, :);
TestingSet = d1(TestingIndexes, :);

TestingIndexList = TestingIndexes';

allInOneString = sprintf('%.0f,' , TestingIndexList);
allInOneString = allInOneString(1:end-1);

%problem 5
%tree1 = fitctree(TrainingSet(:,1:4), TrainingSet(:,5), 'MinLeafSize', 1);
%view(tree1,'Mode','graph');

%tree2 = fitctree(TrainingSet(:,1:4), TrainingSet(:,5), 'MinLeafSize', 5);
%view(tree2,'Mode','graph');



%testlabels = predict(tree1,TestingSet(:,1:4));

%test
leafs = [1 2 5 10 15 20 25 30 35 40 45 50];
rng('default')
N = numel(leafs);
err = zeros(N,1);
for n=1:N
    t = fitctree(TrainingSet(:,1:4), TrainingSet(:,5),'MinLeafSize',leafs(n));
    testlabels1 = predict(t,TestingSet(:,1:4));
    testlabels2 = predict(t,ValidationSet(:,1:4));
    %err(n) = kfoldLoss(t);
    accuracy1(n) = inputParameters(testlabels1,TestingSet(:,5));
    accuracy2(n) = inputParameters(testlabels2,ValidationSet(:,5));
end
plot(leafs,accuracy1);
xlabel('Min Leaf Size');
ylabel('Accuracy Testing');
plot(leafs,accuracy2);
xlabel('Min Leaf Size');
ylabel('Validation Testing');

%question 6

treeChoosen = fitctree(TrainingSet(:,1:4), TrainingSet(:,5), 'MinLeafSize', 15);
view(treeChoosen,'Mode','graph');
testlabelsChoosen = predict(treeChoosen,TestingSet(:,1:4));
C1 = confusionmat(TestingSet(:,5),testlabelsChoosen);


%question 7




function accuracy = inputParameters(a,b)
    differences = (a==b);
    totalOnes = 0;
    for i=1:length(differences)
       if(differences(i)==1)
           totalOnes = totalOnes+1;
       end
    end
    accuracy = (totalOnes/length(differences));
end
