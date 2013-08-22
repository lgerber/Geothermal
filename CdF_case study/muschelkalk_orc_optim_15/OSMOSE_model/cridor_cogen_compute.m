function o = cridor_cogen_compute(o)

% This function calculates the heat losses after available energy from
% steam has been used for electricity production and district heating
% network supply.

Q_av = osmose_getTag(o,'@Q_av','Value');
Q_dhn = osmose_getTag(o,'@Q_dhn','Value');
E_prod = osmose_getTag(o,'@E_prod','Value');
eff_elec = osmose_getTag(o,'@eff_elec','Value');

% this represents
Q_dhn = Q_av - E_prod/eff_elec;

% Q_loss = Q_av - Q_dhn - E_prod/eff_elec;

if o.Period == 2
    Q_dhn = 0;
end

% update wood resources factor for woor boiler

bn_debrosse = osmose_getTag(o,'@bn_debrosse','Value');

if bn_debrosse == 1
    wood_resources_factor = 1.2358;
else
    wood_resources_factor = 1;
end

Tags = struct;
i=0;

i=i+1;
Tags(i).TagName = {'Q_dhn'};
Tags(i).Value = Q_dhn;

i=i+1;
Tags(i).TagName = {'wood_resources_factor'};
Tags(i).Value = wood_resources_factor;

o = update_model_tags(o,Tags);