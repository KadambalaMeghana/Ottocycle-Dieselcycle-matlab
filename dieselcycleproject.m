% DESIGN YOUR IDEAL DIESEL CYCLE 
clear all 
close all 
clc 
disp('---------------------------------------')
disp('         DESIGN DIESEL CYCLE           ') 
disp('---------------------------------------') 
disp('  ENTER ENGINE PARAMETERS AND PRESS OK ') 
disp('---------------------------------------')
%EXTRACTION OF THE ENGINE PARAMETERS
pause(2);
inputeng = inputdlg({ 'Cylinder Bore Diameter (mm)', 'Cylinder Stroke Length (mm)', 'No. of Cylinder(s)'},'ENGINE PARAMETERS', [1 50; 1 50; 1 50]); 
%Checking for missing input 
for i = 1:3 
 if (isempty(inputeng{i})) 
 err = msgbox('AN EMPTY PARAMETER INPUT FOUND. Please Retry', 'ERROR', 'error'); 
 clc 
 return 
 end 
end 
D = str2num(inputeng{1});
L_s = str2num(inputeng{2});
n = str2num(inputeng{3});
nr = 2; % 4-Stroke cycle 
%calculating CC of engine 
cc1 = ((pi/4)*(D^2)*(L_s)*n)/(1000); 
cc2 = ceil(cc1); 
cc = 100*(ceil(cc2/100)); 
clc 
if(cc == 0) 
 b = msgbox('Engine Parameters Not Acceptable. Kindly Retry', 'ERROR', 'error'); 
 return 
end 
clc
disp('--------------')
disp(' NOTE: 1 bar = 100000 Pa')
disp(' NOTE: 1 atm = 101325 Pa ')
disp(' NOTE: 1 Deg. Celsius = 273K')
disp('---------------------------------') 
disp(' Compression ratio - Ratio between the start and end volume for the compression phase(Process 1-2)[V1 / V2]') 
disp(' Cut off ratio - Ratio between the end and start volume for the combustion phase(Process 2-3) [V3 / V2]')
disp('-------------------------------')
disp(' ENTER PARAMETERS AND PRESS OK ') 
pause(2) 
%Accepting Initial Parameters of the cycle 
inputcnd = inputdlg({'Atmospheric Pressure (bar) :', 'Initial temperature (Celsius) :', 'Compression ratio :', 'Cut Off Ratio :'},'INITIAL PARAMETERS',[1 50; 1 50; 1 50; 1 50]); 
%checking for missing input conditions 
for j = 1:4 
 if (isempty(inputcnd{j}))
 Err = msgbox('AN EMPTY INPUT FIELD FOUND. Please Retry', 'ERROR', 'error'); 
 return 
 end
end 
p1 = str2num(inputcnd{1}); 
if(p1 == 0) 
 perr = msgbox('Initial Pressure Not Acceptable. Kindly Retry', 'ERROR', 'error');
 return
end 
pD1 = p1*100000; 
t1 = str2num(inputcnd{2}); 
if(t1 == 0) 
 terr = msgbox('Initial Temperature Not Acceptable. Kindly Retry', 'ERROR', 'error');
 return
end 
tD1 = t1 + 273; %conversion to kelvin
cr = str2num(inputcnd{3}); 
a = str2num(inputcnd{4});
r = 0.287;
cv = 0.718; 
cp = cv + r; 
gamma = cp/cv; 
clc 
%checking for Compression ratio values.
if(cr < 14) 
 e = msgbox('Very Low Compression Ratio.Try with values >= 14', 'ERROR', 'error');
 return
else if(cr > 23) 
 f = msgbox('High Compression Ratio. Try for values <= 23', 'ERROR', 'error');
 return 
 end
end 
%checking for cut-off ratio value 
if(a == 0) 
j = msgbox('Minimum value for Cut off Ratio cannot be 0', 'ERROR', 'error');
return 
end 
clc 
%swept volume 
v_s = (pi/4)*(D^2/(1000*1000))*(L_s/1000); 
%clearance volume 
v_c = v_s/(cr-1); 
%Finding the variable at different states 
% STATE 1 
vD1 = v_s+v_c; 
%STATE 2 
vD2 = (v_c); 
%Since pv gamma = Constant (adiabatic reversible process) 
pD2 = pD1*(cr^gamma); 
%Since p1v1/t1 = p2v2/t2 
tD2 = tD1*(cr^(gamma-1)); 
%For compression curve from state 1 to state 2 
CMP_volD =linspace(vD1, vD2, 100); 
CMP_presD = (((vD1./CMP_volD).^gamma)*pD1); 
%STATE 3 
vD3 = a*vD2;
%since p3v3/t3 = p2v2/t2 
pD3 = pD2;
tD3 = a*tD2; 
%STATE 4
vD4 = vD1; 
%Since pv"gamma = Constant (adiabatic reversible process) 
pD4 = pD3*((vD3/vD4)^gamma);
%p3v3/t3 = p4v4/t4 
tD4 = (pD4*vD4*tD3)/(pD3*vD3); 
txty = (pD4+pD2)/2; 
txtx = (vD1+vD3)/3; 
% for expansion curve fromstate 3 to state 4 
EXP_volD =linspace(vD3, vD4, 100); 
EXP_presD = (((vD3./EXP_volD).^gamma) *pD3); 
%Thermal Efficiency
T_EFD = 1-((1/(cr^(gamma-1)))*(((a^gamma)-1)/(gamma*(a-1)))); 
Tpercent = T_EFD*100; 
%Finding the NET WORK OUTPUT 
R = 287.1; 
mass = pD1*vD1*180/(R*tD1); 
Qa = mass*cp* (tD3-tD2)*1000;
Qr = mass*cv* (tD4 - tD1)*1000;
Wnet = Qa*T_EFD/1000; % kJ 
%Finding Mean Effective Pressure and Torque 
MEP = Wnet/(vD1 - vD2)/100000; %bar 
Torque = (MEP*100000*v_s)/2*pi*nr; %Nm 
x = cc;
y = Tpercent; 
z = cr; 
work = Wnet; 
%Displaying the output
OUTPUT = msgbox({ [ 'MEAN EFFECTIVE PRESSURE (bar) = ',num2str(MEP)],['THERMAL EFFICIENCY (%) = ', num2str(y)], ['Net WORK DONE (kJ) = ', num2str(work)],['TORQUE (Nm) =', num2str(Torque)],['COMPRESSION RATIO = ', num2str(z)], ['DESIGN CC = ', num2str(x)],['Click OK to Continue']}, 'RESULT', 'help'); 
disp(' To View P-V Diagram, Press OK '); 
uiwait(OUTPUT);
clc 
cd('C:')
%Saving output as table(.xlsx) 
fnameip1 = inputdlg({ 'Enter filename for Output Report(Spreadsheet)'},'SAVE AS',[1 50]); 
str1 = string(fnameip1); 
str2 = '.xlsx'; 
file = append(str1, str2); 
restable = table({ 'Design CC'; 'Thermal Efficiency (%)';'Net Work Done (kJ)'; 'Mean Effective Pressure (bar)'; 'Torque (Nm)'},[cc; Tpercent;Wnet;MEP;Torque], 'Variablenames', {'PARAMETERS', 'VALUE'}); writetable(restable, file, 'Sheet',1, 'Range', 'A1:B6') 
clc 
%Plotting the Cycle Pressure - Volume Curve
m = 1; 
figure(m) 
hold on 
grid on 
title('DIESEL CYCLE (ideal)') 
hold on 
plot(CMP_volD, CMP_presD,'--','color', 'r', 'linewidth',3)
hold on 
plot([vD2 vD3], [pD2 pD3], 'color', 'k', 'linewidth', 2) 
hold on 
plot(EXP_volD, EXP_presD,'--','color', 'b', 'linewidth',3) 
hold on 
plot([vD4 vD1], [pD4 pD1], 'color', 'k', 'linewidth',2) 
xlabel('VOLUME (m^3) >>>>', 'color','b') 
ylabel('PRESSURE (Pa) >>>>','color','b') 
text(txtx, txty, 'Enclosed Area gives Net work output') 
fill([CMP_volD EXP_volD], [CMP_presD EXP_presD],[0.7 0.7 0.7]) 
legend('Adiabatic Compression', 'Constant Pressure Heat Addition', 'Adiabatic Expansion', 'Constant Volume Heat Rejection') 
%Creating push button to save the plot. 
Controll = uicontrol('string', 'Save Plot', 'Callback', 'uiresume(figure(m))'); uiwait(figure(m)) 
%Saving the PV Plot 
fnameip2 = inputdlg({ 'Enter filename for PV Plot'},'SAVE AS',[1 50]); 
str3 = string(fnameip2); 
saveas(figure(m), str3,'jpg') 
%Plotting variation of efficiency wrt Compression and Cut-off Ratios 
%Case 1 - Keeping Cut-Off Ratio Constant 
gamma1 = 1.4; 
a1 = a; 
cr1 = linspace(14,23,10); 
M = 1; 
figure(M) 
for i1 = 1:10 
 T_EFDa(i1) = 1-((1/(cr1(i1)^(gamma1-1)))*(((a1^gamma1)-1)/(gamma1*(a1-1)))); 
 Tpercenta = T_EFDa*100;
 il = i1+1; 
end 
subplot(2,1,1) 
plot(cr1, Tpercenta,'-*','color','g', 'linewidth', 2.5) 
grid on 
axis([13 24 55 70])
xlabel('Compression ratio') 
ylabel('Thermal Efficiency (%)')
title('Thermal Efficiency Vs Compression Ratio'); 
%Case 2 - Keeping Compression Ratio Constant 
cr2 = cr; 
cutratio = a+5; 
a2 = linspace(1, cutratio, 10); 
for j1 = 1:10
 T_EFDb(j1) = 1-((1/(cr2^(gamma1-1)))*(((a2(j1).^gamma1)-1)/(gamma1*(a2(j1)-1)))); 
 Tpercentb = T_EFDb*100; 
 j1 = j1+1; 
end 
subplot(2,1,2) 
plot(a2, Tpercentb,'-*','color', 'r', 'linewidth', 2) 
axis([1 11 20 70]) 
grid on 
xlabel('Cut-off ratio') 
ylabel('Thermal Efficiency (%)') 
title('Thermal Efficiency Vs Cut-off Ratio'); 
hold off 
%Creating push button to save the graph 
Control2 = uicontrol('string', 'Save Plot', 'Callback', 'uiresume(figure(M))');
uiwait(figure(M))
%Saving the PV Plot 
fnameip3 = inputdlg({ 'Enter filename for Efficiency Variation'}, 'SAVE AS',[1 50]); 
str4 = string(fnameip3); 
saveas(figure(M), str4, 'jpg') 
close all 
%Stroke Vs Efficiency 
diameter = D; 
length = L_s+50; 
strokelength = linspace(1, length, 100); 
cutoffratio = a; 
sv = (pi/4)*(diameter^2/(1000*1000))*(strokelength./1000); 
CV = (pi/4)*(diameter^2/(1000*1000))*(((0.005.*strokelength)+0.5)./1000); 
volume1 = sv+cv; 
volume2 = cv;
compr = volume1./volume2; 
eta = 1-((1./(compr.^(gamma-1)))*(((cutoffratio^gamma)-1)/(gamma*(cutoffratio-1)))); 
eff = eta.*100; 
q = 1; 
figure(q) 
plot(strokelength, eff,'color', 'r', 'linewidth', 2) 
grid on 
xlabel('StrokeLength (mm)');
ylabel('Efficiency (%)'); 
title('Efficiency Vs Stroke Length') 
stra = num2str(D);
strb = '@ fixed bore diameter(mm) = '; 
strout = append(strb, stra); 
text(20,50, strout) 
%Creating push button to save the comparison 
Control9 = uicontrol('String', 'Save Plot', 'Callback', 'uiresume(figure(9))'); 
uiwait(figure(q)) 
%Saving the PV Plot 
fnameip9 = inputdlg({'Enter filename for Efficiency Variation'},'SAVE AS',[1 50]); 
str9 = string(fnameip9); 
saveas(figure(a), str9,'jpg') 
cd('C:') 
close all 
clc 
disp('Files are Saved in New Volume (C:)') 
pause(2) 
final = msgbox( 'Simulation Finished Successfully, THANKYOU', 'SUCCESS'); 
close all
clc 