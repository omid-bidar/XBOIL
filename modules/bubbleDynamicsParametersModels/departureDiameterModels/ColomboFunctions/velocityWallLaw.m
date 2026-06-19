%Function to evaluate the contact diameter dw.
function [U,Gs] = velocityWallLaw(data,prop,r)

Ub = data(1,7);
rhoL = prop(1,1);
muL = prop(1,3);


ustar = 0.04*Ub;
yplus = r*ustar/(muL/rhoL);

if yplus < 5
    
    uplus = yplus;
    dU = ustar^2/(muL/rhoL);

else if yplus > 30
        
        uplus = 2.5*log(yplus)+5.5;
        dU = 5/yplus*ustar^2/(muL/rhoL);
    
    else
        
        uplus = 5*log(yplus)-3.05;
        dU = 2.5/yplus*ustar^2/(muL/rhoL);
    
    end
end

U = uplus*ustar;
Gs = dU*r/U;

end