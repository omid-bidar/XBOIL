%Function to evaluate the contact diameter dw.
function [dw] = contactDiameterYun(f,r)

if f > 0
    
    dw = 0;
    
else
    
    dw = 2*r/15;
        
end

end