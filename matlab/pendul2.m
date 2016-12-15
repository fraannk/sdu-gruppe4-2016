format compact
clear
close all

S = 0                           % Theta pos for ligev�gt
g = 9.82;                       % tyngde acc.
l = 0.3;                        % l�ngde af pendul

f_gen = 44E3                    % switch frekvens for sensor system
w_gen = 2*pi*f_gen

motor_tau = 18E-3
motor_num = [motor_tau 0]
motor_den = [motor_tau 1]
motor = 1,6 * tf(motor_num, motor_den)

vogn_num = [1.37]
vogn_den = [1 0 0]
vogn = tf(vogn_num, vogn_den)
vogn = 1.37

pendul_num = [1];
pendul_den = [l 0 -g]
pendul = tf(pendul_num, pendul_den)

filter_tau_per_volt = 0.3491
filter_gain = 3.5 * filter_tau_per_volt
filter_tau = 3.571E-6
filter_num = [filter_gain]
filter_den = [filter_tau 1]
filter = tf(filter_num, filter_den)

ensretter_gain = 1
ensretter_tau = 4.7E-4
ensretter_num = [ensretter_gain]
ensretter_den = [ensretter_tau 1]
ensretter = tf(ensretter_num, ensretter_den)

summa = 4.5


Hopenloop = motor * vogn * pendul * filter * ensretter * summa

[Gm, Pm, Wgm, Wpm] = margin(Hopenloop)

% PID regulator beregninger 
% �nsket fasemargin Phi_m
Phi_m_deg = 60
Phi_m = (2*pi*Phi_m_deg)/360

%Pboost = Phi_m_deg-Pm
%Kc = 1/Gm
%Kboost = tan((0.25*pi) + ((Pboost*pi)/(4*180)))
%Wz = Wpm/Kboost
%Wp = Kboost*Wpm

s = tf('s');
%PID_regulator = (Kc/s)*((1+s/Wz)^2/(1+s/Wp)^2)

% PD regulator beregninger
% �nsket fasemargin Phi_m
% Reg. bog side 278

alfa = (1-sin(Phi_m))/(1+sin(Phi_m))
%alfa=0.1
Am = 20*log(1/sqrt(alfa))
Wm = 22.1% afl�st, hvor A = -Am
Tau_d = 1/(Wm*sqrt(alfa))

%alfa = 0.1
%Tau_d = 20
%Wm = 1/(sqrt(alfa)*Tau_d) 
%Am = 1

% side 349
R2 = 1E3
syms R1
R1 = double(solve(alfa==R2/(R1+R2),R1))
syms R3
R3 = double(solve(Am == R3/(R1+R2),R3))
syms C1
C1 = double(solve(alfa*Tau_d == (R1*R2*C1)/(R1+R2),C1))


PD_regulator = Am*((Tau_d*s+1)/(alfa*Tau_d*s+1))

%regulator = PID_regulator
regulator = PD_regulator

[Gc_num, Gc_den] = tfdata(regulator)
regulator_num = Gc_num{1,1}
regulator_den = Gc_den{1,1}

Hforward = regulator * motor * vogn * pendul
Hfeedback = filter * ensretter * summa
Hclosedloop = feedback(Hforward, Hfeedback)

fig1 = figure(1)
margin(regulator)
hold on
margin(Hopenloop)
hold on
margin(Hopenloop*regulator)
grid
legend('PD regulator','Openloop','Openloop + Regulator')
print( fig1, '-dpng', '-r200', 'reg_bode_all.png')

fig2 = figure(2)
step(Hclosedloop)
grid
print( fig2, '-dpng', '-r200', 'reg_step_response.png')



