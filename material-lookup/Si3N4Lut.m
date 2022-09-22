function [lambda,cp,roh] = Si3N4Lut(T)
% Lookuptable for temperature dependant material constants.

T = T + 273.15;

% Values from DCM1000X
% xDataLambda = [273  298  323  348  373  398  423  448  473  498  523];
% yDataLambda = [95.3 84.7 75.3 67.0 59.9 54.0 49.1 45.4 42.9 41.5 41.3];

% xDataCp = [323   373   423];
% yDataCp = [740.2 765.9 858.4];

% Values from STPak
xDataLambda = [24.9  50    75    100   125  150  175    200   225   250   275   300] + 273.15;
yDataLambda = [77.78 71.45 66.38 63.91 62.2 60.7 60.135 60.06 58.97 56.76 54.75 54.03];

xDataCp = [24.9  50    75    100   125  150  175    200   225   250   275   300] + 273.15;
yDataCp = [660   697   722   771   824  877  940    1030  1071  1099  1128  1177];

% Enable extrapolation due to limited data in y
lambda = interp1(xDataLambda,yDataLambda,T,'linear','extrap');   % in W/(m*K);
cp = interp1(xDataCp,yDataCp,T,'linear','extrap');               % in J/(kg*K) 
roh = 3890;  % in kg/m³

end

