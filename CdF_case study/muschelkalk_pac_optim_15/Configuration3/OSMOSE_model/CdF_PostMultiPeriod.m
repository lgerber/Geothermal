function o = CdF_PostMultiPeriod(o)

% This function combines the indicators calculated by the single period
% function to calculate the overall yearly performance of the system.

if o.Silent == 0
    disp('Calculating thermo-economic performance for all periods...')
end

%% thermodynamic performance

p = o.Period;

dhn_heat = osmose_getTag(o,'@tot_dhn_heat','Period');
cop_hp1 = osmose_getTag(o,'@cop_hp1','Period');
cop_hp2 = osmose_getTag(o,'@cop_hp2','Period');
cop_sys = osmose_getTag(o,'@cop_sys','Period');
op_time = osmose_getTag(o,'@op_time','Period');

tot_dhn_heat = 0;
tot_op_time = 0;

for i=1:p
    tot_dhn_heat = tot_dhn_heat + dhn_heat(i).Value;
    tot_op_time = tot_op_time + op_time(i).Value;
    cop_hp1_wt(i) = cop_hp1(i).Value * op_time(i).Value;
    cop_hp2_wt(i) = cop_hp2(i).Value * op_time(i).Value;
    cop_sys_wt(i) = cop_sys(i).Value * op_time(i).Value;
end
cop_hp1_av = sum(cop_hp1_wt)/tot_op_time;
cop_hp2_av = sum(cop_hp2_wt)/tot_op_time;
cop_sys_av = sum(cop_sys_wt)/tot_op_time;

%% economic performance

conv_usd2chf = osmose_getTag(o,'@conv_usd2chf','Value');

% operating costs

ng_cost = osmose_getTag(o,'@ng_cost','Period');
wood_cost = osmose_getTag(o,'@wood_cost','Period');
geo_cost = osmose_getTag(o,'@geo_cost','Period');
hp1_cost = osmose_getTag(o,'@hp1_cost','Period');
hp2_cost = osmose_getTag(o,'@hp2_cost','Period');
elec_sell_cridor = osmose_getTag(o,'@elec_sell_cridor','Period');
crid_op_cost = osmose_getTag(o,'@crid_op_cost','Period');

tot_ng_cost = 0;
tot_wood_cost = 0;
tot_geo_cost = 0;
tot_hp1_cost = 0;
tot_hp2_cost = 0;
tot_elec_sell_cridor = 0;
tot_crid_op_cost = 0;

for i=1:p
    tot_ng_cost = tot_ng_cost + ng_cost(i).Value;
    tot_wood_cost = tot_wood_cost + wood_cost(i).Value;
    tot_geo_cost = tot_geo_cost + geo_cost(i).Value;
    tot_hp1_cost = tot_hp1_cost + hp1_cost(i).Value;
    tot_hp2_cost = tot_hp2_cost + hp2_cost(i).Value;
    tot_elec_sell_cridor = tot_elec_sell_cridor + elec_sell_cridor(i).Value;
    tot_crid_op_cost = tot_crid_op_cost + crid_op_cost(i).Value;
end

tot_c_op_tot_elec = tot_ng_cost + tot_wood_cost + tot_geo_cost + tot_hp1_cost + tot_hp2_cost + tot_crid_op_cost - tot_elec_sell_cridor;
tot_c_op_tot = tot_ng_cost + tot_wood_cost + tot_geo_cost + tot_hp1_cost + tot_hp2_cost + tot_crid_op_cost;
tot_c_op_tot_usd = tot_c_op_tot / conv_usd2chf;

% investment costs

drill_costs_usd = osmose_getMaximalValueforTag(o,'@drill_costs_usd');
cost_pump_da_usd = osmose_getMaximalValueforTag(o,'@cost_pump_da_usd');
pipe_dhn_cost_chf = osmose_getMaximalValueforTag(o,'@pipe_dhn_cost');
hp1_cinv_usd = osmose_getMaximalValueforTag(o,'@hp1_cinv_usd');
hp2_cinv_usd = osmose_getMaximalValueforTag(o,'@hp2_cinv_usd');

drill_costs_chf = drill_costs_usd * conv_usd2chf;
cost_pump_da_chf = cost_pump_da_usd * conv_usd2chf;
pipe_dhn_cost_usd = pipe_dhn_cost_chf / conv_usd2chf;
hp1_cinv_chf = hp1_cinv_usd * conv_usd2chf;
hp2_cinv_chf = hp2_cinv_usd * conv_usd2chf;

cinv_tot_usd = drill_costs_usd + cost_pump_da_usd + pipe_dhn_cost_usd + hp1_cinv_usd + hp2_cinv_usd;
cinv_tot_chf = cinv_tot_usd * conv_usd2chf;

c.LifeTime = osmose_getTag(o,'@lifetime','Value');
c.InterestRate = osmose_getTag(o,'@ir','Value');

cinv_an_usd = cost_annualize(c, cinv_tot_usd);
cinv_an_chf = cost_annualize(c, cinv_tot_chf);

% total costs

c_tot_usd = cinv_an_usd + tot_c_op_tot_usd;
c_tot_chf = cinv_an_chf + tot_c_op_tot;
c_tot_chf_elec = cinv_an_chf + tot_c_op_tot_elec;

% levelized cost of district heating

dh_level_cost = c_tot_chf/tot_dhn_heat;

% income from service selling and net profit

dh_sell_price = osmose_getTag(o,'@dh_sell_price','Value');
tot_dh_income = dh_sell_price * tot_dhn_heat;

profit = tot_dh_income - tot_c_op_tot;
net_profit = tot_dh_income - c_tot_chf;

profit_elec = tot_dh_income - tot_c_op_tot_elec;
net_profit_elec = tot_dh_income - c_tot_chf_elec;

if o.Silent == 0
    disp(['Natural Gas Cost: ',num2str(tot_ng_cost),'CHF/yr'])
    disp(['Wood Cost: ',num2str(tot_wood_cost),'CHF/yr'])
    disp(['Geothermal Cost: ',num2str(tot_geo_cost),'CHF/yr'])
    disp(['Heat Pump Cost: ',num2str(tot_hp1_cost+tot_hp2_cost),'CHF/yr'])
    disp(['Total Operating Costs: ',num2str(tot_c_op_tot),'CHF/yr'])
    disp('')
    disp(['Drilling costs: ',num2str(drill_costs_chf),'CHF'])
    disp(['Geothermal pump costs: ',num2str(cost_pump_da_chf),'CHF'])
    disp(['Heat pump costs: ',num2str(hp1_cinv_chf + hp2_cinv_chf),'CHF'])
    disp(['Total investment costs: ',num2str(cinv_tot_chf),'CHF'])
    disp('')
    disp(['Total annual costs: ',num2str(c_tot_chf),'CHF/yr'])
    disp('')
    disp(['COP heat pump: ',num2str(cop_sys_av),''])
    disp('')
    disp(['Levelized cost of district heating: ',num2str(dh_level_cost),'CHF/kWh'])
    disp('')
    disp(['Total DH income: ',num2str(tot_dh_income),'CHF/yr'])
    disp('')
    disp(['Total electricity selling: ',num2str(tot_elec_sell_cridor),'CHF/kWh'])
    disp('')
    disp(['Net annual profit: ',num2str(net_profit),'CHF/yr'])
end

%% update model tags
Tags = struct;
i=0;

i=i+1;
Tags(i).DisplayName = {'Total heat supplied to consumer'};
Tags(i).TagName = {'tot_dhn_heat'};
Tags(i).Value = tot_dhn_heat;
Tags(i).Units = {'kWh'};

i=i+1;
Tags(i).DisplayName = {'COP of heat pump 1'};
Tags(i).TagName = {'cop_hp1'};
Tags(i).Value = cop_hp1_av;
Tags(i).Units = {''};

i=i+1;
Tags(i).DisplayName = {'COP of heat pump 2'};
Tags(i).TagName = {'cop_hp2'};
Tags(i).Value = cop_hp2_av;
Tags(i).Units = {''};

i=i+1;
Tags(i).DisplayName = {'COP of heat pump system'};
Tags(i).TagName = {'cop_sys'};
Tags(i).Value = cop_sys_av;
Tags(i).Units = {''};

i=i+1;
Tags(i).DisplayName = {'Cost of Natural Gas'};
Tags(i).TagName = {'ng_cost'};
Tags(i).Value = tot_ng_cost;
Tags(i).Units = {'CHF'};

i=i+1;
Tags(i).DisplayName = {'Cost of Wood'};
Tags(i).TagName = {'wood_cost'};
Tags(i).Value = tot_wood_cost;
Tags(i).Units = {'CHF'};

i=i+1;
Tags(i).DisplayName = {'Cost of Geothermal exploitation'};
Tags(i).TagName = {'geo_cost'};
Tags(i).Value = tot_geo_cost;
Tags(i).Units = {'CHF'};

i=i+1;
Tags(i).DisplayName = {'Cost op. of Heat pump 1'};
Tags(i).TagName = {'hp1_cost'};
Tags(i).Value = tot_hp1_cost;
Tags(i).Units = {'CHF'};

i=i+1;
Tags(i).DisplayName = {'Cost op. of Heat pump 2'};
Tags(i).TagName = {'hp2_cost'};
Tags(i).Value = tot_hp2_cost;
Tags(i).Units = {'CHF'};

i=i+1;
Tags(i).DisplayName = {'Cost op. of Cridor'};
Tags(i).TagName = {'crid_op_cost'};
Tags(i).Value = tot_crid_op_cost;
Tags(i).Units = {'CHF'};

i=i+1;
Tags(i).DisplayName = {'Electricity sellings from Cridor'};
Tags(i).TagName = {'elec_sell_cridor'};
Tags(i).Value = tot_elec_sell_cridor;
Tags(i).Units = {'CHF'};

i=i+1;
Tags(i).DisplayName = {'Total operating cost CHF'};
Tags(i).TagName = {'c_op_tot'};
Tags(i).Value = tot_c_op_tot;
Tags(i).Units = {'CHF'};

i=i+1;
Tags(i).DisplayName = {'Total operating cost CHF, including electricity'};
Tags(i).TagName = {'c_op_tot_elec'};
Tags(i).Value = tot_c_op_tot_elec;
Tags(i).Units = {'CHF'};

i=i+1;
Tags(i).DisplayName = {'Total operating cost USD'};
Tags(i).TagName = {'c_op_tot_usd'};
Tags(i).Value = tot_c_op_tot_usd;
Tags(i).Units = {'USD'};

i=i+1;
Tags(i).DisplayName = {'Drilling costs USD'};
Tags(i).TagName = {'drill_costs_usd'};
Tags(i).Value = drill_costs_usd;
Tags(i).Units = {'USD'};

i=i+1;
Tags(i).DisplayName = {'Geothermal pump cost USD'};
Tags(i).TagName = {'cost_pump_da_usd'};
Tags(i).Value = cost_pump_da_usd;
Tags(i).Units = {'USD'};

i=i+1;
Tags(i).DisplayName = {'HP1 investment cost USD'};
Tags(i).TagName = {'hp1_cinv_usd'};
Tags(i).Value = hp1_cinv_usd;
Tags(i).Units = {'USD'};

i=i+1;
Tags(i).DisplayName = {'HP2 investment cost USD'};
Tags(i).TagName = {'hp2_cinv_usd'};
Tags(i).Value = hp2_cinv_usd;
Tags(i).Units = {'USD'};

i=i+1;
Tags(i).DisplayName = {'Pipe for DHN connection cost CHF'};
Tags(i).TagName = {'pipe_dhn_cost'};
Tags(i).Value = pipe_dhn_cost_chf;
Tags(i).Units = {'CHF'};

Tags(i).DisplayName = {'Drilling costs CHF'};
Tags(i).TagName = {'drill_costs_chf'};
Tags(i).Value = drill_costs_chf;
Tags(i).Units = {'CHF'};

i=i+1;
Tags(i).DisplayName = {'Geothermal pump cost CHF'};
Tags(i).TagName = {'cost_pump_da_chf'};
Tags(i).Value = cost_pump_da_chf;
Tags(i).Units = {'CHF'};

i=i+1;
Tags(i).DisplayName = {'HP1 investment cost CHF'};
Tags(i).TagName = {'hp1_cinv_chf'};
Tags(i).Value = hp1_cinv_chf;
Tags(i).Units = {'CHF'};

i=i+1;
Tags(i).DisplayName = {'HP2 investment cost CHF'};
Tags(i).TagName = {'hp2_cinv_chf'};
Tags(i).Value = hp2_cinv_chf;
Tags(i).Units = {'CHF'};

i=i+1;
Tags(i).DisplayName = {'Total investment costs USD'};
Tags(i).TagName = {'cinv_tot_usd'};
Tags(i).Value = cinv_tot_usd;
Tags(i).Units = {'USD'};

i=i+1;
Tags(i).DisplayName = {'Total investment costs CHF'};
Tags(i).TagName = {'cinv_tot_chf'};
Tags(i).Value = cinv_tot_chf;
Tags(i).Units = {'CHF'};

i=i+1;
Tags(i).DisplayName = {'Annualized investment costs USD'};
Tags(i).TagName = {'cinv_an_usd'};
Tags(i).Value = cinv_an_usd;
Tags(i).Units = {'USD'};

i=i+1;
Tags(i).DisplayName = {'Annualized investment costs CHF'};
Tags(i).TagName = {'cinv_an_chf'};
Tags(i).Value = cinv_an_chf;
Tags(i).Units = {'CHF'};

i=i+1;
Tags(i).DisplayName = {'Total annual costs USD'};
Tags(i).TagName = {'c_tot_usd'};
Tags(i).Value = c_tot_usd;
Tags(i).Units = {'USD'};

i=i+1;
Tags(i).DisplayName = {'Total annual costs CHF'};
Tags(i).TagName = {'c_tot_chf'};
Tags(i).Value = c_tot_chf;
Tags(i).Units = {'CHF'};

i=i+1;
Tags(i).DisplayName = {'DH levelized cost CHF'};
Tags(i).TagName = {'dh_level_cost'};
Tags(i).Value = dh_level_cost;
Tags(i).Units = {'CHF/kWh'};

i=i+1;
Tags(i).DisplayName = {'Annual income from district heating selling'};
Tags(i).TagName = {'dh_income'};
Tags(i).Value = tot_dh_income;
Tags(i).Units = {'CHF'};

i=i+1;
Tags(i).DisplayName = {'Annual profit of the system (without Cinv)'};
Tags(i).TagName = {'profit'};
Tags(i).Value = profit;
Tags(i).Units = {'CHF'};

i=i+1;
Tags(i).DisplayName = {'Annual net profit of the system'};
Tags(i).TagName = {'net_profit'};
Tags(i).Value = net_profit;
Tags(i).Units = {'CHF'};

i=i+1;
Tags(i).DisplayName = {'Annual profit of the system (without Cinv), including electricity'};
Tags(i).TagName = {'profit_elec'};
Tags(i).Value = profit_elec;
Tags(i).Units = {'CHF'};

i=i+1;
Tags(i).DisplayName = {'Annual net profit of the system, including electricity'};
Tags(i).TagName = {'net_profit_elec'};
Tags(i).Value = net_profit_elec;
Tags(i).Units = {'CHF'};

o = update_model_tags(o,Tags);