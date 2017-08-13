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
%tree1 = fitctree(TrainingSet(:,1:4), TrainingSet(:,5),  , 1);
%view(tree1,'Mode','graph');

%tree2 = fitctree(TrainingSet(:,1:4), TrainingSet(:,5), 'MinLeafSize', 5);
%view(tree2,'Mode','graph');



%testlabels = predict(tree1,TestingSet(:,1:4));

%test
leafs = [1 2 5 10 15 20 25 30 35 40 45 50];
rng('default')
N = numel(leafs);
for n=1:N
    t = fitctree(TrainingSet(:,1:4), TrainingSet(:,5),'MinLeafSize',leafs(n));
    testlabels1 = predict(t,TrainingSet(:,1:4));
    testlabels2 = predict(t,ValidationSet(:,1:4));
    %err(n) = kfoldLoss(t);
    accuracy1(n) = inputParameters(testlabels1,TrainingSet(:,5));
    accuracy2(n) = inputParameters(testlabels2,ValidationSet(:,5));
end
plot(leafs,accuracy1,'color','r');
hold on;
plot(leafs,accuracy2,'color','b');
xlabel('Min Leaf Size');
ylabel('Accuracy');
treeChoosen = fitctree(TrainingSet(:,1:4), TrainingSet(:,5), 'MinLeafSize', 20);
view(treeChoosen,'Mode','graph');

%question 6

treeChoosen1 = fitctree(TestingSet(:,1:4), TestingSet(:,5), 'MinLeafSize', 20);
testlabelsChoosen = predict(treeChoosen1,TestingSet(:,1:4));
C1 = confusionmat(TestingSet(:,5),testlabelsChoosen);

aTP = C1(1,1); bFN = C1(1,2); cFP = C1(2,1); dTN = C1(2,2);
AccuracyDataSet = (aTP+dTN)/(aTP+bFN+cFP+dTN);
Precision0 = aTP/(aTP+cFP);
Recall0 = aTP/(aTP+bFN);
Precision1 = dTN/(dTN+bFN);
Recall1 = dTN/(dTN+cFP);

%question 7



% x = [d1(:,1) d1(:,2) (ones(length(d1),1))];
% t = d1(:,5);
% w=[rand(1,3)]';
% x = x';
% t = t';
% net = perceptron;
% net.trainParam.epochs=1000;
% net = train(net,x,t);
% w = net.iw{100,100,100};
% b = net.b{1};
% plotpv(z,t)
% plotpc(net.iw{1,1},net.b{1})
% 

x = [d1(:,1) d1(:,2)];
t = d1(:,5);
x = x';
t = t';
net = perceptron;
net.trainParam.epochs=1000;
net = configure(net,x,t);
net = train(net,x,t);
figure;
D10 = d1(d1(:,5)==0,:);
D11 = d1(d1(:,5)==1,:);
scatter(D10(:,1),D10(:,2),'k');
hold
scatter(D11(:,1),D11(:,2),'r');
w = net.iw{1,1};
b = net.b{1};
%plotpv(z,t)
plotpc(w,b)

y=w(1).*d1(:,1)+w(2).*d1(:,2)+b;
y(find(y<0))=0;
y(find(y>0))=1;
improper=find(y~=d1(:,5));
fprintf('NUMBER OF misclassified datasets are: %d',length(improper));


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
