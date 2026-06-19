%Function to evaluate the contact angles alfa and beta.
function [alfa,beta] = contactAngles(data)

N = data(1,1);

if N == 1
    
    [alfa,beta] = contactAnglesSugrue(data);
    
else
    
    [alfa,beta] = contactAnglesKlausner(data);
    
end

end