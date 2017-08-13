clear all
filename = 'C:\Users\suggalvn\Downloads\DataHW1 - Copy.xlsx';
Sid = xlsread(filename,'A:A');
Sum_of_subjects = xlsread(filename,strcat('B2:B',num2str(length(Sid)+1)))+xlsread(filename,strcat('C2:C',num2str(length(Sid)+1)))+xlsread(filename,strcat('D2:D',num2str(length(Sid)+1)));
xlswrite(filename,Sum_of_subjects,1,strcat('E2:E',num2str(length(Sid)+1)));
totals = xlsread(filename,'E:E');
minimumvalue= min(totals);
maximumvalue = max(totals);
interval = (maximumvalue-minimumvalue)/5;
edges = [minimumvalue minimumvalue+interval minimumvalue+(interval*2) minimumvalue+(interval*3) minimumvalue+(interval*4) maximumvalue];
Y = discretize(totals , edges);
Y = char(Y);
Y( Y==1 )= 'F';Y( Y==2 )= 'D';Y( Y==3 )= 'C';Y( Y==4 )= 'B';Y( Y==5 )= 'A';
xlswrite(filename,Y,1,strcat('F2:F',num2str(length(Sid)+1)));
uni = unique(Y);
for a=1:length(uni)
   freq(a)=length(find(Y == uni(a))); 
end


%problem 2
total_students = length(Sid);
no_of_bins = 5;
counter=1;
no_of_students_in_each_bin = total_students/no_of_bins;
dummy=totals;
for i=1:no_of_bins
    for j=1:no_of_students_in_each_bin
        [max_value,Index] =max(dummy);
        Z(Index)= counter; 
        dummy(Index) = 0;
    end
    counter = counter+1;
end
uni = unique(Z);
for a=1:length(uni)
   frequency(a)=length(find(Z == uni(a))); 
end
Z = char(Z);
Z( Z==1 )= 'A';Z( Z==2 )= 'B';Z( Z==3 )= 'C';Z( Z==4 )= 'D';Z( Z==5 )= 'F';
% for i=2:length(Sid)+1
%    xlswrite(filename,Z(i-1),1,strcat('G',num2str(i),':G',num2str(i)));
% end


%problem 2-- version2

P = ceil(5 * tiedrank(totals) / length(totals));
P=char(P);P(P==1)='F'; P(P==2)='D'; P(P==3)='C'; P(P==4)='B'; P(P==5)='A';
xlswrite(filename,P,1,strcat('G2:G',num2str(length(Sid)+1)));
uni = unique(P);
for a=1:length(uni)
   frequency2(a)=length(find(P == uni(a))); 
end

%problem 2-- continuation
differences = Y == P;
for i=1:length(differences)
   if(differences(i)==0)
       if(uint8(Y(i)<uint8(P(i))))
           Happier(i)= string('Happy with width');
       else
           Happier(i) = string('Happy with frequency');
       end
   else
       Happier(i) = string('No change');  
   end
end    
Happier = Happier';
List_happy_equal_width = find(Happier == 'Happy with width');
List_happy_equal_frequency = find(Happier == 'Happy with frequency');

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
           Happier_4_2(i)= string('Happy with Z-scores');
       else
           Happier_4_2(i) = string('Happy with frequency');
       end
   else
       Happier_4_2(i) = string('No change');  
   end
end    
Happier_4_2 = Happier_4_2';
List_happy_equal_frequency_4_2 = find(Happier_4_2 == 'Happy with frequency');
List_happy_equal_Z_score_4_2 = find(Happier_4_2 == 'Happy with Z-scores');
Matrix_Sid_grades = [string(Sid),Y];
j=1;
for g=1:5
    counter=1;
    for i=1:length(Sid)
        if(Matrix_Sid_grades(i,2)==uni(g) && counter<=2)
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
euclidean_distance(euclidean_distance == 0 ) = Inf;
mahalanobi_distance(euclidean_distance == 0 ) = Inf;
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
