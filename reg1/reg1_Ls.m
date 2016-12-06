clc
clear
close all

% Data import ERS from BODE 100
data = csvread('ls.csv',21);
f = data(:,1);
ls = data(:,4);

% Setup figure
fig = figure(1);

% Write amplitude to figure
semilogx(f,-ls,'LineWidth',2,'Color','Blue');
title('Ls');
xlabel('Frequency [Hz]');
ylabel('L [H]');
grid;

legend('Målt Ls)')

% Export figure as 200dpi PNG
print( fig, '-dpng', '-r200', 'lsplot.png')
