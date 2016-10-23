clc
clear
close all

% Component values
r = 0.68
R = 15
c = 220E-6
l = 250E-6
vin = 25
d = 0.6

% Data import gain from BODE 100
gaindata = csvread('gain.csv',21)
f_gain = gaindata(:,1)
w1 = f_gain*2*pi
gain = gaindata(:,4)

% Data import phase from BODE 100
phasedata = csvread('phase.csv',21)
f_phase = phasedata(:,1)
%w1 = f*2*pi
phase = phasedata(:,4)

% Setup figure
fig = figure(1)
subplot(2,1,1)

% Transfer fuction
num = [((r)/l) (1/(l*c))]
den = [((r/R)+1) ((1/(R*c))+(r/l)) (1/(l*c))]
H = tf(num,den)

% Get Bode plot data
[mag,pha,w]=bode(H,w1);

% Write amplitude to figure
semilogx(w/(2*pi),20*log10(squeeze(mag)),'LineWidth',2,'Color','Red')
title('Magnitude')
xlabel('Frequency [Hz]')
ylabel('Magnitude [dB]')
grid

% Add BODE100 aplitude to figure
hold on
plot(f_gain, gain,'LineWidth',2,'Color','Black')
legend('G(s)','H(s) m�lt')

% Figure setup
subplot(2,1,2)

% Write phase to figure
semilogx(w/(2*pi),(squeeze(pha)),'LineWidth',2,'Color','Red')
title('Phase')
xlabel('Frequency [Hz]')
ylabel('Phase [deg]')
grid

% Add BODE100 phase to figure
hold on
plot(f_phase, phase,'LineWidth',2,'Color','Black')
legend('G(s)','H(s) m�lt')

% Export figure as 200dpi PNG
print( fig, '-dpng', '-r200', 'bodeplot.png')
