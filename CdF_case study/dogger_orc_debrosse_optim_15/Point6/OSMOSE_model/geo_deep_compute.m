function o = geo_deep_compute(o)

%% get the values of the tags as matlab variables 
technology=o.Model(o.ModelID);
s = ET_generateVariablesFromTags(technology.Tags); 
eval([s]); 

%% computation

% calculate mass flow rate from volume flow rate and geofluid density

geo_massf_ref = geo_volumef_ref * geo_rho/1000;

% calculate pumping power required

pump_dp = pump_hp-pump_lp;
pump_power = geo_massf_ref*pump_dp*100/geo_rho/pump_eff; %P(kW)= flow(kg/s)*dp(kPa)/rho(kg/m3) for water, P(kW)= flow(kg/s)*dp(bar)*100/rho(kg/m3)

% calculate missing parameters linked with depth, temperature and gradient

if geo_t == 0
    geo_t = z0_t + geo_z*geo_grad;
elseif geo_z == 0
    geo_z = (geo_t - z0_t)/geo_grad;
elseif geo_grad == 0
    geo_grad = (geo_t - z0_t)/geo_z;
end

% calculate the total heat load and the temperatures from the geothermal water

if geo_load == 0
    geo_load_calc = geo_massf_ref*geo_cp*(geo_t-geo_inj_t);
else
    geo_load_calc = geo_load;
end

% calculate the operating costs

op_costs = pump_power*3600*op_time*elec_price;

% calculate the investment costs associated with the geothermal resource
% exploitation (drilling costs for a given number of boreholes and deepness, including all equipments)
% source: PDGN, Evaluation du potentiel géothermique du canton de Neuchâtel
% Rapport final, Août 2010, Tableau 6.1 page 213 

h = [0 500 1000 1500 2000 2500]; % m
ci = [0 1.2 2.5 3.7 6.4 9.2]*1e6; % CHF
ind = max(find(geo_z>h));
if ind >= length(h)
    error('Depth of the aquifer is out of the validity domain for costs estimation (max depth allowed: 2500 m)');
end
inv_costs = ((ci(ind+1)-ci(ind))/(h(ind+1)-h(ind))*(geo_z-h(ind))+ci(ind))*1.5/success;

%% savings the results in model tags 

nt=0; 
ntags=length(technology.Tags); 
for i=1:ntags 
	varname = lower(char(technology.Tags(i).TagName)); 
	% trying to recover the variable. Sometimes (if the tagname is not 
	% compatible with matlab variables names), this desn't work. 
	try 
       nt=nt+1; 
       Tags(nt).TagName = technology.Tags(i).TagName; 
       eval(sprintf('Tags(nt).Value=%s ;',varname)); 
	end 
end 
o=update_model_tags(o,Tags); 
