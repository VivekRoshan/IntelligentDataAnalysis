
inputstring = input('Enter the input DNA code','s');
inputstring = upper(inputstring);

outputstring= '';

for ii=1:1:length(inputstring)
    if(inputstring(ii)=='T')
        outputstring(ii)='A';
    elseif(inputstring(ii)=='A')
        outputstring(ii)='T';
    elseif(inputstring(ii)=='C')
        outputstring(ii)='G';
    elseif(inputstring(ii)=='G')
        outputstring(ii)='C';
    else
        outputstring= 'Weird DNA code';
        break;
    end
end

outputstring
        