clear all
filename = 'C:\Users\suggalvn\Downloads\DataHW1 - Copy.xlsx';
Sid = xlsread(filename,'A:A');
Sum_of_subjects = xlsread(filename,strcat('B2:B',num2str(length(Sid)+1)))+xlsread(filename,strcat('C2:C',num2str(length(Sid)+1)))+xlsread(filename,strcat('D2:D',num2str(length(Sid)+1)));
xlswrite(filename,Sum_of_subjects,1,strcat('E2:E',num2str(length(Sid)+1)));
minimumvalue= min(Sum_of_subjects);
maximumvalue = max(Sum_of_subjects);
interval = (maximumvalue-minimumvalue)/5;
edges = [minimumvalue minimumvalue+interval minimumvalue+(interval*2) minimumvalue+(interval*3) minimumvalue+(interval*4) maximumvalue];
Y = discretize(Sum_of_subjects , edges);
Y = char(Y);
Y( Y==1 )= 'F';Y( Y==2 )= 'D';Y( Y==3 )= 'C';Y( Y==4 )= 'B';Y( Y==5 )= 'A';
xlswrite(filename,Y,1,strcat('F2:F',num2str(length(Sid)+1)));
Unique_grades = unique(Y);
for i=1:length(Unique_grades)
   Frquency_of_grades(i)=length(find(Y == Unique_grades(i))); 
end


%problem 2
total_students = length(Sid);
no_of_bins = 5;
counter=1;
no_of_students_in_each_bin = total_students/no_of_bins;
totals=Sum_of_subjects;
for i=1:no_of_bins
    for j=1:no_of_students_in_each_bin
        [max_value,Index] =max(totals);
        Z(Index)= counter; 
        totals(Index) = 0;
    end
    counter = counter+1;
end
Unique_grades = unique(Z);
for i=1:length(Unique_grades)
   frequency(i)=length(find(Z == Unique_grades(i))); 
end
Z = char(Z);
Z( Z==1 )= 'A';Z( Z==2 )= 'B';Z( Z==3 )= 'C';Z( Z==4 )= 'D';Z( Z==5 )= 'F';
% for i=2:length(Sid)+1
%    xlswrite(filename,Z(i-1),1,strcat('G',num2str(i),':G',num2str(i)));
% end


%problem 2-- version2

P = ceil(5 * tiedrank(Sum_of_subjects) / length(Sum_of_subjects));
P=char(P);P(P==1)='F'; P(P==2)='D'; P(P==3)='C'; P(P==4)='B'; P(P==5)='A';
xlswrite(filename,P,1,strcat('G2:G',num2str(length(Sid)+1)));
Unique_grades = unique(P);
for i=1:length(Unique_grades)
   frequency2(i)=length(find(P == Unique_grades(i))); 
end

%problem 2-- continuation
differences = Y == P;
for i=1:length(differences)
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
List_happy_equal_frequency_than_width = find(Happier_width_frequency == 'Happy with frequency');

%problem 4
Z_Score_totals = zscore(xlsread(filename,strcat('B2:B',num2str(length(Sid)+1))))+zscore(xlsread(filename,strcat('C2:C',num2str(length(Sid)+1))))+zscore(xlsread(filename,strcat('D2:D',num2str(length(Sid)+1))));
Z_grades = ceil(5 * tiedrank(Z_Score_totals) / length(Z_Score_totals));
Z_grades=char(Z_grades);Z_grades(Z_grades==1)='F'; Z_grades(Z_grades==2)='D'; Z_grades(Z_grades==3)='C'; Z_grades(Z_grades==4)='B'; Z_grades(Z_grades==5)='A';
xlswrite(filename,Z_grades,1,strcat('H2:H',num2str(length(Sid)+1)));

%problem 5
differences_4_2 = Z_grades == P;
for i=1:length(differences_4_2)
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
List_happy_equal_frequency_than_zscore = find(Happier_frequency_zscore == 'Happy with frequency');
List_happy_equal_Z_score_than_frequency = find(Happier_frequency_zscore == 'Happy with Z-scores');




%problem 7
Matrix_Sid_grades = [string(Sid),Y];
j=1;
for g=1:5
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
Desired_Matrix = Desired_Matrix';
X = xlsread(filename,'A2:D41');
for j=1:10
    for i=1:length(Sid)
        if (X(i,1)== Desired_Matrix(j))
            Q(j,:) =  X(i,:);
        end
    end
end
euclidean = squareform(pdist(Q(:,2:4)));
mahalanobi = squareform(pdist(Q(:,2:4),'mahalanobis'));
euclidean_distance = euclidean;
mahalanobi_distance = mahalanobi;

%problem 8
euclidean_distance(euclidean_distance == 0 ) = Inf;
mahalanobi_distance(mahalanobi_distance == 0 ) = Inf;
for i=1:4
    [M,I]= min(euclidean_distance);
    [M,J]= min(min(euclidean_distance));
    euclidean_distance(I,J)= Inf;
    euclidean_distance(J,I)= Inf;
    I = I(J);
    euclidean_pairs(i,1) = M;
    euclidean_pairs(i,2) = Desired_Matrix(I);
    euclidean_pairs(i,3) = Desired_Matrix(J);
    
    
    [M,I]= min(mahalanobi_distance);
    [M,J]= min(min(mahalanobi_distance));
    mahalanobi_distance(I,J)= Inf;
    mahalanobi_distance(J,I)= Inf;
    I = I(J);
    mahalanobi_pair(i,1) = M;
    mahalanobi_pair(i,2) = Desired_Matrix(I);
    mahalanobi_pair(i,3) = Desired_Matrix(J);
end
