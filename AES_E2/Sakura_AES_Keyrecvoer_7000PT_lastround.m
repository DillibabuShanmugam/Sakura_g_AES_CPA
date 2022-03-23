clear all;clc;load('ciphertext_7000.mat');

cout = uint8(ciphertext); 

c = repmat (cout(1:7000, 12), 1, 256);

b = repmat (cout(1:7000, 16), 1, 256);%1 element

key = repmat (uint8([0:255]), 7000, 1); 

d = bitxor(key, b); 

e = uint8(aes_sbox(d,0));  %inverse sub box

g = bitxor(c, e);

h1 = byte_hamming_weight (uint8(g)); 

 dpa_obj = dpa_calc('REG_sakura','REG implemented in sakura board','corr'); % creating dpa object dpa_obj
 tb = trace_box('CPAAES_20211006_v1', pwd); % creating trace box object tb
 
 for i=1:700
     
     traces = get_traces(tb, (((i-1)*10)+1):(i*10),14501:16000); %153001:154000 % get 10 traces at a time from trace box and store it in traces
     quick_add(dpa_obj, traces, h1((((i-1)*10)+1):(i*10),:));
     i
  end
dpa_result = result(dpa_obj);



