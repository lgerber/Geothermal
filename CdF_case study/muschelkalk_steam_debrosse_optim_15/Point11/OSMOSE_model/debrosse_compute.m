function o = debrosse_compute(o)

% calculate heat load during period P

period = osmose_getTag(o,'@debrosse_p','Value');
debrosse_load = 0;

if period == o.Period
    op_time = osmose_getTag(o,'@op_time','Value');
    debrosse_av = osmose_getTag(o,'@debrosse_av','Value');
    debrosse_load = debrosse_av/op_time;
end

i=0;
Tags = struct;

i=i+1;
Tags(i).TagName = {'debrosse_load'};
Tags(i).Value = debrosse_load;

o = update_model_tags(o,Tags);