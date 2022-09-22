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
Lx = 4.896e-3 *2*0.8;    % in m
Ly = Lx;    % in m
% junction_thickness = 12e-6;     % in m

rthSic  = 1/lambda * height/(Lx*Ly);
massSic = rohSic*Lx*Ly*height;%*(1-junction_thickness/height);
rth(1) = rthSic;
cth(1) = massSic*cpSic;

% ==========================================================
% ----------------  Silver Sinter specs  -------------------
% ==========================================================

% Silver sinter specific material constants.
[lambda,cpSinter,rohSinter] = sinterSilverLut(x(2));

height = Lz(2); % in m

massSinter  = volumeSquareFrustum(Lx,height,beta) * rohSinter;
rthSinter   = calcRthFrustum(lambda,Lx,height,beta);
rth(2) = rthSinter;
cth(2) = massSinter*cpSinter;

% Calculate side lengths for the next area.
Lx = Lx + 2*height*tan_b;	% in m (tan_b is heatspread!)
Ly = Ly + 2*height*tan_b;   % in m (tan_b is heatspread!)

% ==========================================================
% ----------------  DCB,top specs  -------------------------
% ==========================================================

% DCB,top specific material constants.
[lambda,cpDcbTop,rohDcbTop] = copperLut(x(3));

height = Lz(3); % in m

massDcbTop  = volumeSquareFrustum(Lx,height,beta) * rohDcbTop;
rthDcbTop   = calcRthFrustum(lambda,Lx,height,beta);
rth(3) = rthDcbTop;
cth(3) = massDcbTop*cpDcbTop;

% Calculate side lengths for the next area.
Lx = Lx + 2*height*tan_b;   % in m (tan_b is heatspread!)
Ly = Ly + 2*height*tan_b;	% in m (tan_b is heatspread!)

% ==========================================================
% ----------------  Ceramic specs  -------------------------
% ==========================================================

% Ceramic specific material constants.
[lambda,cpDcbMid,rohDcbMid] = Si3N4Lut(x(4));

height = Lz(4); % in m

massDcbMid  = volumeSquareFrustum(Lx,height,beta) * rohDcbMid;
rthDcbMid   = calcRthFrustum(lambda,Lx,height,beta);
rth(4) = rthDcbMid;
cth(4) = massDcbMid*cpDcbMid;

% Calculate side lengths for the next area.
Lx = Lx + 2*height*tan_b;   % in m (tan_b is heatspread!)
Ly = Ly + 2*height*tan_b;	% in m (tan_b is heatspread!)

% ==========================================================
% ----------------  DCB,bot specs  -------------------------
% ==========================================================

% DCB,bot specific material constants.
[lambda,cpDcbBot,rohDcbBot] = copperLut(x(5));

height = Lz(5); % in m

massDcbBot  = volumeSquareFrustum(Lx,height,beta) * rohDcbBot;
rthDcbBot   = calcRthFrustum(lambda,Lx,height,beta);
rth(5) = rthDcbBot;
cth(5) = massDcbBot*cpDcbBot;

% Calculate side lengths for the next area.
Lx = Lx + 2*height*tan_b;   % in m (tan_b is heatspread!)
Ly = Ly + 2*height*tan_b;	% in m (tan_b is heatspread!)

% ==========================================================
% ----------------  Solder specs  --------------------------
% ==========================================================

% Solder specific material constants.
[lambda,cpSolder,rohSolder] = solderSnSb5Lut(x(6));

height = Lz(6); % in m

massSolder  = volumeSquareFrustum(Lx,height,beta) * rohSolder;
rthSolder   = calcRthFrustum(lambda,Lx,height,beta);
rth(6) = rthSolder;
cth(6) = massSolder*cpSolder;

% Calculate side lengths for the next area.
Lx = Lx + 2*height*tan_b;   % in m (tan_b is heatspread!)
Ly = Ly + 2*height*tan_b;	% in m (tan_b is heatspread!)

% ==========================================================
% ----------------  Baseplate Heatsink specs  --------------
% ==========================================================

% Baseplate specific material constants.
[lambda,cpBase,rohBase] = baseOfCuLut(x(7));

height = Lz(7); % in m

massBase = volumeSquareFrustum(Lx,height,beta) * rohBase;
rthBase  = calcRthFrustum(lambda,Lx,height,beta);
rth(7) = rthBase;
cth(7) = massBase*cpBase;

% Calculate side lengths for the next area.
Lx = Lx + 2*height*tan_b;   % in m (tan_b is heatspread!)
Ly = Ly + 2*height*tan_b;	% in m (tan_b is heatspread!)

% ==========================================================
% ----------------  Cooling Liquid Specs  ------------------
% ==========================================================

% Coolant specific material constants.
[~,cpCoolant,rohCoolant] = CoolantLut(x(8));

activeSinkArea  = hs(1); %Lx*Ly*700;
massCoolLiq     = rohCoolant * hs(2)/1000; % Volume of cooling liq in l
fr              = hs(3); % l/min

alpha = fr/60*cpCoolant;                % Heat Transfer Coefficient in W/K
cth(8) = cpCoolant*massCoolLiq;      % cp times cooling liquid mass in heatsink % J/K
rth(8) = 1/(alpha*activeSinkArea);

end

