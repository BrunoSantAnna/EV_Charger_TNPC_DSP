% TNPC Parameters for Running the Simulations

close all
clear
%% Definition of the parameters

% Simulation and Switching
Ts     = 2*(4167)/100e6;
fs     = 1/Ts;
% Tstep  = Ts/250;
Tstep  = Ts/1000; 

% Grid
f_gr = 60;
T_gr = 1/f_gr;
w_gr = 2*pi*f_gr;
V_gr = 127;
L_gr = 100e-6;
% R_gr = 0.1*2*pi*f_gr*L_gr;
R_gr = 0.01;


% Semiconductor
Rfet = 1e-3;

% DC Side
Cdc = 1.5e-3;
Rdc = 0.1/(2*pi*60*Cdc);
Vdc = 800;
S_rated = 1e3;

% Filter
Lf  = 1e-3;
Xf  = 2*pi*f_gr*Lf;
Rf  = 0.1*Xf;
Lg  = 0.5e-3;
Xg  = 2*pi*f_gr*Lg;
Rg  = 0.1*Xg;
Cf  = 5e-6;
Xc = 0.1/(2*pi*f_gr*Cf);

% Base Units
S_base = S_rated;
I_base = S_base/(sqrt(3)*V_gr);
V_base = sqrt(3)*V_gr;
Vdc_base = Vdc;

% Transducers
K_i   = 1/25;
K_vdc = 1/500;
K_vc  = 1/200;

% Enable signals
T_en           = 0.1;
T_DC_charge    = 0.4;

%% SOGI

% SOGI parameters
Ts_sogi = 1/12000;     % Actual control sampling period [s]
f0_sogi = 60;          % Tuning frequency [Hz]
k_sogi  = sqrt(2);     % Initial choice; adjust as discussed

w0_sogi = 2*pi*f0_sogi;

% Bilinear transformation, prewarped at w0_sogi
c_sogi = w0_sogi/tan(w0_sogi*Ts_sogi/2);

den0_sogi = c_sogi^2 ...
          + k_sogi*w0_sogi*c_sogi ...
          + w0_sogi^2;

% Numerator coefficients:
% D(z): bD*(1 - z^-2)
% Q(z): bQ*(1 + 2*z^-1 + z^-2)
bD_sogi = single(k_sogi*w0_sogi*c_sogi/den0_sogi);
bQ_sogi = single(k_sogi*w0_sogi^2/den0_sogi);

% Common denominator: 1 + a1*z^-1 + a2*z^-2
a1_sogi = single(2*(w0_sogi^2-c_sogi^2)/den0_sogi);
a2_sogi = single((c_sogi^2 ...
               - k_sogi*w0_sogi*c_sogi ...
               + w0_sogi^2)/den0_sogi);


% %% Fuzzy lookup generation
% % 1. Carrega o seu sistema Fuzzy original
% meuFuzzy = readfis('AS_Bal_3out.fis');
% 
% % 2. Define os vetores de entrada (Breakpoints)
% % Supondo que as entradas variem de 0 a 1. Ajuste para os seus limites reais!
% resolucao = 23; % Quantidade de pontos por eixo
% lQ_vetor = linspace(-1, 1, resolucao);
% lH_vetor = linspace(0, 1, resolucao);
% lV_vetor = linspace(0, 1, resolucao);
% 
% % 3. Cria a Matriz 3D vazia para armazenar as saídas
% gQ_LUT = zeros(resolucao, resolucao, resolucao);
% gH_LUT = zeros(resolucao, resolucao, resolucao);
% gV_LUT = zeros(resolucao, resolucao, resolucao);
% 
% % 4. Varre todas as combinações e avalia o Fuzzy
% for i = 1:resolucao
%     for j = 1:resolucao
%         for k = 1:resolucao
%             % Monta o vetor com as 3 entradas exatas deste ponto do grid
%             entradas_atuais = [lQ_vetor(i), lH_vetor(j), lV_vetor(k)];
% 
%             % Avalia o Fuzzy offline e salva na matriz tridimensional
%             fis_out = evalfis(meuFuzzy, entradas_atuais);
%             gQ_LUT(i, j, k) = fis_out(1);
%             gH_LUT(i, j, k) = fis_out(2);
%             gV_LUT(i, j, k) = fis_out(3);
%         end
%     end
% end