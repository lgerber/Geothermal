function o = Rankine_PreCompute(o)

% updating values for Vali

dt_supheat = osmose_getTag(o,'@dt_rnk_supheat','Value');
t_evap = osmose_getTag(o,'@rnk_3_t','Value');
t_supheat = t_evap + dt_supheat;

dt_resupheat = osmose_getTag(o,'@dt_rnk_resupheat1','Value');
t_resupheat1 = t_supheat + dt_resupheat;


dt_resupheat2 = osmose_getTag(o,'@dt_rnk_resupheat2','Value');
t_resupheat2 = t_resupheat1 + dt_resupheat2;

% updating model tags
Tags = struct;
i=0;

i=i+1;
Tags(i).TagName = {'rnk_4_t'};
Tags(i).Value = t_supheat;

i=i+1;
Tags(i).TagName = {'rnk_8_t'};
Tags(i).Value = t_resupheat1;

i=i+1;
Tags(i).TagName = {'rnk_12_t'};
Tags(i).Value = t_resupheat2;

o = update_model_tags(o,Tags);