function [lambda,cp,roh] = SiCLut(T)
% Lookuptable for temperature dependant material constants.

T = T + 273.15;

xDataLambda = [300.0 329.0 341.9 354.8 364.5 374.2 383.9 400.0 412.9 429.0 445.2 461.3 477.4];
yDataLambda = [296.5 237.4 220.7 206.8 197.7 189.6 182.2 171.2 163.4 154.6 146.6 139.4 132.7];

xDataCp = [25  100 200 300  400  500  600  700  800  900] + 273.15;
yDataCp = [680 840 940 1030 1080 1120 1160 1190 1210 1240];

lambda = interp1(xDataLambda,yDataLambda,T,'linear','extrap');       % in W/(m*K);
cp = interp1(xDataCp,yDataCp,T,'linear','extrap'); %710 static;    % in J/(kg*K) 
roh = 3210;     % in kg/m³

end

