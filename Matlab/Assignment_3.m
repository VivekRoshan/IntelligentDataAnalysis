data = xlsread('C:\Users\suggalvn\Downloads\StudentData2.xlsx');
d = data(1:57,2:5);
minimumSSE = 0;
for k = 1:6
    fprintf('\nK value: %d\n',(k + 4));
    [idx,C,sumd] = kmeans(d,(k+4),'Replicates',3,'Display','final');
    fprintf('Cluster Centers are:\n');
    disp(C);
    fprintf('SSE values for each clusters are\n');
    disp(sumd)
    sse(1,k) = sum(sumd);
    fprintf('Sum of SSE values are:\n');
    disp(sse(1,k));
    
    
    %1.b
    [s,n] = silhouette(d,idx);
    figure;
    fprintf('mean of the silhoutte for the %d is %d\n',k+4,sum(s)/57)
    smean(k) = sum(s)/57;
    sarray(k,1) = sse(1,k);
    sarray(k,2) = k+4;
    if (sse(1,k) <= minimumSSE) ||(minimumSSE == 0)
        minimumSSE = sse(1,k);
        minimumCentroid = C;
        minimumCluster = idx;
        minimumk = k+4;
    end
    
end



kx = 5:10;
plot(kx,smean); figure;
plot(kx,sse);
xlabel('K-Values')
ylabel('Total SSE values')
sarr = sortrows(sarray,[1 2]);

%1.e
fprintf('Random Data\n')
d1 = randi([0 100],100,4);
disp(d1);
[idx1,C1,sumd1] = kmeans(d1,minimumk,'Replicates',3,'Display','final');
sse1 = sum(sumd1);
fprintf('Centroids for the random data generated');
disp(C1);

[a,b]=hist(idx1,unique(idx1));
fprintf('Population of clusters formed in this random data from clusters 1-%d clusters\n',minimumk);
disp(a);
%comparison
fprintf('SSE of random data for %d clusters: %d\n',minimumk,sse1);
fprintf('SSE of given data for %d clusters: %d\n',minimumk,sse(1,(minimumk - 4)));
if(sse1 <= sse(1,(minimumk - 4)))
    disp('Clustering on random data is better compared to given data as SSE is low');
else
    disp('Clustering on given data is better compared to random data as SSE is low');
end

%2nd solution
%2.1
[rows,cols] = size(d);
clustersRequired = 4;%given in the question
y=pdist(d);
Clustering2 = linkage(y,'single');
figure()
dendrogram(Clustering2,0); %P = 0 

Clustering3 = linkage(y,'complete');
figure()
dendrogram(Clustering3,0); %P=0

%2.2
fprintf('\nSingle linkage Points\n');
clustersDividedSingle = cluster(Clustering2,'maxclust',clustersRequired);
%ClustersPopulation(clustersRequired,rows, clustersDivided);

%population and centroids for single link
for i = 1:clustersRequired
    x = find(clustersDividedSingle == i);
    g=sprintf('%d ', x);
    fprintf('Points belonging to cluster %d: %s\n',i,g)
    %for centroids
    counter = 0;
    sum = [0 0 0 0];
    for j = 1:size(x)
        sum = sum + d(x(j),:);
        counter = counter + 1;
    end    
    sum = sum / counter;
    centroidSingle(i,:) = sum;
    %disp(sum);    
end

fprintf('Centroid for the Single link is \n');
disp(centroidSingle);

fprintf('\nComplete linkage Points\n');
clustersDividedComplete = cluster(Clustering3,'maxclust',clustersRequired);
%ClustersPopulation(clustersRequired,rows, clustersDivided);

%population and centroids for complete link
for i = 1:clustersRequired
    x = find(clustersDividedComplete == i);
    g=sprintf('%d ', x);
    fprintf('Points belonging to cluster %d: %s\n',i,g)
    %for centroids
    counter = 0;
    sum = [0 0 0 0];
    for j = 1:size(x)
        sum = sum + d(x(j),:);
        counter = counter + 1;
    end    
    sum = sum / counter;
    centroidComplete(i,:) = sum;
    %disp(sum);
end
fprintf('Centroid for the Complete link is \n');
disp(centroidComplete);


%for rand index 2.d
a3 = 0;
b3 = 0;
c3 = 0;
d3 = 0;
for i=1:size(d)
    for j=(i+1):size(d)
        if((clustersDividedSingle(i,1) == clustersDividedSingle(j,1)) &&  (clustersDividedComplete(i,1) == clustersDividedComplete(j,1)))
            a3 = a3+1;
        elseif((clustersDividedSingle(i,1) ~= clustersDividedSingle(j,1)) &&  (clustersDividedComplete(i,1) ~= clustersDividedComplete(j,1)))
            b3=b3+1;
        elseif((clustersDividedSingle(i,1) == clustersDividedSingle(j,1)) &&  (clustersDividedComplete(i,1) ~= clustersDividedComplete(j,1)))
            c3=c3+1;
        else
            d3=d3+1;
        end
    end
end

randindex = (a3+b3)/(a3+b3+c3+d3);
fprintf('RandIndex of Single linkage and Complete linkage\n');
fprintf('a(number of pairs that are in the same set in Clustering2 and in the same set in Clustering 3) : %d\n',a3);
fprintf('b(number of pairs that are in the different set in Clustering2 and in the different set in Clustering 3): %d\n',b3);
fprintf('c(number of pairs that are in the same set in Clustering2 and in the different set in Clustering 3): %d\n',c3);
fprintf('d(number of pairs that are in the different set in Clustering2 and in the same set in Clustering 3): %d\n',d3);
fprintf('Rand index is %d \n', randindex);

%3rd Solution
%for rand index 2.d
a2 = 0;
b2 = 0;
c2 = 0;
d2 = 0;
for i=1:size(d)
    for j=(i+1):size(d)
        if((clustersDividedSingle(i,1) == clustersDividedSingle(j,1)) &&  (idx(i,1) == idx(j,1)))
            a2 = a2+1;
        elseif((clustersDividedSingle(i,1) ~= clustersDividedSingle(j,1)) &&  (idx(i,1) ~= idx(j,1)))
            b2=b2+1;
        elseif((clustersDividedSingle(i,1) == clustersDividedSingle(j,1)) &&  (idx(i,1) ~= idx(j,1)))
            c2=c2+1;
        else
            d2=d2+1;
        end
    end
end

randindex2 = (a2+b2)/(a2+b2+c2+d2);

fprintf('\nRandIndex of Single linkage and Clustering-1(with 10 clusters on dataset):\n');
fprintf('a(number of pairs that are in the same set in Clustering2 and in the same set in Clustering1) : %d\n',a2);
fprintf('b(number of pairs that are in the different set in Clustering2 and in the different set in Clustering1): %d\n',b2);
fprintf('c(number of pairs that are in the same set in Clustering2 and in the different set in Clustering1): %d\n',c2);
fprintf('d(number of pairs that are in the different set in Clustering2 and in the same set in Clustering1): %d\n',d2);
fprintf('Rand index is %d \n', randindex2);



