delete(instrfind);
clear all;clc;
%No.of.Encryption
samples = 100;

s = serial('COM4', 'BaudRate',  115200);

osci = osci_lc725_lan;

fopen(s);
%write key bytes into ftdi com port
k1=uint8([1 1 0 43 126]);
k2=uint8([1 1 2 21 22]);
k3=uint8([1 1 4 40 174]);
k4=uint8([1 1 6 210 166]);
k5=uint8([1 1 8 171 247]);
k6=uint8([1 1 10 21 136]);
k7=uint8([1 1 12 9 207]);
k8=uint8([1 1 14 79 60]);
fwrite(s , k1, 'uint8'); 
fwrite(s , k2, 'uint8'); 
fwrite(s , k3, 'uint8'); 
fwrite(s , k4, 'uint8'); 
fwrite(s , k5, 'uint8'); 
fwrite(s , k6, 'uint8'); 
fwrite(s , k7, 'uint8'); 
fwrite(s , k8, 'uint8'); 
% Key exp
key_exp=uint8([1 0 2 0 2]);
fwrite(s , key_exp, 'uint8'); 
key_valid=uint8([0 0 2]);
fwrite(s , key_valid, 'uint8'); 
key_valid_r = fread(s, 2, 'uint8');
% Enc or Dec
ENC=uint8([1 0 12 0 0]);
fwrite(s , ENC, 'uint8');   
    
aes_pt = uint8(ceil(256.*rand(samples,16))-1); %10000 plaintext each of 16 byte%
save('plaintext.mat', 'aes_pt');

%cipher bytes read address
c1=uint8([0 1 128]);
c2=uint8([0 1 130]);
c3=uint8([0 1 132]);
c4=uint8([0 1 134]);
c5=uint8([0 1 136]);
c6=uint8([0 1 138]);
c7=uint8([0 1 140]);
c8=uint8([0 1 142]);

for j = 1:samples
  
resetL=uint8([1 0 2 0 4]);
fwrite(s , resetL, 'uint8');
reset=uint8([1 0 2 0 0]);
fwrite(s , reset, 'uint8');

p1=uint8([1 1 64 aes_pt(j,1:2)]);
p2=uint8([1 1 64 aes_pt(j,3:4)]);
p3=uint8([1 1 64 aes_pt(j,5:6)]);
p4=uint8([1 1 64 aes_pt(j,7:8)]);
p5=uint8([1 1 64 aes_pt(j,9:10)]);
p6=uint8([1 1 64 aes_pt(j,11:12)]);
p7=uint8([1 1 64 aes_pt(j,13:14)]);
p8=uint8([1 1 64 aes_pt(j,15:16)]);

fwrite(s , p1, 'uint8'); 
fwrite(s , p2, 'uint8'); 
fwrite(s , p3, 'uint8'); 
fwrite(s , p4, 'uint8'); 
fwrite(s , p5, 'uint8'); 
fwrite(s , p6, 'uint8'); 
fwrite(s , p7, 'uint8'); 
fwrite(s , p8, 'uint8'); 

pt_enable=uint8([1 0 2 0 1]);
data_valid=uint8([0 0 2]);
fwrite(s , pt_enable, 'uint8');
fwrite(s , data_valid, 'uint8'); 
data_valid_r = fread(s, 2, 'uint8');

fwrite(s , c1, 'uint8'); c1_r = fread(s, 2, 'uint8');
fwrite(s , c2, 'uint8'); c2_r = fread(s, 2, 'uint8');
fwrite(s , c3, 'uint8'); c3_r = fread(s, 2, 'uint8');
fwrite(s , c4, 'uint8'); c4_r = fread(s, 2, 'uint8');
fwrite(s , c5, 'uint8'); c5_r = fread(s, 2, 'uint8');
fwrite(s , c6, 'uint8'); c6_r = fread(s, 2, 'uint8');
fwrite(s , c7, 'uint8'); c7_r = fread(s, 2, 'uint8');
fwrite(s , c8, 'uint8'); c8_r = fread(s, 2, 'uint8');

ciphertext(j,:)= [c1_r(1) c1_r(2) c2_r(1) c2_r(2) c3_r(1) c3_r(2) c4_r(1) c4_r(2) c5_r(1) c5_r(2) c6_r(1) c6_r(2) c7_r(1) c7_r(2) c8_r(1) c8_r(2)];
Iteration = j
end
%flush(tb)
%delete(serial);
%delete(instrfind);
 %A_c = reshape(read_cipher, [1, 16]);
 %convString = dec2hex(A_c)
  %convString = reshape(dec2hex(A),[1, 32])
  fclose(s);
 

  
 %samples = 100;
%osci = osci_mso6052a_lan;
%osci = osci_mso7104b_lan;
%save_config(osci, 'config_demo_file_20180911_v1.txt');
%load_config(osci, 'config_demofile13.txt');
%serial = rs232('COM1', 19200);
%tb = trace_box('AESprecharge_20210120A', pwd, 100);
%set_trace_prop(tb, 250E6, 3.125E-3, 245E-3); 
%aes_pt = uint8(ceil(256.*rand(samples,16))-1); %10000 plaintext each of 16 byte%
% save('plaintext.mat', 'aes_pt');
%load plaintext.mat;
%for i=1:samples
    %arm(osci); 
   % write(serial, uint8(1));
   % pause (.2);
    %write(serial, uint8(aes_pt(i,:)));  
   % pause (1);
    %trace = read(osci, 'C1')';    
    %add_traces(tb, trace);     
    %i 
   % pause (.5);
%end
%flush(tb)
%delete(serial);

 



