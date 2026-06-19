%Function to evaluate the contact diameter dw.
function [dry] = dryFraction(f,data,r)

dw = contactDiameter2019(f,data,r);
dry = (1-dw^2/(2*(r+1e-15)^2));

end