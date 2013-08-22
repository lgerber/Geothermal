function o = HP1_PreModel(o)

% This function calculates the evaporation temperature of the first heat
% pump in function of the geothermal fluid temperature (either dogger or
% muschelkalk)

hot_source = osmose_getTag(o,'@demand_profiles.hot_source','Value');

if hot_source == 1
    t_hs = osmose_getTag(o,'@dogger.geo_inj_t','Value');
elseif hot_source == 2
    t_hs = osmose_getTag(o,'@muschelkalk.geo_inj_t','Value');
else
    t_hs = 15;
end


evap_dtmin = osmose_getTag(o,'@evap_dtmin','Value');

hp_evap_out_t = t_hs - evap_dtmin;

Tags = struct;
i=0;

i=i+1;
Tags(i).TagName = {'hp_evap_out_t'};
Tags(i).Value = hp_evap_out_t;

o = update_model_tags(o,Tags);