clear all;clc;load('ciphertext_5000.mat');

cout = uint8(ciphertext); 

c = repmat (cout(1:5000, 5), 1, 256);

b = repmat (cout(1:5000, 5), 1, 256);%1 element

key = repmat (uint8([0:255]), 5000, 1); 

d = bitxor(key, b); 

e = uint8(aes_sbox(d,0));  %inverse sub box

g = bitxor(c, e);

h1 = byte_hamming_weight (uint8(g)); 

 dpa_obj = dpa_calc('REG_Simulation','REG implemented in simulation','corr'); % creating dpa object dpa_obj
 tb = trace_box('opentitan_v2', pwd); % creating trace box object tb TRACE_BOX_Open_titan_aes_simulation
 
 for i=1:500
     
     traces = get_traces(tb, (((i-1)*10)+1):(i*10),1:50); %153001:154000 % get 10 traces at a time from trace box and store it in traces
     quick_add(dpa_obj, traces, h1((((i-1)*10)+1):(i*10),:));
     i
  end
dpa_result = result(dpa_obj)