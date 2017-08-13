
%Problem 1

d= xlsread('C:\Users\suggalvn\Downloads\StudentData2.xlsx');
disp(d);
%For k=5, the code for performing k means with random cluster centers selected 5 times:
data1=d(1:57,:);
values=data1(1:57,2:5);
fprintf('Physics  Maths  Eng Music\n');
disp(values);
minimium=0;

for k = 1:6
fprintf('\nK value: %d\n',(k + 4));
[idx,C,sumd] = kmeans(values,(k+4),'Replicates',3,'Display','final');
fprintf('Cluster Centres are:\n');
disp(C);
fprintf('SSE :\n');
disp(sumd);
sse(1,k) = sum(sumd); 
fprintf('Total SSE value is:\n');
disp(sse(1,k));



%1.c
fprintf('Plot of silhouette against k values\n');
[s,n]=silhouette(values,idx);
figure;

sarr(k,1) = sse(1,k);
sarr(k,2) = k+4;
if (sse(1,k) <= minimium) ||(minimium == 0)
minimium = sse(1,k);
centroid = C;
cluster = idx;
bestk=k+4;
end
end

%1.b
kx=5:10;
title('SSE against K');
plot(kx,sse);
xlabel('K values');
ylabel('Total SSE');
sortedarr = sortrows(sarr,[1 2]);

%1.d
disp('Centroids for best K value \n');
disp(centroid);

%1.e
randompoints=randi([0,100],100,4);
fprintf('Random data points');
disp(randompoints);
[idx1,C1,sumd1]=kmeans(randompoints,bestk,'Replicates',3,'Display','final');
sse1=sum(sumd1);
fprintf('Centroids for random data points\n');
disp(C1);


[a,b]=hist(idx1,unique(idx1));
fprintf('Population of clusters formed by random data in sequence 1-%d clusters\n',bestk);
disp(a);


sed1= sum(sumd1);
fprintf('SSE of random data for %d clusters: %d\n',bestk,sed1);
fprintf('SSE of given data for %d clusters: %d\n',bestk,sse(1,(bestk - 4)));
if(sed1 <= sse(1,(bestk - 4)))
disp('Clustering on random data is better compared to given data as SSE is low');
else
disp('Clustering on given data is better compared to random data as SSE is low');
end






