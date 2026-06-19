%Function to evaluate the growth of the bubble from the growth equation.
%Includes calculation of subccoling and superheating contributions.
%Specific method is selected from the subcooling keyword

function [r,r1,r2,Tsh,SH,B,SUB] = bubbleGrowth2025(data,prop,rOld,t,dt,Tw,ratio,micro,subcooling)

switch subcooling
    case 'RanzMarshall'

    
        [SUB,B,Tsh] = subcoolingRM2019(data,prop,rOld,Tw,ratio);
        [SH] = superheatingPZ(data,prop,Tsh);

        %new radius and derivatives calculation
        r = rOld + 2*micro*(t^0.5-(t-dt)^0.5) + 2*(1-B)*SH*(t^0.5-(t-dt)^0.5) - B*SUB*dt;
        r1 = micro*t^(-0.5) + (1-B)*SH*t^(-0.5) - B*SUB;
        r2 = -micro/2*t^(-1.5) - (1-B)*SH/2*t^(-1.5);
    
    case 'Integral'
           
        Tsh = subcoolingICL(data,prop,rOld,Tw,ratio);
        SUB = 0;
        B = 0;
        SH = superheatingPZ(data,prop,Tsh);
        
        %new radius and derivatives calculation
        r = rOld + 2*micro*(t^0.5-(t-dt)^0.5) + 2*SH*(t^0.5-(t-dt)^0.5);
        r1 = micro*t^(-0.5) + SH*t^(-0.5);
        r2 = -micro/2*t^(-1.5) - SH/2*t^(-1.5);
    
    case 'Mazzocco'
           
        Tsh = data(1,11);
        SUB = 0;
        B = 0;
        KSub = data(1,9)/(data(1,11)-data(1,6));
        a = 0.0;
        b = 0.05;
        SH = max(0,(a - b*KSub))*superheatingPZ(data,prop,data(1,11));
        %new radius and derivatives calculation
        r = rOld + 2*micro*(t^0.5-(t-dt)^0.5) + 2*SH*(t^0.5-(t-dt)^0.5);
        r1 = micro*t^(-0.5) + SH*t^(-0.5);
        r2 = -micro/2*t^(-1.5) - SH/2*t^(-1.5);
        
    otherwise
        
        error('Unknown subcooling model')
        
end
           
end