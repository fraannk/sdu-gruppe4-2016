clc
clear
close all

% Data import ERS from BODE 100
data = csvread('esr.csv',21);
f = data(:,1);
esr = data(:,2);

% Setup figure
fig = figure(1);

% Write amplitude to figure
semilogx(f,esr,'LineWidth',2,'Color','Blue');
title('ESR');
xlabel('Frequency [Hz]');
ylabel('Re(Zc) [ohm]');
grid;

legend('Målt Re(Zc)')

% Export figure as 200dpi PNG
print( fig, '-dpng', '-r200', 'esrplot.png')
