%function f_CLASP_plot_MOSAiC(days)
%f_CLASP_plot_MOSAiC - plot CLASP on day
%   f_CLASP_plot_MOSAiC(day) - plot CLASP on days
%   call function from RUN_CLASP.m
%     
%
%   MF Trumpington, 1.04.2021

%% Parameters
% path from HERE to input
%pth_in = '../../data/';
%pth_PS_AWS = '../../../../0_ship_met_data/data/';
%pth_SPC = '../../../SPC/data/';      % path from HERE to data
clear all
close all
clc


pth_in = '/Users/ananth/Desktop/bas_github_scripts/bas_github_scripts/SP_PDF_gamma_FreyACP2019/gamma_blowsea2/CLASP_2/data/'
pth_PS_AWS = '/Users/ananth/Desktop/bas_scripts/DATA_SETS/mosaic/newdata_with_metcity/' % wind speed data
pth_SPC = '/Users/ananth/Desktop/bas_scripts/DATA_SETS/mosaic/newdata_with_metcity/'  % spc data and wind data in the file
pth_SPC = '/Users/ananth/Desktop/bas_github_scripts/bas_github_scripts/SP_PDF_gamma_FreyACP2019/data_2/'

% Load CLASP data
fname = sprintf('%sclasp_all_1min.mat',pth_in);
if(exist(fname,'file') == 0)
    sprintf('ERROR: unable to find %s',fname)
    return
else
    load(fname);
end

spc_file = sprintf('%sU1104_8cm_1min.mat',pth_SPC);

% Load PS_AWS data
%PS_AWS_file = sprintf('%sPS_AWS_2020-05-24.mat',pth_PS_AWS);
%MET = load(PS_AWS_file);
MET = load(spc_file)

% Load SPC data
%U1104_file = sprintf('%sSPC_Unit1104_8cm_1min.mat',pth_SPC);
%U1206_file = sprintf('%sSPC_Unit1206_10m_1min.mat',pth_SPC);

U1104 = load(spc_file)
%U1104 = load(U1104_file);
%U1206 = load(U1206_file);

%% Angle between spc position and wind, pollution filter

filter = load('theta_deg.mat');

filter_time = filter.ship_time_new_2;
filter_angle = filter.theta_deg;

pollution_filter = find(filter_angle<60);

filter_time_slice = filter_time(pollution_filter);

filter_time_slice_datenum = datenum(filter_time_slice);

%openfig ./temp3.fig;
openfig /Users/ananth/Desktop/bas_github_scripts/bas_github_scripts/SP_PDF_gamma_FreyACP2019/gamma_blowsea2/CLASP_2/data/temp3.fig

h = get(gcf,'children'); % get axes handles

t1 = datenum('02-Dec-2019 23:15'); 
t2 = datenum('09-May-2020 23:26'); %

t1 = datenum('15-Mar-2020 23:15'); 
t2 = datenum('31-Mar-2020 23:26'); %

t1 = datenum('01-Dec-2019 23:15'); 
t2 = datenum('01-Jul-2020 23:26'); %

t1 = datenum('25-Jan-2020 23:15'); 
t2 = datenum('30-Jan-2020 23:26'); % this is the testing pollution one

t1 = datenum('01-Feb-2020 23:15'); 
t2 = datenum('01-Mar-2020 23:26'); %

%%convert all time arrays to zero seconds

clasp_t_1 = datetime(CLASP.t(:,1),'ConvertFrom','datenum');
met_t_1 = datetime(MET.t,'ConvertFrom','datenum');
spc_t_1 = datetime(U1104.t(:,1),'ConvertFrom','datenum');

clasp_seconds = second(clasp_t_1);
clasp_seconds_floor = floor(second(clasp_t_1));
clasp_seconds_diff = clasp_seconds - clasp_seconds_floor;

clasp_t_2 = clasp_t_1 - abs(seconds(clasp_seconds_diff));

met_seconds = second(met_t_1);
met_seconds_floor = floor(second(met_t_1));
met_seconds_diff = met_seconds - met_seconds_floor;

met_t_2 = met_t_1 - abs(seconds(met_seconds_diff));

spc_seconds = second(spc_t_1);
spc_seconds_floor = floor(second(spc_t_1));
spc_seconds_diff = spc_seconds - spc_seconds_floor;

spc_t_2 = spc_t_1 - abs(seconds(spc_seconds_diff));

% reassign values to the array
CLASP.t(:,1) = datenum(clasp_t_2);
MET.t = datenum(met_t_2);
U1104.t(:,1) = datenum(spc_t_2);

filter_logical_1 = ismember(CLASP.t(:,1), filter_time_slice_datenum);
filter_logical_2 = ismember(MET.t, filter_time_slice_datenum);
filter_logical_3 = ismember(U1104.t(:,1), filter_time_slice_datenum);

% t1 = days(1); t2 = days(end); 
% WITH pollution filter logical 
n0 = find(CLASP.t(:,1)>=t1 & CLASP.t(:,1)<=t2 & filter_logical_1);
n1 = find(MET.t>=t1 & MET.t<=t2 & filter_logical_2);
n2 = find(U1104.t(:,1)>=t1 & U1104.t(:,1)<=t2 & filter_logical_3);

%n3 = find(U1104.t(:,1)>=t1 & U1104.t(:,1)<=t2 & ismember(U1104.t(:,1), filter_time_slice_datenum));

% WITHOUT pollution filter logical 
n0 = find(CLASP.t(:,1)>=t1 & CLASP.t(:,1)<=t2);
n1 = find(MET.t>=t1 & MET.t<=t2);
n2 = find(U1104.t(:,1)>=t1 & U1104.t(:,1)<=t2);


%n3 = find(U1206.t(:,1)>=t1 & U1206.t(:,1)<=t2);

% %***********************************************************************************************
% %% PANEL A. Meteo (T29m, U39m)
% set(gcf,'CurrentAxes',h(1));
% if n1
%     h1 = plotyy(MET.t(n1),MET.U39m(n1),MET.t(n1),MET.T29m(n1));
%     set(gcf,'CurrentAxes',h1(1));
%     set(gca,'YLim',[0 25],'YTick',[0 10 20 30 40],'YTickLabel',[0 10 20 30 40 -45]);
%     ylabel('U_{39m} (m s^{-1})', ...
%         'Rotation',90, ...
%         'VerticalAlignment','bottom', ...
%         'FontSize',18,'FontName','Times');
% 
%     set(gcf,'CurrentAxes',h1(2));
%     li = get(gca,'children');
%     set(li,'LineWidth',1);
%     set(gca,'YLim',[-45 0],'YTick',[-40 -30 -20 -10 0],'YTickLabel',[-40 -30 -20 -10 0]);
%     ylabel('T_{29m} (^{\circ}C)', ...
%         'Rotation',270, ...
%         'VerticalAlignment','bottom', ...
%         'FontSize',18,'FontName','Times');
% 
%     set(h1, 'XLim',[t1 t2], ...
%         'XGrid','on', ...
%         'GridLineStyle','-');
%     datetick(h1(1),'keeplimits');
%     datetick(h1(2),'keeplimits');
%     set(h1,'XTickLabel',[]);
% end
% 
% title(['N_{0.5-20\mum} from ' datestr(t1,'dd/mm/yyyy') ' to ' datestr(t2,'dd/mm/yyyy')], ...
%     'FontName','Times','FontSize',20);

%***********************************************************************************************
%% kappa time series 
kappa_path = '/Users/ananth/Desktop/jupyter_local/jupyter_local/netcdf/kappa_1.txt'
kappa_time_path = '/Users/ananth/Desktop/jupyter_local/jupyter_local/netcdf/kappa_time_1.txt'

kappa_data = importdata(kappa_path);

% Open the file for reading
fileID = fopen(kappa_time_path, 'r');

% Read the strings from the file into a cell array
data = textscan(fileID, '%s', 'Delimiter', '\n');

% Close the file
fclose(fileID);

% Access the cell array of strings
strings = data{1};

% Display the cell array of strings
disp(strings);

datetime_obj = datetime(strings, 'InputFormat', 'yyyy-MM-dd HH:mm:ss');
disp(datetime_obj);


pth_kappa = '/Users/ananth/Downloads/'

kappa_file = sprintf('%sKappa_for_BAS.mat',pth_kappa)

kappa_arr = load(kappa_file)

kappa_val_012 = kappa_arr.Akappa_geomean018_2h;
matlab_time = kappa_arr.Atime_CCN018_2h;

%kappa_val_012 = kappa_arr.Akappa_geomean075_2h;
%matlab_time = kappa_arr.Atime_CCN075_2h;

% trying new kappa from HTDMA data
% kappa_htdma = kappa_arr.kappa150;
% kappa_val_012 = kappa_htdma;
% matlab_time = kappa_arr.TiHTDMA50;



formatted_time = datetime(datestr(matlab_time));

kappa_data = kappa_val_012;
datetime_obj = formatted_time;

% remove all data where kappa = 0
kappa_org = kappa_data;
time_org = datetime_obj;

kappa_org = kappa_val_012;
time_org = formatted_time;


new_kappa = kappa_data;
new_time  = datetime_obj; 
new_time = datenum(new_time);

n_kappa = find(new_time>=t1 & new_time<=t2);

kappa_org = kappa_org(n_kappa);
time_org = time_org(n_kappa);

new_kappa_2 = new_kappa(n_kappa);
new_time_2 = new_time(n_kappa);

t_a = datetime('15-Mar-2020 23:15'); 
t_b = datetime('31-Mar-2020 23:26');

new_time_3  = datetime_obj(kappa_data>=0);

n_kappa_3 = find(new_time_3>=t_a & new_time_3<=t_b); 

new_time_3 = new_time_3(n_kappa_3);
new_kapp_3 = new_kappa(n_kappa_3)

%% PANEL A. Total Snow Particles
set(gcf,'CurrentAxes',h(1));


%plot(U1104.t(n2,1),U1104.U10m_ex(n2),'k-'); % U10m wind speed

hold on; grid on;
% plot(U1206.t(n3,1),nansum(U1206.N(n3,:)/1e6,2),'b-'); % total snow particles [1/cm3]
set(gca,'XLim',[t1 t2],'YAxisLocation','left');
ylabel('U_{10m} (ms^{-1})', ...
    'Rotation',90, ...
    'VerticalAlignment','bottom', ...
    'FontSize',18,'FontName','Times');
datetick(gca,'keeplimits');
set(gca,'YLim',[0 6],'XTickLabel',[]);
% title(['U_{10m} from ' datestr(t1,'dd/mm/yyyy') ' to ' datestr(t2,'dd/mm/yyyy')], ...
%     'FontName','Times','FontSize',20);
ylim([0,20])

% calc threshold windspeed
%T_fine = linspace(-50,10,100);
T_pth = '/Users/ananth/Desktop/bas_scripts/DATA_SETS/mosaic/newdata_with_metcity/'
fname2 = sprintf('%stower_NOAA_1min.mat',T_pth);
DATA2 = load(fname2)

rolling_mean_width = 10; % 10min average
t_noaa = movmean(DATA2.tower_NOAA.t,rolling_mean_width);
T_noaa_skin = movmean(DATA2.tower_NOAA.skin_temp_surface,rolling_mean_width);

Ut0 = 6.975;

Ut = Ut0 + 0.0033.*(T_noaa_skin+27.27).^2;
plot(t_noaa,Ut,'r')

T_noaa_interp = interp1(t_noaa, T_noaa_skin, U1104.t(n2,1), 'nearest');
Ut_interp = Ut0 + 0.0033.*(T_noaa_interp+27.27).^2;

% Plot black line for values above threshold windspeed
idx_above_threshold = U1104.U10m_ex(n2) > Ut_interp;
plot(U1104.t(n2(idx_above_threshold),1), U1104.U10m_ex(n2(idx_above_threshold)), 'k.','MarkerSize',15);

% Plot grey line for values below threshold windspeed
idx_below_threshold = U1104.U10m_ex(n2) <= Ut_interp;
%plot(U1104.t(n2(idx_below_threshold),1), U1104.U10m_ex(n2(idx_below_threshold)),'.','Color', [0.5 0.5 0.5]);
plot(U1104.t(n2(idx_below_threshold), 1), U1104.U10m_ex(n2(idx_below_threshold)), '.', 'Color', [0.5 0.5 0.5], 'MarkerSize', 15);


yyaxis right;
plot(new_time_2, new_kappa_2,'b.','MarkerSize',12)
ylabel('Kappa', 'FontSize', 18,'Color','b')
%ylim([1.12,2])
legend('U_t','U_{10m} > U_t','U_{10m} < U_t','Location','northeast');
ax = gca; % Get the current axes handle
ax.YAxis(2).Color = 'b'; % Change the color of the right y-axis to blue

% For each pollution time
str_test ='hello before'
for idx = 1:length(filter_time_slice_datenum)
    str_test = 'hello_inside'
    % Add vertical line at each pollution time
    line([filter_time_slice_datenum(idx) filter_time_slice_datenum(idx)], get(gca, 'YLim'), 'Color', 'r', 'LineStyle', '-');
end

str_test= 'hello_outside'
%plot(t_noaa, Ut);



% legend('Snow Particles at 10cm','Location','northwest');
%% 
%% 

% %***********************************************************************************************
% %% PANEL B. total CLASP particles
%{
set(gcf,'CurrentAxes',h(2));
plot(CLASP.t(n0,:),nansum(CLASP.conc(n0,1:16),2),'b-');
hold on; grid on;

set(gca,'XLim',[t1 t2],'YAxisLocation','right');
ylabel('N_{TOT} (cm^{-3})', ...
    'Rotation',270, ...
    'VerticalAlignment','bottom', ...
    'FontSize',18,'FontName','Times');
% s = legend(li(1),'25 m','Location','NorthWest');
% set(s,'FontSize',18);
datetick(gca,'keeplimits');
set(gca,'YLim',[0 100],'XTickLabel',[]);
% datetick(gca,'keepticks','keeplimits');
%}
% Calculation of spc panel with diameter and particle number concentration
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
X = [U1104.t(n2) U1104.N(n2,:)];
dlogD = log10(U1104.dp_bins(:,2))-log10(U1104.dp_bins(:,1));
X(:,2:end) = X(:,2:end)./dlogD';
dNdlogD_2 = U1104.N(n2,:)./dlogD';

v = [0 10 100 1e3 1e4 1e5 1e6 1e7]; % color scheme; include zero counts
%vl = ['0' '10^1' '10^2' '10^3' '10^4' '10^5' '10^6' '10^7']'; % color scheme labels
%vl = ['0','10^1', '10^2', '10^3', '10^4', '10^5', '10^6', '10^7'];
%vl = string(num2str(v, '%.1e'));
vl = ["0","10^1", "10^2", "10^3", "10^4", "10^5", "10^6", "10^7"];
%vl = ['0','10^1', '10^2', '10^3', '10^4', '10^5', '10^6', '10^7'];
y = [36 50 75 100 125 150 175 200 225 250 275 300 325 350 375 400 425 450 475 500];     % y-axis ticks at meanD
yl = {'' '50' '75' '100' '' '' '' '200' '' '' '' '300' '' '' '' '' '' '' '' '500'};     % y-axis labels
set(gcf,'CurrentAxes',h(2));

[C,hc] = contourf(X(:,1),log10(U1104.dp_bins(:,3)),log10(X(:,2:end)'),log10(v));
% [C,hc] = contourf(X(:,1),U1104.dp_bins(:,3),dNdlogD_2',v);
%[C,hc] = contourf(CLASP.t(n0,1),CLASP.meanR(1,:)*2,dNdlogD',v);
%[C,hc] = contourf(X(:,1),U1104.dp_bins(:,3),X(:,2:end)',v);
%[C,hc] = contourf(X(:,1),U1104.dp_bins(:,3),X(:,2:end)',v);

set(hc,'edgecolor','none');
caxis([0 log10(v(end))]); % scale colormap of this plot
s = get(gca,'Position'); % remember axis position
cb = colorbar('EastOutside');
%cb.Ticks = vl
%cb.Ticks = v;
cb.TickLabels = vl;
set(gca,'Position',s);

% set(h(2), 'XLim',[t1 t2],'XGrid','off','GridLineStyle','-',...
%          'YLim',[y(1) y(end)],'YTick',y,'YTickLabel',yl,...
%          'YAxisLocation','left');

set(h(2), 'XLim',[t1 t2],'XGrid','off','GridLineStyle','-',...
         'YLim',log10([y(1) y(end)]),'YTick',log10(y),'YTickLabel',yl,...
         'YAxisLocation','left');
% 
% ylabel('D_p (\mu m) at 8cm',...
%      'Rotation',270, ...
%      'VerticalAlignment','bottom', ...
%     'FontSize',16,'FontName','Times');

% ht = text(gca,'FontName','Times New Roman','FontSize',16,...
%     'Rotation',270,...
%     'String','dN/dlog D_p (cm^{-3})',...
%     'Units','normalized',...
%     'Position',[1.059109232964 0.729002931267316 0]);

ylabel('D_p (\mu m)')

datetick('x','mm/dd HH','keepticks','keeplimits');
%xlabel('UTC','FontSize',16,'FontName','Times');


%***********************************************************************************************
%% PANEL B. LaserRef
% set(gcf,'CurrentAxes',h(2));
% plot(CLASP.status.t_status(:,1),CLASP.status.LaserRef(:,1),'b-');
% hold on; grid on;
% 
% set(gca,'XLim',[t1 t2],'YAxisLocation','right');
% ylabel('LaserRef (mV)', ...
%     'Rotation',270, ...
%     'VerticalAlignment','bottom', ...
%     'FontSize',18,'FontName','Times');
% datetick(gca,'keeplimits');
% set(gca,'YLim',[0 4000],'XTickLabel',[]);
% hline(CLASP.calibr(1).laser_ref + 500,'r--');
% hline(CLASP.calibr(1).laser_ref - 300,'r--');
% hline(CLASP.calibr(1).laser_ref,'r-');


%% PANEL C. CLASP contour plot
% see discussion of presentation/ properties of size distributions N(dlogDp) (Seinfeld pp.416)
set(gcf,'CurrentAxes',h(3));
% compute dN/dlogDp
dlogD = diff(log10(CLASP.calibr(1).lowerR*2));
dNdlogD = CLASP.conc(n0,1:16)./dlogD;

% do the plot
%  v = logspace(0,3,100); % colour bar space
v = linspace(0,50,100); % colour bar space
% [C,hc] = contourf(CLASP.t(n0,1),CLASP.meanR(1,:)*2,dNdlogD',log10(v));
[C,hc] = contourf(CLASP.t(n0,1),CLASP.meanR(1,:)*2,dNdlogD',v);

s = get(gca,'Position');
colorbar('EastOutside');
set(gca,'Position',s);

% Annotate colour scheme
% ht = text(gca,'FontName','Times New Roman','FontSize',16,...
%     'Rotation',270,...
%     'String','dN/dlog D_p (cm^{-3})',...
%     'Units','normalized',...
%     'Position',[1.059109232964 0.729002931267316 0]);

% ht = text(gca,'dN/dlog D_p (cm^{-3})')

set(hc,'edgecolor','none');
ylabel('D_p (\mu m)','FontSize',18,'FontName','Times');
xlabel('Time','FontSize',35,'FontName','Times');
% axes
set(gca,'YLim',[CLASP.meanR(1,1)*2 10],'YScale','log','XLim',[t1 t2], ...
    'XGrid','off','YGrid','off','GridLineStyle','-');
datetick(gca,'keepticks','keeplimits');

%***********************************************************************************************
set(h,'FontSize',16,'FontName','Times');
set(0,'defaultaxeslinewidth',2); set(0,'defaultlinelinewidth',1);


