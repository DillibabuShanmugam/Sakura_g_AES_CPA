delete(instrfind);
clear all;clc;

%Initilization
%---------- No.of.Encryption -----------------------------------------
samples = 7000;
%--------- Palintext --------------------------------------------------
aes_pt = uint8(ceil(256.*rand(samples,16))-1); %10000 plaintext each of 16 byte%
save('plaintext_7000.mat', 'aes_pt');
load plaintext_7000.mat;
%---------- Key ------------------------------------------------------
k1=uint8([1 1 0 43 126]);
k2=uint8([1 1 2 21 22]);
k3=uint8([1 1 4 40 174]);
k4=uint8([1 1 6 210 166]);
k5=uint8([1 1 8 171 247]);
k6=uint8([1 1 10 21 136]);
k7=uint8([1 1 12 9 207]);
k8=uint8([1 1 14 79 60]);

key_exp=uint8([1 0 2 0 2]);
key_valid=uint8([0 0 2]);
%--------------------- Reset FPGA--------------------------------------
resetL=uint8([1 0 2 0 4]);
reset=uint8([1 0 2 0 0]);
%-----------------Plaintext Enable-------------------------------------
pt_enable=uint8([1 0 2 0 1]);
data_valid=uint8([0 0 2]);
%--------------- Cipher text read address-----------------------------
%-----------cipher bytes read addresses-------------------------------
c1=uint8([0 1 128]);
c2=uint8([0 1 130]);
c3=uint8([0 1 132]);
c4=uint8([0 1 134]);
c5=uint8([0 1 136]);
c6=uint8([0 1 138]);
c7=uint8([0 1 140]);
c8=uint8([0 1 142]);
%---------- Enc or Dec command----------------------------------------
ENC=uint8([1 0 12 0 0]);
%--------- Objection creation for Com port and Oscilloscope-----------
s = serial('COM4', 'BaudRate',  115200);
%s1 = osci_lc725_lan;
%set(s1, 'InputBufferSize', 500000);
%load_config(s1,'config_20211003_v7.txt');%  config_20171011
interfaceObj = instrfind('Type', 'tcpip', 'RemoteHost', '130.215.16.115', 'RemotePort', 1861, 'Tag', '');
% Create the TCPIP object if it does not exist
% otherwise use the object that was found.
if isempty(interfaceObj)
    interfaceObj = tcpip('130.215.16.115', 1861);
else
    fclose(interfaceObj);
    interfaceObj = interfaceObj(1);
end
set(interfaceObj,'InputBufferSize',30000);
% Create a device object. 
deviceObj = icdevice('lecroy_8600a.mdd', interfaceObj);
% Connect device object to hardware.
connect(deviceObj);
% Disconnect device object from hardware.
%disconnect(deviceObj);
% Configure property value(s).
set(interfaceObj, 'Name', 'TCPIP-130.215.16.115');
% Disconnect device object from hardware.
%disconnect(deviceObj);
set(interfaceObj, 'RemoteHost', '130.215.16.115');
%--------- Set trace box properties ----------------------------------
tb = trace_box('CPAAES_20211006_v2',pwd,100);% DPAAES_20180525_v1
%set_trace_prop(tb, 250E6, 3.125E-3, 245E-3);
%set_trace_prop(tb, 250E6, 3.125E-3, 245E-3);
%set_trace_prop(tb, 500E6, 10E-3, 20E-3);%| Sampling Rate:500 MS/s,Volts per point: 0.01000 V,Offset in Volt:  0.02000 V 
set_trace_prop(tb, 250E6, 3.125E-6, 0);%| Sampling Rate:1 GS/s,Volts per point: 0.1000 V,Offset in Volt:  0.02000 V  
%-------------- Open Com port ---------------------------------------
fopen(s);
   
for j = 1:samples
%arm(deviceObj);
  %fprintf(deviceObj ,':SINGLE');

    % ask osci for the type of data acquisition - as soon as the osci is 
    % armed it will answer to this query (due to sequential command 
    % execution)! Any other command can also be used.
  %  fprintf(deviceObj, ':ACQUIRE:TYPE?');
  %  return_string = fscanf(deviceObj);

%pause (.001);
%----------------write reset bytes into ftdi com port------------------
fwrite(s , resetL, 'uint8');
fwrite(s , reset, 'uint8');
%----------------write key bytes into ftdi com port------------------
fwrite(s , k1, 'uint8'); 
fwrite(s , k2, 'uint8'); 
fwrite(s , k3, 'uint8'); 
fwrite(s , k4, 'uint8'); 
fwrite(s , k5, 'uint8'); 
fwrite(s , k6, 'uint8'); 
fwrite(s , k7, 'uint8'); 
fwrite(s , k8, 'uint8'); 
%---------------- Key exp-------------------------------------------
%-------------key_exp=uint8([1 0 2 0 2]);-----
fwrite(s , key_exp, 'uint8'); 
%----------key_valid=uint8([0 0 2]);----------
fwrite(s , key_valid, 'uint8'); 
key_valid_r = fread(s, 2, 'uint8');
%------- Enc or Dec ------------------------------
fwrite(s , ENC, 'uint8');   
%------- plaintext write -------------------------
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

fwrite(s , pt_enable, 'uint8');
fwrite(s , data_valid, 'uint8'); 
data_valid_r = fread(s, 2, 'uint8');
%pause (.001);
%trace = read(s1, 'C1')';    
%add_traces(tb, trace);     
%Iteration = j
 groupObj = get(deviceObj, 'Waveform');
 groupObj = groupObj(1);
 trace  = invoke(groupObj, 'readwaveform', 'channel1');
 add_traces(tb, trace); 
 Iteration = j
fwrite(s , c1, 'uint8'); c1_r = fread(s, 2, 'uint8');
fwrite(s , c2, 'uint8'); c2_r = fread(s, 2, 'uint8');
fwrite(s , c3, 'uint8'); c3_r = fread(s, 2, 'uint8');
fwrite(s , c4, 'uint8'); c4_r = fread(s, 2, 'uint8');
fwrite(s , c5, 'uint8'); c5_r = fread(s, 2, 'uint8');
fwrite(s , c6, 'uint8'); c6_r = fread(s, 2, 'uint8');
fwrite(s , c7, 'uint8'); c7_r = fread(s, 2, 'uint8');
fwrite(s , c8, 'uint8'); c8_r = fread(s, 2, 'uint8');

ciphertext(j,:)= [c1_r(1) c1_r(2) c2_r(1) c2_r(2) c3_r(1) c3_r(2) c4_r(1) c4_r(2) c5_r(1) c5_r(2) c6_r(1) c6_r(2) c7_r(1) c7_r(2) c8_r(1) c8_r(2)];

end
flush(tb)
save('ciphertext_7000.mat', 'ciphertext');
delete(s);
delete(instrfind);




