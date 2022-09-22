function [lambda,cp,roh] = SiLut(T)
% Lookuptable for temperature dependant material constants.

T = T + 273.15;

xDataLambda = [4    10   20   40   80    150 200 300 400 600 800 1000 1688.2];
yDataLambda = [300  2300 5000 3500 1340  410 260 150 99  62  42  31   26];

xDataCp = [1        2       3       4       5    10   15  20   40 80  150 250 298.1 400 600 1000 1500 1688.2];
yDataCp = [0.0003   0.002   0.007   0.018   0.03 0.28 1.1 3.37 44 188 426 648 705   794 871 946  1013 1025];

lambda = interp1(xDataLambda,yDataLambda,T,'linear');       % in W/(m*K);
cp = interp1(xDataCp,yDataCp,T,'linear'); %710 static;    % in J/(kg*K) 
roh = 2330;     % in kg/m³

end

