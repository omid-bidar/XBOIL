%Function to evaluate the forces for the force balance equations
%Forces follow the IJHMT 2015 paper
function [forces] = forceCalculation(F,data,prop,r,r1,r2,f)

rhoL = prop(1,1);
rhoV = prop(1,2);
muL = prop(1,3);
sigma = prop(1,11); 
tetaHor = data(1,17);
teta=(pi/18); %inclination angle
    
dw = contactDiameter2019(F,data,r);
[alfa,beta] = contactAngles(data);

%FORCES CALCULATION

%Surface tension calculation
switch f(1,1)
    
    case 1
        forces(1,1)=-1.25*dw*sigma*pi*(alfa-beta)*(sin(alfa)+sin(beta))/(pi^2-(alfa-beta)^2);
        forces(1,2)=-dw*sigma*pi*(cos(beta)-cos(alfa))/(alfa-beta);
    
    case 0
        forces(1,1) = 0;
        forces(1,2) = 0;

end

%Calculation of growth forces
switch f(1,2)
    
    case 1
        Fdu = -rhoL*pi*r^2*(r*r2+3*r1^2/2);
        forces(1,3) = Fdu*sin(teta);
        forces(1,4) = Fdu*cos(teta);
    
    case 0
        forces(1,3) = 0;
        forces(1,4) = 0;
    
end

%Drag forces calculation
switch f(1,3)
    
    case 1
        [U,Gs] = velocityWallLaw(data,prop,r);
        Re = U*2*r/(muL/rhoL);
        forces(1,5) = (2/3+((12/Re)^0.65+0.796^0.65)^(-1/0.65))*6*pi*rhoL*(muL/rhoL)*U*r;
    
    case 0
        forces(1,5) = 0;
        
end     
            
%Shear lift force calculation
switch f(1,4)
    
    case 1
        forces(1,6) = 1/2*pi*rhoL*U^2*r^2*(3.877*Gs^0.5*(Re^(-2)+(0.344*Gs^0.5)^4)^0.25);
        
    case 0
        forces(1,6) = 0;
        
end

%Gravity force calculation
switch f(1,5)
    
    case 1
        Fb = 4/3*pi*r^3*(rhoL-rhoV)*9.81;
        forces(1,7)=Fb*sin(tetaHor*pi/180);
        forces(1,8)=Fb*cos(tetaHor*pi/180);
        
    case 0
        forces(1,7) = 0;
        forces(1,8) = 0;
        
end
        
%Contact pressure force calculation

switch f(1,6)
    
    case 1
        forces(1,9)=(pi*dw^2/4)*2*sigma/(5*r);
        
    case 0
        forces(1,9) = 0;
        
end


%Hydrodynamic pressure force calculation
switch f(1,7)
    
    case 1
        forces(1,10)=9/8*rhoL*U^2*pi*dw^2/4;
        
    case 0
        forces(1,10) = 0;
        
end

%Tangential and normal force balances calculated
forces(1,11) = forces(1,1)+forces(1,5)+forces(1,3)+forces(1,7);
forces(1,12) = forces(1,2)+forces(1,4)+forces(1,6)+forces(1,8)+forces(1,9)+forces(1,10);

end