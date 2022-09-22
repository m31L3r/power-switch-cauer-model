function [lambda,cp,roh] = copperLut(T)
% Lookuptable for temperature dependant material constants.

T = T + 273.15;

xDataLambda = [200 300 400 600 800 1000 1356.2];
yDataLambda = [413 401 393 379 366 352  327];

xDataCp = [150   250   298.1 400    600   1000  1356.2];
yDataCp = [322.6 373.3 384   397.5  416.7 451.1 475];

lambda = interp1(xDataLambda,yDataLambda,T,'linear');   % in W/(m*K);
cp = interp1(xDataCp,yDataCp,T,'linear');               % in J/(kg*K) 
roh = 8960;  % in kg/m³

end

