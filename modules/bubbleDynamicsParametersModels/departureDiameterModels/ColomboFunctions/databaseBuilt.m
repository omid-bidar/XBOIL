%Routine that builds the database to be used in the calculation

function [dataOut,propOut,labelOut] = databaseBuilt(dataIn,propIn,labelIn,IDList)

databaseN = length(IDList);

for i = 1:1:databaseN
    ID = IDList(i);
    dataN = labelIn{ID,3};
    
    j = 1;
    dataStart = 0;
    
    while j < ID
        dataStart = dataStart + labelIn{j,3};
        j = j + 1;
    end
    
    if i == 1
        dataOut(1:dataN,:) = dataIn(dataStart+1:dataStart+dataN,:);
        propOut(1:dataN,:) = propIn(dataStart+1:dataStart+dataN,:);
        dataTot = length(dataOut(:,1));
        
    else
        dataOut((dataTot+1):(dataTot+dataN),:) = dataIn((dataStart+1):(dataStart+dataN),:);
        propOut((dataTot+1):(dataTot+dataN),:) = propIn((dataStart+1):(dataStart+dataN),:);
        dataTot = length(dataOut(:,1));
    end
    
    labelOut{i,1} = labelIn{ID,1};
    labelOut{i,2} = labelIn{ID,2};
    labelOut{i,3} = labelIn{ID,3};
    
end

%additional routine to eliminate data from Sugrue where wall temperature
%lower than saturation

dataN = length(dataOut);
i = 1;

while i <= dataN
    if dataOut(i,1) > 1
        
        break
        
    else
        
        if (dataOut(i,11)-dataOut(i,6)) > 0
            i = i + 1;
        else
            dataOut(i,:) = [];
            propOut(i,:) = [];
            labelOut{1,3} = labelOut{1,3}-1;
            dataN = length(dataOut);
        end
        
    end
end

end