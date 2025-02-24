% RUN_CLASP
%   RUN_CLASP loops through selected days and calls f_*.m
%   Check all parameters are set correctly in f_*.m
%
%   MF Trumpington, 31.03.2021

clear; close('all');

days = [datenum('27-Aug-2019 0:00:00'):datenum('15-Sep-2020 0:00:00')]';

pth_in = '/Users/ananth/Desktop/clasp_data/'
pth_SPC = '/Users/ananth/Desktop/bas_scripts/DATA_SETS/mosaic/newdata_with_metcity/'

% Load CLASP data
fname = sprintf('%sclasp_all_1min.mat',pth_in);
if(exist(fname,'file') == 0)
    sprintf('ERROR: unable to find %s',fname)
    return
else
    CLASP = load(fname); 
end


U1104_file = sprintf('%sU1104_8cm_1min.mat',pth_SPC);
U1206_file = sprintf('%sU1206_10m_1min.mat',pth_SPC);

U1104 = load(U1104_file);
U1206 = load(U1206_file);


%%
openfig ./temp3.fig;
h = get(gcf,'children'); % get axes handles
t1 = days(1); t2 = days(end);
n0 = find(CLASP.CLASP.t(:,1)>=t1 & CLASP.CLASP.t(:,1)<=t2);
%n1 = find(MET.t>=t1 & MET.t<=t2);
n2 = find(U1104.t(:,1)>=t1 & U1104.t(:,1)<=t2);
n3 = find(U1206.t(:,1)>=t1 & U1206.t(:,1)<=t2);

%% PANEL A. Total Snow Particles
figure(1)
plot(U1104.t(n2,1),nansum(U1104.N(n2,:)/1e6,2),'r-'); % total snow particles [1/cm3]
hold on; grid on;
%set(gca,'XLim',[t1 t2],'YAxisLocation','left');
ylabel('N_{TOT 50-500 \mu m} (cm^{-3})', ...
    'Rotation',90, ...
    'VerticalAlignment','bottom', ...
    'FontSize',18,'FontName','Times');
%datetick(gca,'keeplimits');
%set(gca,'YLim',[0 6],'XTickLabel',[]);
title(['N_{0.5-20\mum} from ' datestr(t1,'dd/mm/yyyy') ' to ' datestr(t2,'dd/mm/yyyy')], ...
    'FontName','Times','FontSize',20);

% %% PANEL B. total CLASP particles
figure(2)
% %% PANEL B. total CLASP particles
%set(gcf,'CurrentAxes',h(2));

plot(CLASP.CLASP.t(n0,:),nansum(CLASP.CLASP.conc(n0,1:16),2),'b-');
hold on; grid on;

%set(gca,'XLim',[t1 t2],'YAxisLocation','right');
ylabel('N_{TOT} (cm^{-3})', ...
    'Rotation',270, ...
    'VerticalAlignment','bottom', ...
    'FontSize',18,'FontName','Times');
% s = legend(li(1),'25 m','Location','NorthWest');
% set(s,'FontSize',18);
%datetick(gca,'keeplimits');
%set(gca,'YLim',[0 100],'XTickLabel',[]);
% datetick(gca,'keepticks','keeplimits');


%set(gcf,'CurrentAxes',h(3));
% compute dN/dlogDp
dlogD = diff(log10(CLASP.CLASP.calibr(1).lowerR*2));
dNdlogD = CLASP.CLASP.conc(n0,1:16)./dlogD;

% do the plot
%  v = logspace(0,3,100); % colour bar space
v = linspace(0,50,100); % colour bar space
% [C,hc] = contourf(CLASP.t(n0,1),CLASP.meanR(1,:)*2,dNdlogD',log10(v));
[C,hc] = contourf(CLASP.CLASP.t(n0,1),CLASP.CLASP.meanR(1,:)*2,dNdlogD',v);

%s = get(gca,'Position');
colorbar('EastOutside');
%set(gca,'Position',s);

% annotate colour scheme
ht = text(gca,'FontName','Times New Roman','FontSize',16,...
    'Rotation',270,...
    'String','dN/dlog D_p (cm^{-3})',...
    'Units','normalized',...
    'Position',[1.059109232964 0.729002931267316 0]);

%set(hc,'edgecolor','none');
ylabel('D_p (\mu m)','FontSize',18,'FontName','Times');
xlabel('UTC','FontSize',18,'FontName','Times');
% axes
%set(gca,'YLim',[CLASP.meanR(1,1)*2 10],'YScale','log','XLim',[t1 t2], ...
%    'XGrid','off','YGrid','off','GridLineStyle','-');
%datetick(gca,'keepticks','keeplimits');




% legend('Snow Particles at 10cm','Location','northwest');


% Define a sample structure


% Load the MATLAB file containing the
% structure
%load('myStruct.mat');

%{
excel_filename = 'clasp_data.xlsx';
%wb = openxlsx(excel_filename);
wb = openxlsx(excel_filename);
for field = fieldnames(x)'
    sheetname = field{1};
    data = x.(sheetname);
    writecell(data, wb, sheetname, 'A1');
end

savexlsx(wb)

x = CLASP.CLASP
excel_filename = 'clasp_data.xlsx';
for field = fieldnames(x)'
    sheetname = field{1};
    data = x.(sheetname);
    writetable(data, excel_filename, 'Sheet', sheetname);
end
%}

%{

% Define the output Excel file name
filename = 'clasp_output.xlsx';


% Write each variable to a different sheet
xlswrite(filename, CLASP.CLASP.t, 'Sheet1');
xlswrite(filename, CLASP.CLASP.conc, 'Sheet2');
xlswrite(filename, CLASP.CLASP., 'Sheet3');

for i = 1:2

    %f_CLASP_proc_MOSAiC(days(i));     % 1) Process (& plot) raw data   
    
    %     f_CLASP_average_MOSAiC(days(i));    % 2) Average processed data

end

% block comment the plot of total snow particles

%% PANEL A. Total Snow Particles
set(gcf,'CurrentAxes',h(1));

plot(U1104.t(n2,1),nansum(U1104.N(n2,:)/1e6,2),'r-'); % total snow particles [1/cm3]
hold on; grid on;
% plot(U1206.t(n3,1),nansum(U1206.N(n3,:)/1e6,2),'b-'); % total snow particles [1/cm3]
set(gca,'XLim',[t1 t2],'YAxisLocation','left');
ylabel('N_{TOT 50-500 \mu m} (cm^{-3})', ...
    'Rotation',90, ...
    'VerticalAlignment','bottom', ...
    'FontSize',18,'FontName','Times');
datetick(gca,'keeplimits');
set(gca,'YLim',[0 6],'XTickLabel',[]);
title(['N_{0.5-20\mum} from ' datestr(t1,'dd/mm/yyyy') ' to ' datestr(t2,'dd/mm/yyyy')], ...
    'FontName','Times','FontSize',20);
% legend('Snow Particles at 10cm','Location','northwest');

%}