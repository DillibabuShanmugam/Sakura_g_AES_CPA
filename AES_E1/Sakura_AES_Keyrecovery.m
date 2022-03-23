clear all;clc;load('ciphertext.mat');

cout = uint8(ciphertext); 

c = repmat (cout(1:1000, 3), 1, 256);

b = repmat (cout(1:1000, 11), 1, 256);%1 element

key = repmat (uint8([0:255]), 1000, 1); 

d = bitxor(key, b); 

e = uint8(aes_sbox(d,0));  %inverse sub box

g = bitxor(c, e);

h1 = byte_hamming_weight (uint8(g)); 

 dpa_obj = dpa_calc('REG_sakura','REG implemented in sakura board','corr'); % creating dpa object dpa_obj
 tb = trace_box('CPAAES_20211005_v6', pwd); % creating trace box object tb
 
 for i=1:100
     
     traces = get_traces(tb, (((i-1)*10)+1):(i*10),152001:154000); %153001:154000 % get 10 traces at a time from trace box and store it in traces
     quick_add(dpa_obj, traces, h1((((i-1)*10)+1):(i*10),:));
     i
  end
dpa_result = result(dpa_obj);



