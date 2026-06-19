%Function to evaluate the contact diameter dw.
function [dw] = contactDiameterSugrue(f,r)

if f > 0
    
    dw = 0;
    
else
    
    dw = 2*r/40;
        
end

end