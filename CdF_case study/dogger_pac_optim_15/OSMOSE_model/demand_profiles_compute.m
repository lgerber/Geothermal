function o = demand_profiles_compute(o)

% This function calculate the heat demand of the district heating network
% of the city of La-Chaux-de-Fonds from the composite curves of the
% residential area studied by Mégel (2011).

% recover the data from the composite curves and calculate real heat demand
% for the overall DHN

mult_fact = osmose_getTag(o,'@mult_fact','Value');

dh_load1 = osmose_getTag(o,'@dh_load1','Value');
dh_load1 = dh_load1 * mult_fact;
dh_load2 = osmose_getTag(o,'@dh_load2','Value');
dh_load2 = dh_load2 * mult_fact;
dh_load3 = osmose_getTag(o,'@dh_load3','Value');
dh_load3 = dh_load3 * mult_fact;

dh_load_tot = dh_load1 + dh_load2 + dh_load3; % total heat load to be supplied from the district heating network
losses = osmose_getTag(o,'@losses','Value');
dhn_load = dh_load_tot/(1-losses); % total heat load to supply to the district heating network

% update model tags

Tags = struct;
i=0;

i=i+1;
Tags(i).TagName = {'dh_load1'};
Tags(i).Value = dh_load1;

i=i+1;
Tags(i).TagName = {'dh_load2'};
Tags(i).Value = dh_load2;

i=i+1;
Tags(i).TagName = {'dh_load3'};
Tags(i).Value = dh_load3;

i=i+1;
Tags(i).TagName = {'dhn_load'};
Tags(i).Value = dhn_load;

o = update_model_tags(o,Tags);