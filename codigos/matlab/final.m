%% RS232 Conection
clear; close all; clc;

port = "COM4";
baudrate = 115200;
fpga = serialport(port,baudrate,"Parity","none","Timeout", 30);
flush(fpga);
filename = "final" + ".txt";
file = fopen(filename, "w");

n_lecturas = 64;
data = zeros(n_lecturas,2);

for i = 1:n_lecturas
    data(i,:) = read(fpga,2,"uint8");
    volt = (data(i,1)*256 + data(i,2))*(3.3/4095);
    fprintf(file,'%3u %3u %8.6f\n', data(i,:), volt);
end


fclose(file);

clear fpga;

% Default Configurations
    % "Parity","none" 
    % "DataBits",8
    % "StopBits",1
    % "FlowControl","none"
    % "ByteOrder","little-endian"
    % "Timeout", 10