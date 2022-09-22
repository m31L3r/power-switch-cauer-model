function [lambda,cp,roh] = solderSnSb5Lut(T)
% Lookuptable for temperature dependant material constants.

T = T + 273.15;

lambda = 43;    % in W/(m*K);
cp = 228;       % in J/(kg*K) 
roh = 7390;     % in kg/m³

end

