% MIMESiS THERMAL SYSTEM DATA

% First attempt of one single node simulation. Hypotesis of SSC: 
% Qinternal-Qoutput+Qinput=0
%--------------------------------------------------------------------------
% TO DO:
% Check power dissipation from cpu and electric unit
% Check the Saturn magnetosphere heat flux generation
% Check the REF
% Check alpha and eps
% Check IR radiation from Enceladus and Saturn
% Check the flux exchange due to the atmosphere: DeltaT = 30K
% Check 

clear all; clc; close all
time = 7200;
set(0,'DefaultFigureWindowStyle','docked');
set(0,'defaulttextInterpreter','latex');
set(0,'defaultTextFontSize',12);
set(0,'DefaultLegendFontSize',5);
set(0,'defaultAxesFontSize',12);

% Enceladus' hot case

%Temperatures needed

Tds = 4;        % T deep space [K]
Tsc_h = 323;    % T high internal spacecraft [K]
Tsc_c = 273;    % T cold internal spacecraft [K]


% Carrier data

A_front = 1 * 0.1^2;    %Area in front of the planet 1dm^2 [m^2]
A_side = 2 * A_front;   %Lateral area: 2U-cubesat considered [m^2]

Gsc = 10;               % Thermal conductiviy [W/m^2K]

REF = 1;                % Radiative Effective Factor (changes with altitude)     

Qdiss = 29.96;          % Total heat dissipated by electric and cpu [W]


alpha_f = 0.14;         % Pag 128 multilayer composition material
eps_f = 0.6; 
alpha_l = 0.09;         % Pag 128 multilayer composition material
eps_l = 0.88;  

alpha_b = 0.2;          % Pag 128 multilayer composition material
eps_b = 0.059;          %

% Heat fluxes
Na = 6.022e23;          % Avogadro number [1/mol]
mass_H20 =18.01528*1e-3;% H20 atomic mass [kg/mol]
n_H20 = 12.2e11;        % Numerical value of number density [1/m^3]
rho = n_H20*mass_H20/Na;% Enceladus maximum density [kg/m^3] 
v = 120;                % Maximum velocity reached [m/s]
R = A_side/(2*0.1);     % Mean radius
Qball = sqrt(rho/R)*v^3;% Peak heating due to Enceladus atmosphere

sigma = 5.67e-8;        % Stefan-B constant
a = 0.99;               % Enceladus Albedo
asat = 0.47;            % Saturn's albedo

L = 3.9e26;             % Luminosity of the Sun [W]
d = 1.496e11 +1.272e12; % 1AU + Enceladus dinstance to Earth [m]         
WS = L / (4*pi*d^2);    % Solar flux density reaching Enceladus [W/m^2]

r = 252.1*1e3;      % Maximum altitude  [m]
Wir = 4.7e9 /(4*pi*r^2);% Heat flux radiation from Enceladus [W/m^2]
%Wir = (WS/4 *(1-a)); % from ESS200A Prof. Jin-Yi Yu 

r = (237948)*1e3;       % Enceladus dinstance from Saturn [m]
Wsat =5.4;              % Heat flux radiation from Saturn [W/m^2]

% Hot case: Qi+QIR+Qa+QS+QIRsat+Qasat-Qds = 0
Qi = Qdiss;
QS = WS *A_front * REF;
Qa = WS *A_front *alpha_b*a*REF;
Qir  = Wir*A_front *eps_b*REF;

Qirsat = Wsat * A_side *eps_b*REF;
Qasat = Wsat *A_front *alpha_b*asat*REF;

model = 'FirstAttempt_Enceladus.slx';
load_system(model)
sim(model)

%% Earth's hot case

au = 1.496e11;
WS_e = L /(4*pi*au^2);  % Solar flux density from 1 AU [W/m^2]
Wir_e = 228;            % Heat frlux rafiation from Earth [W/m^2]
a_e = 0.3;              % Earth's albedo

QS_e = WS_e *A_front * REF;
Qa_e = WS_e *A_front *alpha_b*a_e*REF;
Qir_e = Wir_e *A_front *eps_b*REF;

model = 'FirstAttempt_Earth.slx';
load_system(model)
sim(model)


%% Plot Enceladus VS Earth hot situation

figure ('Name','Transient of Temperature in Enceladus cold steady state case')
        
        legend();hold on
        plot(Thot_enc ,'LineWidth',2,'DisplayName','T transient for Enceladus hot case')
        plot(Thot_earth ,'LineWidth',2,'DisplayName','T transient for Earth hot case')
        grid on; grid minor


%% Cold case: Qi+QIR-Qd=0

QS=0;
Qa=0;
Qi=2;
Qasat=0;

QS_e = 0;
Qa_e = 0;

model = 'FirstAttempt_ColdEarth.slx';
load_system(model)
sim(model)
model = 'FirstAttempt_ColdEnceladus.slx';
load_system(model)
sim(model)


figure ('Name','Transient of Temperature in Enceladus hot steady state case')
        
        legend();hold on
        plot(Tcold_enc ,'LineWidth',2,'DisplayName','T transient for Enceladus hot case')
        plot(Tcold_earth ,'LineWidth',2,'DisplayName','T transient for Earth hot case')
        grid on; grid minor

