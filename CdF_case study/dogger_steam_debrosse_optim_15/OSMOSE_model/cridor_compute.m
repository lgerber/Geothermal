function o = cridor_compute(o)

% This function calculates the heat losses after available energy from
% steam has been used for electricity production and district heating
% network supply.

Q_av = osmose_getTag(o,'@Q_av','Value');
Q_dhn = osmose_getTag(o,'@Q_dhn','Value');
E_prod = osmose_getTag(o,'@E_prod','Value');
eff_elec = osmose_getTag(o,'@eff_elec','Value');

Q_loss = Q_av - Q_dhn - E_prod/eff_elec;

Tags = struct;
i=0;

i=i+1;
Tags(i).TagName = {'Q_loss'};
Tags(i).Value = Q_loss;

o = update_model_tags(o,Tags);