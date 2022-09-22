function [lambda,cp,roh] = baseOfCuLut(T)
% Lookuptable for temperature dependant material constants.

T = T + 273.15;

xDataLambda = [100.0 150.0 200.0 250.0 298.0 350.0 400.0 450.0 500.0 550.0 600.0 650.0 700.0 750.0 800.0 850.0 900.0 950.0 1000  1050];
yDataLambda = [408.3 404.7 401.1 397.5 394.0 390.3 386.7 383.1 379.5 375.9 372.3 368.7 365.1 361.5 357.9 354.3 350.7 347.1 343.5 339.9];

xDataCp = [100.0 150.0 200.0 250.0 298.0 350.0 400.0 450.0 500.0 550.0 600.0 650.0 700.0 750.0 800.0 850.0 900.0 950.0 1000  1050];
yDataCp = [370.4 376.4 382.3 388.3 394.0 400.2 406.2 412.1 418.1 424.0 430.0 436.0 441.9 447.9 453.8 459.8 465.8 471.7 477.7 483.6];

lambda = interp1(xDataLambda,yDataLambda,T,'linear');   % in W/(m*K);
cp = interp1(xDataCp,yDataCp,T,'linear');               % in J/(kg*K) 
roh = 8940;  % in kg/m³

end

