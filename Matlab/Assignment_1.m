clear all
filename = 'C:\Users\suggalvn\Downloads\DataHW1 - Copy.xlsx';
Sid = xlsread(filename,'A:A');

for n = 2:length(Sid)+1
    Sample_B = strcat('B',num2str(n),':','B',num2str(n));
    Sample_C = strcat('C',num2str(n),':','C',num2str(n));
    Sample_D = strcat('D',num2str(n),':','D',num2str(n));
    
    Marks_Physics = xlsread(filename,Sample_B);
    Marks_Maths = xlsread(filename,Sample_C);
    Marks_English = xlsread(filename,Sample_D);

    Marks_final = Marks_Physics + Marks_Maths + Marks_English;
   
    Sample_E = strcat('E',num2str(n),':','E',num2str(n));
    
    
    xlswrite(filename,Marks_final,1,Sample_E);
    
    
end

totals = xlsread(filename,'E:E');
minimumvalue= min(totals);
maximumvalue = max(totals);
interval = (maximumvalue-minimumvalue)/5;

edges = [minimumvalue minimumvalue+interval minimumvalue+(interval*2) (minimumvalue+interval*3) (minimumvalue+interval*4) maximumvalue];
Y = discretize(totals , edges);

for n= 1:length(Y)
    if(Y(n)==1)
       xlswrite(filename,'F',1,strcat('F',num2str(n+1),':','F',num2str(n+1))); 
    elseif(Y(n)==2)
       xlswrite(filename,'D',1,strcat('F',num2str(n+1),':','F',num2str(n+1))); 
    elseif(Y(n)==3)
       xlswrite(filename,'C',1,strcat('F',num2str(n+1),':','F',num2str(n+1))); 
    elseif(Y(n)==4)
       xlswrite(filename,'B',1,strcat('F',num2str(n+1),':','F',num2str(n+1))); 
    elseif(Y(n)==5)
       xlswrite(filename,'A',1,strcat('F',num2str(n+1),':','F',num2str(n+1)));    
    end
end    

Grades = xlsread(filename,'F:F');
disp(Grades);
