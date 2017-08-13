clear all
filename = 'C:\Users\suggalvn\Downloads\DataHW1 - Copy.xlsx';
Sid = xlsread(filename,'A:A');
Sum_of_subjects = xlsread(filename,strcat('B2:B',num2str(length(Sid)+1)))+xlsread(filename,strcat('C2:C',num2str(length(Sid)+1)))+xlsread(filename,strcat('D2:D',num2str(length(Sid)+1)));
xlswrite(filename,Sum_of_subjects,1,strcat('E2:E',num2str(length(Sid)+1)));
totals = xlsread(filename,'E:E');
minimumvalue= min(totals);
maximumvalue = max(totals);
interval = (maximumvalue-minimumvalue)/5;

edges = [minimumvalue minimumvalue+interval minimumvalue+(interval*2) (minimumvalue+interval*3) (minimumvalue+interval*4) maximumvalue];
Y = discretize(totals , edges);
Y = char(Y);
Y( Y==1 )= 'F';
Y( Y==2 )= 'D';
Y( Y==3 )= 'C';
Y( Y==4 )= 'B';
Y( Y==5 )= 'A';
xlswrite(filename,Y,1,strcat('F2:F',num2str(length(Sid)+1)));


uni = unique(Y);
for a=1:length(uni)
   freq(a)=length(find(Y == uni(a))); 
end
disp(a)
