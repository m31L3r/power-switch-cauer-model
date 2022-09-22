function [lambda,cp,roh] = sinterSilverLut(T)
% Lookuptable for temperature dependant material constants.

T = T + 273.15;

xDataLambda = [225.3 250.3 274.8 299.7 323.8 374.6 425.5 472.1 523 573];
yDataLambda = [371.8 345.9 344.7 334.1 327.1 324.7 318.8 315.3 310 305];

xDataCp = [150 200 300 400 600 800 1000];
yDataCp = [432 430 429 425 412 396 379];

lambda = interp1(xDataLambda,yDataLambda,T,'linear');   % in W/(m*K);
cp = interp1(xDataCp,yDataCp,T,'linear');               % in J/(kg*K) 
roh = 10500;  % in kg/m³

end

