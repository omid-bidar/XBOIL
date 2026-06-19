%Function to evaluate the contact diameter dw.
function [dw] = contactDiameter2019(f,data,r)

N = data(1,1);

if N == 1
        
    dw = contactDiameterSugrue(f,r);
    
else
    
    dw = contactDiameterYun(f,r);
    
end

end