function o = CdF_PostMultiPeriod_cogen_wood(o)

% This function combines the indicators calculated by the single period
% function to calculate the overall yearly performance of the system.

if o.Silent == 0
    disp('Calculating thermo-economic performance for all periods...')
end

%% thermodynamic performance

p = o.Period;

dhn_heat = osmose_getTag(o,'@tot_dhn_heat','Period');
op_time = osmose_getTag(o,'@op_time','Period');

tot_dhn_heat = 0;
tot_op_time = 0;

for i=1:p
    tot_dhn_heat = tot_dhn_heat + dhn_heat(i).Value;
    tot_op_time = tot_op_time + op_time(i).Value;
end

%% economic performance

conv_usd2chf = osmose_getTag(o,'@conv_usd2chf','Value');

% operating costs

ng_cost = osmose_getTag(o,'@ng_cost','Period');
wood_cost = osmose_getTag(o,'@wood_cost','Period');
wood_deb_cost = osmose_getTag(o,'@wood_deb_cost','Period');
geo_cost = osmose_getTag(o,'@geo_cost','Period');
elec_sell_cridor = osmose_getTag(o,'@elec_sell_cridor','Period');
crid_op_cost = osmose_getTag(o,'@crid_op_cost','Period');
elec_sell_steam = osmose_getTag(o,'@elec_sell_steam','Period');

tot_ng_cost = 0;
tot_wood_cost = 0;
tot_wood_deb_cost = 0;
tot_geo_cost = 0;
tot_elec_sell_cridor = 0;
tot_crid_op_cost = 0;
tot_elec_sell_steam = 0;

for i=1:p
    tot_ng_cost = tot_ng_cost + ng_cost(i).Value;
    tot_wood_cost = tot_wood_cost + wood_cost(i).Value;
    tot_wood_deb_cost = tot_wood_deb_cost + wood_deb_cost(i).Value;
    tot_geo_cost = tot_geo_cost + geo_cost(i).Value;
    tot_elec_sell_cridor = tot_elec_sell_cridor + elec_sell_cridor(i).Value;
    tot_crid_op_cost = tot_crid_op_cost + crid_op_cost(i).Value;
    tot_elec_sell_steam = tot_elec_sell_steam + elec_sell_steam(i).Value;
end

% operators salary

salary = osmose_getTag(o,'@salary','Value');
n_operators = osmose_getTag(o,'@n_operators','Value');

op_sal = salary * n_operators;

tot_c_op_tot_elec = tot_ng_cost + tot_wood_cost + tot_geo_cost + tot_crid_op_cost - tot_elec_sell_cridor - tot_elec_sell_steam + op_sal;
tot_c_op_tot = tot_ng_cost + tot_wood_cost + tot_geo_cost + tot_crid_op_cost + op_sal;
tot_c_op_tot_usd = tot_c_op_tot / conv_usd2chf;

% investment costs

drill_costs_usd = osmose_getMaximalValueforTag(o,'@drill_costs_usd');
cost_pump_da_usd = osmose_getMaximalValueforTag(o,'@cost_pump_da_usd');
pipe_dhn_cost_chf = osmose_getMaximalValueforTag(o,'@pipe_dhn_cost');

drill_costs_chf = drill_costs_usd * conv_usd2chf;
cost_pump_da_chf = cost_pump_da_usd * conv_usd2chf;
pipe_dhn_cost_usd = pipe_dhn_cost_chf / conv_usd2chf;

turb1_costs_usd = osmose_getMaximalValueforTag(o,'@turb1_costs_usd');
pump1_costs_usd = osmose_getMaximalValueforTag(o,'@pump1_costs_usd');
turb2_costs_usd = osmose_getMaximalValueforTag(o,'@turb2_costs_usd');
pump2_costs_usd = osmose_getMaximalValueforTag(o,'@pump2_costs_usd');
turb3_costs_usd = osmose_getMaximalValueforTag(o,'@turb3_costs_usd');
pump3_costs_usd = osmose_getMaximalValueforTag(o,'@pump3_costs_usd');

turb1_costs_chf = turb1_costs_usd * conv_usd2chf;
pump1_costs_chf = pump1_costs_usd * conv_usd2chf;
turb2_costs_chf = turb2_costs_usd * conv_usd2chf;
pump2_costs_chf = pump2_costs_usd * conv_usd2chf;
turb3_costs_chf = turb3_costs_usd * conv_usd2chf;
pump3_costs_chf = pump3_costs_usd * conv_usd2chf;

wood_deb_boil_costs_usd = osmose_getMaximalValueforTag(o,'@wood_deb_boil_costs_usd');
wood_deb_boil_costs_chf = wood_deb_boil_costs_usd* conv_usd2chf;

% estimating the investement costs of the heat exchange network of
% geothermal system

hex_ref(1) = 3.7878e+003;%USD
hex_ref(2) = 4.2495e+003;%USD
hex_ref(3) = 6.2115e+003;%USD
hex_ref(4) = 9.9069e+003;%USD
hex_ref(5) = 1.2509e+004;%USD
hex_ref(6) = 2.1375e+004;%USD

hex_act = osmose_getTag(o,'@EI:DefaultHeatCascade_HENCost_Bath','Period');

delta_c = zeros(o.Period);
for i = 1:o.Period
    delta_c(i) = hex_act(i).Value - hex_ref(i);
end

hex_costs_usd = max(delta_c(:,1));
hex_costs_chf = hex_costs_usd * conv_usd2chf;

cinv_tot_usd = drill_costs_usd + cost_pump_da_usd + pipe_dhn_cost_usd + ...
    turb1_costs_usd + turb2_costs_usd + turb3_costs_usd + pump1_costs_usd + ...
    pump2_costs_usd + pump3_costs_usd + wood_deb_boil_costs_usd + hex_costs_usd;
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
    disp(['Wood Debrosse Cost: ',num2str(tot_wood_deb_cost),'CHF/yr'])
    disp(['Geothermal Cost: ',num2str(tot_geo_cost),'CHF/yr'])
    disp(['Total Operating Costs: ',num2str(tot_c_op_tot),'CHF/yr'])
    disp('')
    disp(['Drilling costs: ',num2str(drill_costs_chf),'CHF'])
    disp(['Geothermal pump costs: ',num2str(cost_pump_da_chf),'CHF'])
    disp(['Total investment costs: ',num2str(cinv_tot_chf),'CHF'])
    disp('')
    disp(['Total annual costs: ',num2str(c_tot_chf),'CHF/yr'])
    disp('')
    disp(['Levelized cost of district heating: ',num2str(dh_level_cost),'CHF/kWh'])
    disp('')
    disp(['Total DH income: ',num2str(tot_dh_income),'CHF/yr'])
    disp('')
    disp(['Total electricity selling Steam cycle: ',num2str(tot_elec_sell_steam),'CHF'])
    disp('')
    disp(['Total electricity selling Cridor: ',num2str(tot_elec_sell_cridor),'CHF'])
    disp('')
    disp(['Annual profit: ',num2str(net_profit),'CHF/yr'])
    disp('')
    disp(['Net annual profit, with electricity: ',num2str(net_profit_elec),'CHF/yr'])
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
Tags(i).DisplayName = {'Cost of Wood'};
Tags(i).TagName = {'wood_deb_cost'};
Tags(i).Value = tot_wood_deb_cost;
Tags(i).Units = {'CHF'};

i=i+1;
Tags(i).DisplayName = {'Cost of Geothermal exploitation'};
Tags(i).TagName = {'geo_cost'};
Tags(i).Value = tot_geo_cost;
Tags(i).Units = {'CHF'};

i=i+1;
Tags(i).DisplayName = {'Cost op. of Cridor'};
Tags(i).TagName = {'crid_op_cost'};
Tags(i).Value = tot_crid_op_cost;
Tags(i).Units = {'CHF'};

i=i+1;
Tags(i).DisplayName = {'Electricity sellings from Steam cycle'};
Tags(i).TagName = {'elec_sell_steam'};
Tags(i).Value = tot_elec_sell_steam;
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
Tags(i).DisplayName = {'Turbine Steam cost USD'};
Tags(i).TagName = {'turb1_costs_usd'};
Tags(i).Value = turb1_costs_usd;
Tags(i).Units = {'USD'};

i=i+1;
Tags(i).DisplayName = {'Turbine Steam cost CHF'};
Tags(i).TagName = {'turb1_costs_chf'};
Tags(i).Value = turb1_costs_chf;
Tags(i).Units = {'CHF'};

i=i+1;
Tags(i).DisplayName = {'Pump Water cost USD'};
Tags(i).TagName = {'pump1_costs_usd'};
Tags(i).Value = pump1_costs_usd;
Tags(i).Units = {'USD'};

i=i+1;
Tags(i).DisplayName = {'Pump Water cost CHF'};
Tags(i).TagName = {'pump1_costs_chf'};
Tags(i).Value = pump1_costs_chf;
Tags(i).Units = {'CHF'};

i=i+1;
Tags(i).DisplayName = {'Turbine Steam cost USD'};
Tags(i).TagName = {'turb2_costs_usd'};
Tags(i).Value = turb2_costs_usd;
Tags(i).Units = {'USD'};

i=i+1;
Tags(i).DisplayName = {'Turbine Steam cost CHF'};
Tags(i).TagName = {'turb2_costs_chf'};
Tags(i).Value = turb2_costs_chf;
Tags(i).Units = {'CHF'};

i=i+1;
Tags(i).DisplayName = {'Pump Water cost USD'};
Tags(i).TagName = {'pump2_costs_usd'};
Tags(i).Value = pump2_costs_usd;
Tags(i).Units = {'USD'};

i=i+1;
Tags(i).DisplayName = {'Pump Water cost CHF'};
Tags(i).TagName = {'pump2_costs_chf'};
Tags(i).Value = pump2_costs_chf;
Tags(i).Units = {'CHF'};

i=i+1;
Tags(i).DisplayName = {'Turbine Steam cost USD'};
Tags(i).TagName = {'turb3_costs_usd'};
Tags(i).Value = turb3_costs_usd;
Tags(i).Units = {'USD'};

i=i+1;
Tags(i).DisplayName = {'Turbine Steam cost CHF'};
Tags(i).TagName = {'turb3_costs_chf'};
Tags(i).Value = turb3_costs_chf;
Tags(i).Units = {'CHF'};

i=i+1;
Tags(i).DisplayName = {'Pump Water cost USD'};
Tags(i).TagName = {'pump3_costs_usd'};
Tags(i).Value = pump3_costs_usd;
Tags(i).Units = {'USD'};

i=i+1;
Tags(i).DisplayName = {'Pump Water cost CHF'};
Tags(i).TagName = {'pump3_costs_chf'};
Tags(i).Value = pump3_costs_chf;
Tags(i).Units = {'CHF'};

i=i+1;
Tags(i).DisplayName = {'Costs of Wood boiler, debrosse, USD'};
Tags(i).TagName = {'wood_deb_boil_costs_usd'};
Tags(i).Value = wood_deb_boil_costs_usd;
Tags(i).Units = {'USD'};

i=i+1;
Tags(i).DisplayName = {'Costs of Wood boiler, debrosse, CHF'};
Tags(i).TagName = {'wood_deb_boil_costs_chf'};
Tags(i).Value = wood_deb_boil_costs_chf;
Tags(i).Units = {'CHF'};

i=i+1;
Tags(i).DisplayName = {'HEX ORC cost USD'};
Tags(i).TagName = {'hex_costs_usd'};
Tags(i).Value = hex_costs_usd;
Tags(i).Units = {'USD'};

i=i+1;
Tags(i).DisplayName = {'HEX ORC cost CHF'};
Tags(i).TagName = {'hex_costs_chf'};
Tags(i).Value = hex_costs_chf;
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