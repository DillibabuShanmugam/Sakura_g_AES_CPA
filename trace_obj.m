
tb = trace_box('opentitan_v3',pwd,100);% DPAAES_20180525_v1
set_trace_prop(tb, 250E6, 3.125E-3, 245E-3);

t = traces(1:100,1:50);
add_traces(tb, t);