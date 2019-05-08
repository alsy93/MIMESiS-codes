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
%Temperatures needed

Tds = 4;        % T deep space [K]
Tsc_h = 323;    % T high internal spacecraft [K]
Tsc_c = 273;    % T cold internal spacecraft [K]


% Carrier data

A_front = 1 * 0.1^2;    %Area in front of the planet 1dm^2 [m^2]
A_side = 2 * A_front;   %Lateral area: 2U-cubesat considered [m^2]

Gsc = 10;               % Thermal conductiviy [W/m^2K]

REF = 1;                % Radiative Effective Factor (changes with altitude)     

Qel = 400;              % Power dissipation from electronic unit [W]
Qcpu = 200;             % Power dissipation from cpu unit [W]


alpha_f = 0.14;         % Pag 128 multilayer composition material
eps_f = 0.6; 
alpha_l = 0.09;         % Pag 128 multilayer composition material
eps_l = 0.88;  

alpha_b = 0.2;          % Pag 128 multilayer composition material
eps_b = 0.059;          %

% Heat fluxes

sigma = 5.67e-8;        % Stefan-B constant
a = 0.99;               % Enceladus Albedo
asat = 0.47;            % Saturn's albedo

L = 3.9e26;             % Luminosity of the Sun [W]
d = 1.496e11 +1.272e12; % 1AU + Enceladus dinstance to Earth [m]         
WS = L / (4*d^2);       % Solar flux density reaching Enceladus [W/m^2]

r = (252.1)%*1e3;        % Maximum altitude  [m]
Wir = 4.7e9 /(4*pi*r^2);% Heat flux radiation from Enceladus [W/m^2]
%Wir = (WS/4 *(1-a)); % from ESS200A Prof. Jin-Yi Yu 

r = (237948)*1e3;       % Enceladus dinstance from Saturn [m]
Wsat =5.4;              % Heat flux radiation from Saturn [W/m^2]

% Hot case: Qi+QIR+Qa+QS+QIRsat+Qasat-Qds = 0
Qi = Qel + Qcpu;
QS = WS *A_front * REF;
Qa = WS *A_front *alpha_b*a*REF;
Qir  = Wir*A_front *eps_b*REF;

Qirsat = Wsat * A_side *eps_b*REF;
Qasat = Wsat *A_front *alpha_b*asat*REF;

%% Plot Enceladus hot situation

set(0,'DefaultFigureWindowStyle','docked');
set(0,'defaulttextInterpreter','latex');
set(0,'defaultTextFontSize',12);
set(0,'DefaultLegendFontSize',5);
set(0,'defaultAxesFontSize',12);

figure ('Name','Transient of Temperature in Enceladus hot steady state case')
        
        legend();hold on
        plot(T_e,'LineWidth',2,'DisplayName','Fanculo')
        %plot(t113,deltaStep113,'LineWidth',2,'DisplayName','Default step size variation of ODE113 ')
        grid on; grid minor


%% Cold case: Qi+QIR-Qd=0

QS=0;
Qa=0;
Qirsat=0;
Qasat=0;
Qi=Qcpu*0.2;
