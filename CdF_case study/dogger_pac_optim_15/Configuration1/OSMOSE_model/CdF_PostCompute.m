function o = CdF_PostCompute(o)

% This function calculates the thermo-economic performance of the system 
% for the current period

if o.Silent == 0
    disp(['Calculating thermo-economic performance for period ',num2str(o.Period),'...'])
end

% multiplying factors for utilities

hot_source = osmose_getTag(o,'@hot_source','Value');

if hot_source == 1
    geo_mult = osmose_getTag(o,'@dogger.geo_deep_mult');
elseif hot_source == 2
    geo_mult = osmose_getTag(o,'@muschelkalk.geo_deep_mult');
else
    geo_mult = 0;
end

hp1_mult = osmose_getTag(o,'@heat_pump1.heat_pump_mult','Value');
hp2_mult = osmose_getTag(o,'@heat_pump2.heat_pump_mult','Value');
cridor_mult = osmose_getTag(o,'@cridor.heat_cridor_mult','Value');
wood_mult = osmose_getTag(o,'@wood_boiler.wood_boiler_mult','Value');
gn_boil_mult = osmose_getTag(o,'@gas_boiler.gas_boiler_mult','Value');

if isfield(geo_mult,'Value')
    geo_mult = geo_mult.Value;
else
    geo_mult = 0;
end
if isempty(hp1_mult)
    hp1_mult = 0;
end
if isempty(hp2_mult)
    hp2_mult = 0;
end

%% thermodynamic performance

% heat transfered to district heating
loss = osmose_getTag(o,'@losses','Value');
dhn_heat = osmose_getTag(o,'@dhn_load','Value');
op_time = osmose_getTag(o,'@op_time','Value');
tot_dhn_heat = op_time * dhn_heat * (1-loss); % kWh

% COP of heat pump system

hp1_elec = osmose_getTag(o,'@heat_pump1.hp_w_power','Value');
hp2_elec = osmose_getTag(o,'@heat_pump2.hp_w_power','Value');
if isempty(hp1_elec)
    hp1_elec = 0;
end
if isempty(hp2_elec)
    hp2_elec = 0;
end

hp1_elec = hp1_elec * hp1_mult;
hp2_elec = hp2_elec * hp2_mult;

hp1_heat_cond = osmose_getTag(o,'@heat_pump1.q_cond_load','Value');
hp1_heat_desuph = osmose_getTag(o,'@heat_pump1.q_desuph_load','Value');
hp1_heat_del = (hp1_heat_cond + hp1_heat_desuph) * hp1_mult;

hp2_heat_cond = osmose_getTag(o,'@heat_pump2.q_cond_load','Value');
hp2_heat_desuph = osmose_getTag(o,'@heat_pump2.q_desuph_load','Value');
hp2_heat_del = (hp2_heat_cond + hp2_heat_desuph) * hp2_mult;

cop_hp1 = hp1_heat_del / hp1_elec;
cop_hp2 = hp2_heat_del / hp2_elec;
cop_sys = hp2_heat_del / (hp1_elec + hp2_elec);

%% economic performance

%operating costs

ng_price = osmose_getTag(o,'@gas_boiler.ng_price','Value');
ng_eff = osmose_getTag(o,'@gas_boiler.en_eff','Value');
ng_heat = osmose_getTag(o,'@gas_boiler.power','Value');
ng_heat = ng_heat * gn_boil_mult * op_time; % kWh
ng_amount = ng_heat/ng_eff; % kWh
ng_cost = ng_amount * ng_price/100; % CHF

wood_price = osmose_getTag(o,'@wood_boiler.wood_price','Value');
wood_eff = osmose_getTag(o,'@wood_boiler.en_eff','Value');
wood_heat = osmose_getTag(o,'@wood_boiler.heat_load','Value');
wood_heat = wood_heat * wood_mult * op_time; % kWh
wood_amount = wood_heat/wood_eff; % kWh
wood_cost = wood_amount * wood_price/100; % CHF

var_elec_price = osmose_getTag(o,'@var_elec_price','Value');

if var_elec_price == 1
    dh_sell_price = osmose_getTag(o,'@dh_sell_price','Value');
    elec_price_ratio = osmose_getTag(o,'@elec_price_ratio','Value');
    elec_price = elec_price_ratio * dh_sell_price;
else
    elec_price = osmose_getTag(o,'@elec_price','Value');
end

if hot_source == 1
    geo_power = osmose_getTag(o,'@dogger.pump_power','Value');    
elseif hot_source == 2
    geo_power = osmose_getTag(o,'@muschelkalk.pump_power','Value');
else
    geo_power = 0;
end

geo_power = geo_power * op_time * geo_mult; % kWh
geo_cost = geo_power * elec_price/100; % CHF

hp1_elec = hp1_elec * op_time; % kWh
hp2_elec = hp2_elec * op_time; % kWh
hp1_cost = hp1_elec * elec_price/100; % CHF
hp2_cost = hp2_elec * elec_price/100; % CHF

crid_heat = osmose_getTag(o,'@cridor.Q_dhn','Value');
crid_op_cost = osmose_getTag(o,'@cridor.op_cost','Value');
crid_op_cost = crid_op_cost * cridor_mult * crid_heat * op_time;

E_prod_crid = osmose_getTag(o,'@cridor.E_prod','Value');
elec_price_cridor = osmose_getTag(o,'@elec_price_cridor','Value');

% satisfying first internal needs in electricity for cridor
if E_prod_crid * cridor_mult < 1000
    elec_sell_cridor = 0;
else
    elec_sell_cridor = (E_prod_crid * cridor_mult - 1000) * elec_price_cridor/100 * op_time;
end

c_op_tot = ng_cost + wood_cost + geo_cost + hp1_elec + hp2_elec + crid_op_cost - elec_sell_cridor;

if o.Silent == 0
    disp(['Natural Gas Cost: ',num2str(ng_cost),'CHF'])
    disp(['Wood Cost: ',num2str(wood_cost),'CHF'])
    disp(['Geothermal Cost: ',num2str(geo_cost),'CHF'])
    disp(['Heat Pump Cost: ',num2str(hp1_cost+hp2_cost),'CHF'])
    disp(['Electricity selling: ',num2str(elec_sell_cridor),'CHF'])
    disp(['COP Heat pump system: ',num2str(cop_sys),''])
end

% investement costs

c = cost_defaults;
c.LifeTime = osmose_getTag(o,'@lifetime','Value');
c.InterestRate = osmose_getTag(o,'@ir','Value');
conv_usd2chf = osmose_getTag(o,'@conv_usd2chf','Value');

if geo_mult == 0
    drill_costs_usd = 0;
    cost_pump_da_usd = 0;
    pipe_dhn_cost = 0;
else
    if hot_source == 1
        drill_costs_chf = osmose_getTag(o,'@dogger.inv_costs','Value');
        pump_da_power = osmose_getTag(o,'@dogger.pump_power','Value');
        p_pump_da = osmose_getTag(o,'@dogger.pump_hp','Value');
    elseif hot_source == 2
        drill_costs_chf = osmose_getTag(o,'@muschelkalk.inv_costs','Value');
        pump_da_power = osmose_getTag(o,'@muschelkalk.pump_power','Value');
        p_pump_da = osmose_getTag(o,'@muschelkalk.pump_hp','Value');
    else
       drill_costs_chf = 0;
       pump_da_power = 0;
       p_pump_da = 0;
    end
    drill_costs_usd = drill_costs_chf/conv_usd2chf;
    pump_da_power = pump_da_power * geo_mult;
    n_units_pumps = ceil(pump_da_power/250);
    pump_da_unit_power = pump_da_power/n_units_pumps;
    cost_unit_pump = cost_CentrifugalPumps(c, pump_da_unit_power, p_pump_da);
    cost_pump_da_usd = cost_unit_pump.GR * n_units_pumps;
    pipe_dhn_cost = 1500000; % CHF, estimated price for the pipe to connect geothermal well to DHN
end

if hp1_mult == 0
    hp1_cinv_usd = 0;
else
    hp1_heat_del = osmose_getTag(o,'@heat_pump1.q_cond_load','Value');
    hp1_heat_del = hp1_heat_del * hp1_mult;
    hp1_cinv_usd = Cost_Heat_pump_medium_size(c,hp1_heat_del);
    hp1_cinv_usd = hp1_cinv_usd.GR;
end

if hp2_mult == 0
    hp2_cinv_usd = 0;
else
    hp2_heat_del = osmose_getTag(o,'@heat_pump2.q_cond_load','Value');
    hp2_heat_del = hp2_heat_del * hp2_mult;
    hp2_cinv_usd = Cost_Heat_pump_medium_size(c,hp2_heat_del);
    hp2_cinv_usd = hp2_cinv_usd.GR;
end

% income from service selling and net profit

dh_sell_price = osmose_getTag(o,'@dh_sell_price','Value');
dh_income = dh_sell_price * tot_dhn_heat;

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
Tags(i).Value = cop_hp1;
Tags(i).Units = {''};

i=i+1;
Tags(i).DisplayName = {'COP of heat pump 2'};
Tags(i).TagName = {'cop_hp2'};
Tags(i).Value = cop_hp2;
Tags(i).Units = {''};

i=i+1;
Tags(i).DisplayName = {'COP of heat pump system'};
Tags(i).TagName = {'cop_sys'};
Tags(i).Value = cop_sys;
Tags(i).Units = {''};

i=i+1;
Tags(i).DisplayName = {'Cost of Natural Gas'};
Tags(i).TagName = {'ng_cost'};
Tags(i).Value = ng_cost;
Tags(i).Units = {'CHF'};

i=i+1;
Tags(i).DisplayName = {'Cost of Wood'};
Tags(i).TagName = {'wood_cost'};
Tags(i).Value = wood_cost;
Tags(i).Units = {'CHF'};

i=i+1;
Tags(i).DisplayName = {'Cost of Geothermal exploitation'};
Tags(i).TagName = {'geo_cost'};
Tags(i).Value = geo_cost;
Tags(i).Units = {'CHF'};

i=i+1;
Tags(i).DisplayName = {'Cost of Heat pump 1'};
Tags(i).TagName = {'hp1_cost'};
Tags(i).Value = hp1_cost;
Tags(i).Units = {'CHF'};

i=i+1;
Tags(i).DisplayName = {'Cost of Heat pump 2'};
Tags(i).TagName = {'hp2_cost'};
Tags(i).Value = hp2_cost;
Tags(i).Units = {'CHF'};

i=i+1;
Tags(i).DisplayName = {'Cost of Cridor'};
Tags(i).TagName = {'crid_op_cost'};
Tags(i).Value = crid_op_cost;
Tags(i).Units = {'CHF'};

i=i+1;
Tags(i).DisplayName = {'Electricity sellings from Cridor'};
Tags(i).TagName = {'elec_sell_cridor'};
Tags(i).Value = elec_sell_cridor;
Tags(i).Units = {'CHF'};

i=i+1;
Tags(i).DisplayName = {'Total operating cost'};
Tags(i).TagName = {'c_op_tot'};
Tags(i).Value = c_op_tot;
Tags(i).Units = {'CHF'};

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
Tags(i).Value = pipe_dhn_cost;
Tags(i).Units = {'CHF'};

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
Tags(i).DisplayName = {'Income from district heating selling'};
Tags(i).TagName = {'dh_income'};
Tags(i).Value = dh_income;
Tags(i).Units = {'CHF'};

o = update_model_tags(o,Tags);

%% update functional unit for LCA
lifetime = osmose_getTag(o,'@lifetime','Value');
o.LCIA.FunctionalUnit.Value = tot_dhn_heat*lifetime;
