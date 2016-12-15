format compact
clear
close all

% Data import gain from BODE 100
bodedata = csvread('bodeExport1.csv',21)
f = bodedata(:,1)
f_gain = bodedata(:,4)
f_phase = bodedata(:,7)

fig1 = figure
subplot(2,1,1)

semilogx(f,f_gain,'LineWidth',2,'Color','Red')
title('Magnitude')
xlabel('Frequency [Hz]')
ylabel('Magnitude [dB]')
grid

hold on



