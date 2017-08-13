%problem 1
filename = 'C:\Users\suggalvn\Downloads\DataHW1.xlsx'; %path of the file stored in 'filename'
Sid = xlsread(filename,'A:A'); %reading the student-ID's from the excel file to Sid
Sum_of_subjects = xlsread(filename,strcat('B2:B',num2str(length(Sid)+1)))+xlsread(filename,strcat('C2:C',num2str(length(Sid)+1)))+xlsread(filename,strcat('D2:D',num2str(length(Sid)+1)));
%Adding the three columns; Physics, Maths, English from the excel and
%storing it in Sum_of_subjects
xlswrite(filename,Sum_of_subjects,1,strcat('E2:E',num2str(length(Sid)+1)));
%writing the Sum_of_subjects into the excel file
minimumvalue= min(Sum_of_subjects); %finding out the minimum of Sum among all the students
maximumvalue = max(Sum_of_subjects); %finding out the maximum of Sum among all the students
interval = (maximumvalue-minimumvalue)/5; %calculating the interval with the mentioned formula
edges = [minimumvalue minimumvalue+interval minimumvalue+(interval*2) minimumvalue+(interval*3) minimumvalue+(interval*4) maximumvalue];
%edges contain the boundaries of the bins to be divided.
%creating the boundaries for the discretize function and storing it in 'edges'
Y = discretize(Sum_of_subjects , edges); %discretizing according to the boundaries(edges)
%the output of Y would be numbers ranging from 1 to 5, as wew gave 6
%boundaries in edges
Y = char(Y); %converting the number vector into character vector
Y( Y==1 )= 'F';Y( Y==2 )= 'D';Y( Y==3 )= 'C';Y( Y==4 )= 'B';Y( Y==5 )= 'A';
%replacing the values accordingly; 1 with F, 2 with D and so on till 5 with A 
xlswrite(filename,Y,1,strcat('F2:F',num2str(length(Sid)+1))); %writing the grades to file
Unique_grades = unique(Y); %unique function picks out the uique values of Y and place them in Unique_grades vector
for a=1:length(Unique_grades) %finding out the frquency of each grade
   Frquency_of_grades(a)=length(find(Y == Unique_grades(a))); 
end
%output:
fprintf('Problem 1 output \n')
output = [string(Sid),Y];
fprintf('Grades according to equal width partitioning are:\n');
disp(output');
fprintf('Counts of each grades, A B C D F respectively are:\n');
disp(Frquency_of_grades)

%problem 2
P = ceil(5 * tiedrank(Sum_of_subjects) / length(Sum_of_subjects)); %equal frequency binning using tiedrank
P=char(P);P(P==1)='F'; P(P==2)='D'; P(P==3)='C'; P(P==4)='B'; P(P==5)='A'; %replacing the values accordingly; 1 with F, 2 with D and so on till 5 with A 
xlswrite(filename,P,1,strcat('G2:G',num2str(length(Sid)+1))); %writing the grades to the file
Unique_grades = unique(P);
for i=1:length(Unique_grades)
   frequency2(i)=length(find(P == Unique_grades(i))); %frequency of each grade
end
differences = Y == P; %students whose grades got changed from equal width to equal frequency
for i=1:length(differences) %finding out who are happy for width and who are happy for frequency
   if(differences(i)==0)
       if(uint8(Y(i)<uint8(P(i))))
           Happier_width_frequency(i)= string('Happy with width');
       else
           Happier_width_frequency(i) = string('Happy with frequency');
       end
   else
       Happier_width_frequency(i) = string('No change');  
   end
end    
Happier_width_frequency = Happier_width_frequency';
List_happy_equal_width_than_frequency = find(Happier_width_frequency == 'Happy with width');
%listing out the student-ID's who are happy with equal width partitioning
List_happy_equal_frequency_than_width = find(Happier_width_frequency == 'Happy with frequency');
%listing out the student-ID's who are happy with equal frequency partitioning
%output:
fprintf('Problem 2 output \n')
output = [string(Sid),P];
fprintf('Grades according to equal frequency partitioning are:\n');
disp(output');
fprintf('Counts of each grades, A B C D F respectively are:\n');
disp(frequency2);
fprintf('List of people who are happy with equal width partitioning than equal frequency are:\n');
disp(List_happy_equal_width_than_frequency);
fprintf('List of people who are happy with equal frequency partitioning than equal width are:\n');
disp(List_happy_equal_frequency_than_width);

%problem 3
output = find(differences == 0); %Students whose grades had been changed, thier value would be 0
%output
fprintf('Problem 3 output \n')
fprintf('Students whose grades had been changed are:\n');
disp(output');

%problem 4
%Adding the zscores for three columns; Physics, Maths, English from the excel and storing it in Z_Score_totals
Z_Score_totals = zscore(xlsread(filename,strcat('B2:B',num2str(length(Sid)+1))))+zscore(xlsread(filename,strcat('C2:C',num2str(length(Sid)+1))))+zscore(xlsread(filename,strcat('D2:D',num2str(length(Sid)+1))));
Z_grades = ceil(5 * tiedrank(Z_Score_totals) / length(Z_Score_totals)); %giving grades to the zscore totals
%replacing the values accordingly; 1 with F, 2 with D and so on till 5 with A 
Z_grades=char(Z_grades);Z_grades(Z_grades==1)='F'; Z_grades(Z_grades==2)='D'; Z_grades(Z_grades==3)='C'; Z_grades(Z_grades==4)='B'; Z_grades(Z_grades==5)='A';
xlswrite(filename,Z_grades,1,strcat('H2:H',num2str(length(Sid)+1))); %writing it to excel file
%output
fprintf('Problem 4 output \n')
fprintf('Z-scores for the students are:\n');
output = [string(Sid),string(Z_Score_totals)];
disp(output');
output = [string(Sid),Z_grades];
fprintf('Grades according to z-score partitioning are:\n');
disp(output');

%problem 5
differences_4_2 = Z_grades == P; %students whose grades got changed from equal frequency and z-score grades
for i=1:length(differences_4_2) %finding out who are happy for zscore and who are happy for frequency
   if(differences_4_2(i)==0)
       if(uint8(Z_grades(i))<uint8(P(i)))
           Happier_frequency_zscore(i)= string('Happy with Z-scores');
       else
           Happier_frequency_zscore(i) = string('Happy with frequency');
       end
   else
       Happier_frequency_zscore(i) = string('No change');  
   end
end    
Happier_frequency_zscore = Happier_frequency_zscore';
%listing out the student-ID's who are happy with equal frequency partitioning
List_happy_equal_frequency_than_zscore = find(Happier_frequency_zscore == 'Happy with frequency');
%listing out the student-ID's who are happy with zscore partitioning
List_happy_equal_Z_score_than_frequency = find(Happier_frequency_zscore == 'Happy with Z-scores');
%output:
fprintf('Problem 5 output \n');
fprintf('List of people who are happy with equal frequency partitioning than Z-score are:\n');
disp(List_happy_equal_frequency_than_zscore);
fprintf('List of people who are happy with z-score partitioning rather than equal frequency partitioning are:\n');
disp(List_happy_equal_Z_score_than_frequency);

%problem 7
Matrix_Sid_grades = [string(Sid),Y]; %Matrix_Sid_grades contains Sid and grades(according to equal width partitioning)
j=1;
for g=1:5 %retrieving two students of each grade and storing in Desired_Matrix
    counter=1;
    for i=1:length(Sid)
        if(Matrix_Sid_grades(i,2)==Unique_grades(g) && counter<=2)
            Desired_Matrix(j) = str2double(Matrix_Sid_grades(i,1));
            j=j+1;
            Matrix_Sid_grades(i,2)=' ';
            counter= counter+1;
        end
    end
end
Desired_Matrix = Desired_Matrix'; %making the transpose of Desired_Matrix, from 1*40 to 40*1
X = xlsread(filename,'A2:D41'); %reading the first four columns from excel to 'X'
for j=1:10 %creating a matrix Q, such that it contains only 3 columns of marks(Physics,Maths,English) for the 
    %students who got selected in the Desired_Matrix
    for i=1:length(Sid)
        if (X(i,1)== Desired_Matrix(j))
            Q(j,:) =  X(i,:);
        end
    end
end
euclidean = squareform(pdist(Q(:,2:4))); %calculating euclidean distance and forimg a 10*10 matrix
mahalanobi = squareform(pdist(Q(:,2:4),'mahalanobis')); %calculating mahalanobi distance forimg a 10*10 matrix
euclidean_distance = euclidean;
mahalanobi_distance = mahalanobi;
%output:
fprintf('Problem 7 output \n');
fprintf('Euclidean distance 10*10 matrix: \n');
disp(euclidean);
% fprintf('Mahalanobi distance 10*10 matrix: \n');
% disp(mahalanobi);

%problem 8
euclidean_distance(euclidean_distance == 0 ) = Inf; %making the 0's to infinity
mahalanobi_distance(mahalanobi_distance == 0 ) = Inf; %making the 0's to infinity
for i=1:4
    %making certain manipulations such as retrieving top 4 minimum values
    %and finding out the student pair from euclidean_distance and mahalanobi_distance
    [M,I]= min(euclidean_distance);
    [M,J]= min(min(euclidean_distance));
    euclidean_distance(I,J)= Inf;
    euclidean_distance(J,I)= Inf;
    I = I(J);
    euclidean_pairs(i,1) = M;
    euclidean_pairs(i,2) = Desired_Matrix(I);
    euclidean_pairs(i,3) = Desired_Matrix(J);
    %euclidean_pair consists of student pairs for top 4 minimum euclidean distances
    [M,I]= min(mahalanobi_distance);
    [M,J]= min(min(mahalanobi_distance));
    mahalanobi_distance(I,J)= Inf;
    mahalanobi_distance(J,I)= Inf;
    I = I(J);
    mahalanobi_pair(i,1) = M;
    mahalanobi_pair(i,2) = Desired_Matrix(I);
    mahalanobi_pair(i,3) = Desired_Matrix(J);
    %mahalanobi_pair consists of student pairs for top 4 minimum mahalanobi distances
end
%output:
fprintf('Problem 8 output \n');
fprintf('four student pairs with minimum Euclidean distance matrix: \n');
output = [string(double(euclidean_pairs(:,1))) ,string(int16(euclidean_pairs(:,2))), string(int16(euclidean_pairs(:,3))) ]; 
disp(output);
% fprintf('four student pairs with minimum mahalanobi distance matrix: \n');
% output = [string(double(mahalanobi_pair(:,1))) ,string(int16(mahalanobi_pair(:,2))), string(int16(mahalanobi_pair(:,3))) ]; 
% disp(output);
