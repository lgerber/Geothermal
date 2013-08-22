function o = HP2_PreModel(o)

% This function calculates the evaporation temperature of the second heat
% pump in function of the first heat pump condensation temperature

t_hs = osmose_getTag(o,'@heat_pump1.hp_cond_out_t','Value');
evap_dtmin = osmose_getTag(o,'@evap_dtmin','Value');

hp_evap_out_t = t_hs - evap_dtmin;

Tags = struct;
i=0;

i=i+1;
Tags(i).TagName = {'hp_evap_out_t'};
Tags(i).Value = hp_evap_out_t;

o = update_model_tags(o,Tags);