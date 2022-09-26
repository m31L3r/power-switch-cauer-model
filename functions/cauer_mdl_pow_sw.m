function [rth,cth] = cauer_mdl_pow_sw(beta,Lz,x, hs)

% __________________________________________________________
% ----------------  DESCRIPTION  ---------------------------
% Calculate cauer model terms for State Space Model.
%
% __________________________________________________________
% ----------------  USAGE  ---------------------------------
% SYNTAX:  
%       [rth,cth] = cauerModelTerms(beta,x,flowrate)
%
% INPUT:
%       beta	- Angle for thermal heat spread in degree
%       Lz      - Array with height of each layer.
%       x       - Current state vector with temperatures of
%                 each layer.
%       hs      - Array with heatsink parameters.
%       
% OUTPUT:
%       rthVec  - Vector of all calculated rth values
%       cthVec  - Vector of all calculated cth values
%
% __________________________________________________________
% ----------------  NOTES  ---------------------------------
%
%                 _________
%                /        |\ 
%               /         | \
%              /          |  \
%             /           |   \
%            /            |beta\
%
% __________________________________________________________
% ----------------  COPYRIGHT  -----------------------------
% AUTHOR :          Michael Meiler
% DATE :      	     05.01.2021

rth = zeros(8,1);
cth = zeros(8,1);

beta    = beta/180 * pi;
tan_b   = tan(beta);

% ==========================================================
% ----------------  Chip specs  ----------------------------
% ==========================================================

% SiC specific material constants.
[lambda,cpSic,rohSic] = SiCLut(x(1));

height = Lz(1); % in m
Lxy = 4.896e-3 *2*0.8;    % in m
Axy = Lxy^2;    % in m²
% junction_thickness = 12e-6;     % in m

rthSic  = 1/lambda * height/(Axy);
massSic = rohSic*Axy*height;%*(1-junction_thickness/height);
rth(1) = rthSic;
cth(1) = massSic*cpSic;

% ==========================================================
% ----------------  Silver Sinter specs  -------------------
% ==========================================================

% Silver sinter specific material constants.
[lambda,cpSinter,rohSinter] = sinterSilverLut(x(2));

height = Lz(2); % in m

massSinter  = volume_square_frustum(Lxy,height,beta) * rohSinter;
rthSinter   = calc_rth_frustum(lambda,Lxy,height,beta);
rth(2) = rthSinter;
cth(2) = massSinter*cpSinter;

% Calculate side lengths for the next area.
Lxy = Lxy + 2*height*tan_b;	% in m (tan_b is heatspread!)

% ==========================================================
% ----------------  DCB,top specs  -------------------------
% ==========================================================

% DCB,top specific material constants.
[lambda,cpDcbTop,rohDcbTop] = copperLut(x(3));

height = Lz(3); % in m

massDcbTop  = volume_square_frustum(Lxy,height,beta) * rohDcbTop;
rthDcbTop   = calc_rth_frustum(lambda,Lxy,height,beta);
rth(3) = rthDcbTop;
cth(3) = massDcbTop*cpDcbTop;

% Calculate side lengths for the next area.
Lxy = Lxy + 2*height*tan_b;   % in m (tan_b is heatspread!)

% ==========================================================
% ----------------  Ceramic specs  -------------------------
% ==========================================================

% Ceramic specific material constants.
[lambda,cpDcbMid,rohDcbMid] = Si3N4Lut(x(4));

height = Lz(4); % in m

massDcbMid  = volume_square_frustum(Lxy,height,beta) * rohDcbMid;
rthDcbMid   = calc_rth_frustum(lambda,Lxy,height,beta);
rth(4) = rthDcbMid;
cth(4) = massDcbMid*cpDcbMid;

% Calculate side lengths for the next area.
Lxy = Lxy + 2*height*tan_b;   % in m (tan_b is heatspread!)

% ==========================================================
% ----------------  DCB,bot specs  -------------------------
% ==========================================================

% DCB,bot specific material constants.
[lambda,cpDcbBot,rohDcbBot] = copperLut(x(5));

height = Lz(5); % in m

massDcbBot  = volume_square_frustum(Lxy,height,beta) * rohDcbBot;
rthDcbBot   = calc_rth_frustum(lambda,Lxy,height,beta);
rth(5) = rthDcbBot;
cth(5) = massDcbBot*cpDcbBot;

% Calculate side lengths for the next area.
Lxy = Lxy + 2*height*tan_b;   % in m (tan_b is heatspread!)

% ==========================================================
% ----------------  Solder specs  --------------------------
% ==========================================================

% Solder specific material constants.
[lambda,cpSolder,rohSolder] = solderSnSb5Lut(x(6));

height = Lz(6); % in m

massSolder  = volume_square_frustum(Lxy,height,beta) * rohSolder;
rthSolder   = calc_rth_frustum(lambda,Lxy,height,beta);
rth(6) = rthSolder;
cth(6) = massSolder*cpSolder;

% Calculate side lengths for the next area.
Lxy = Lxy + 2*height*tan_b;   % in m (tan_b is heatspread!)

% ==========================================================
% ----------------  Baseplate Heatsink specs  --------------
% ==========================================================

% Baseplate specific material constants.
[lambda,cpBase,rohBase] = baseOfCuLut(x(7));

height = Lz(7); % in m

massBase = volume_square_frustum(Lxy,height,beta) * rohBase;
rthBase  = calc_rth_frustum(lambda,Lxy,height,beta);
rth(7) = rthBase;
cth(7) = massBase*cpBase;

% ==========================================================
% ----------------  Cooling Liquid Specs  ------------------
% ==========================================================

% Coolant specific material constants.
[~,cpCoolant,rohCoolant] = CoolantLut(x(8));

active_sink_area    = hs(1);
mass_cool_liq       = rohCoolant * hs(2)/1000; % Volume of cooling liq in l
fr                  = hs(3); % l/min

alpha = fr/60*cpCoolant;                % Heat Transfer Coefficient in W/K
cth(8) = cpCoolant*mass_cool_liq;      % cp times cooling liquid mass in heatsink % J/K
rth(8) = 1/(alpha*active_sink_area);

end

