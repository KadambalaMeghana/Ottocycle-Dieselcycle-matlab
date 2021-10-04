%Otto Cycle Efficiency
clear all
clc
%Cp=input('specific heat at constant pressure');
%Cv=input('specific heat at constant volume');
disp('---------------------------------------')
disp('          DESIGN OTTO CYCLE            ') 
disp('---------------------------------------') 
disp('  ENTER ENGINE PARAMETERS AND PRESS OK ') 
disp('---------------------------------------')
%EXTRACTION OF THE ENGINE PARAMETERS
pause(2);
inputeng = inputdlg({ 'Compression ratio of the otto cycle', 'Pressure at the entry in the cylinder (in pascals)', 'Temperature at the entry in cylinder(in kelvin)','Heat added at constant volume (in J/kg)'},'ENGINE PARAMETERS', [1 50; 1 50; 1 50; 1 50]); 
%Checking for missing input 
for i = 1:4 
 if (isempty(inputeng{i})) 
 err = msgbox('AN EMPTY PARAMETER INPUT FOUND. Please Retry', 'ERROR', 'error'); 
 clc 
 return 
 end 
end 
r = str2num(inputeng{1});
p1 = str2num(inputeng{2});
t1 = str2num(inputeng{3});
h1 = str2num(inputeng{4});
nr = 2; % 4-Stroke cycle 
Cv=718;
g=1.4;
R=287;
v1=(R*t1)/p1;
v2=v1/r;
p2=p1*((r)^g);
t2=t1*r^(g-1);
v3=v2;
t3=t2+(h1/Cv);
p3=(p2*t3)/t2;
v4=v1;
p4=p3/((r)^g);
t4=t3/(r)^(g-1);
eff=1-(1/(r)^(g-1));
heatrej=Cv*(t4-t1);
workdone=h1-heatrej;
OUTPUT = msgbox({ [ 'T1 = ',num2str(t1)],['T2 = ', num2str(t2)], ['T3 = ', num2str(t3)],['T4 =', num2str(t4)],[ 'P1 = ',num2str(p1)],['P2 = ', num2str(p2)], ['P3 = ', num2str(p3)],['P4 =', num2str(p4)],['Theoritical efficiency of the cycle= ', num2str(eff)], ['Heat rejected in this cycle = ', num2str(heatrej)], ['Net workdone in this cycle = ', num2str(workdone)],['Click OK to Continue']}, 'RESULT', 'help'); 
disp(' To View P-V Diagram, Press OK '); 
uiwait(OUTPUT);
clc 
cd('C:')

%theoritical plot between varying compression ratio and efficiency
r=1:1:10;
e=(1-(1./(r).^(g-1)))*100;
plot(r,e,'--','color', 'r', 'linewidth',3)
xlabel('Compression ratio');
ylabel('Efficiency');
title('Otto Cycle');