format compact
clear
close all

S = 0                           % Theta pos for ligev�gt
g = 9.82;                       % tyngde acc.

p_x = 0.015                     % Dim p� pendul til bestemmelse
p_y = 0.015                     % af m_p
p_z = 0.1
p_vol = p_x*p_y*p_z
dens_al = 2700;                 % v�gtfylde aluminium kg/m^3
m_p = p_vol * dens_al           % masse pendul

L = p_z
m = 0.700                       % masse samlet system
m_v = m-m_p                     % masse vogn

f0 = 50E4                        % switch frekvens for sensor system
w0 = 2*pi*f0

% Sensor dynamic
R0 = 1000
Cf = 1.013E-7
Lf = 10E-3
Rf = 10

%sensor_num = [R0*Cf 0]
%sensor_den = [Lf*Cf (Rf+R0)*Cf 1]
%sensor_H = tf(sensor_num,sensor_den)

filter

sensor_gain = 3
sensor_tau = 103E-6


% System dynamic
system_num = [1];
system_den = [m_v*L 0 -m*g]
system_H = tf(system_num, system_den)

% Vogn dynamic
vogn = 1.355;
vogn_offset = 0.655

% Motorstyring dynamic
Rm = 3.1;
Lm = 51.5E-3;
motor_num = [1];
motor_den = [Lm Rm];
motor_H = tf(motor_num, motor_den);




open_loop_H = motor_H * vogn * m * system_H * sensor_H

%sim('pendul_sim.slx');




