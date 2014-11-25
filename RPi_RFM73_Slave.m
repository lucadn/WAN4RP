clear
close all
txData=[234 234 234 234 234 234];
W_TX_PAYLOAD='A0';
STATUS='07';
CONFIG='00';
RPi_RFM73_initial_connection;
[status]=RFM73_init(mypi, RFM73);
if(status==14)
    fprintf('RFM73 transceiver connected and correctly initialized: status is ');
else
    fprintf('RFM73 transceiver returned the unusual status ');
end
fprintf([dec2bin(status,8) '\n']);

[status] = RFM73_switch_to_RX(mypi,RFM73);
configureDigitalPin(mypi,24,'input')
receivingTime=0;
IRQ=1;
while(IRQ==1 && receivingTime<10)
    fprintf('RFM73 in RX mode, waiting for packets\n');
    IRQ=readDigitalPin(mypi,24);
    pause(0.1);
    receivingTime=receivingTime+0.01;
end
if (IRQ==0)
    fprintf('IRQ set!\n');
    [status]=RFM73_readRegister(RFM73,STATUS,1);
    status_bin=dec2bin(status,8);
    if(status_bin(2)=='1') %RX_DR bit set: good!
        fprintf('RX_DR bit set: packet received and acknowledged\n');
        [rxDataDec, status]= RFM73_receivePacket(RFM73);
        status
        writeDigitalPin(mypi,17,0)% Deactivate chip by resetting the PAEN pin
        [config, status]=RFM73_readRegister(RFM73,CONFIG,1);
        configBinaryValue=dec2bin(config,8);
        configBinaryValue(7)='0'; %Value of the PWR_UP bit set to 0
        config=bin2dec(configBinaryValue);
        status=RFM73_writeRegister( RFM73, CONFIG, dec2hex(config,2));
        [status]=RFM73_writeRegister(RFM73,STATUS,dec2hex(status,2)); %Reset the RX_DR bit
        [status]=RFM73_readRegister(RFM73,STATUS,1);
        status_bin=dec2bin(status,8);
        rxDataDec
    else
        fprintf('RX_DR bit not set: Error, no other IRQ bit should be set in RX mode\n');
    end
else
    fprintf('Timer expired, no packets received\n');
end

[status]=RFM73_readRegister(RFM73,STATUS,1);
status_bin=dec2bin(status,8);
if((status_bin(2)=='0')) %RX_DR bit not set: good!
    fprintf('RFM73 RX_DR IRQ bits reset completed\n');
end
IRQ=readDigitalPin(mypi,24);
if (IRQ==1)
    fprintf('RFM73 IRQ pin reset: ok!\n');
else
    fprintf('RFM73 IRQ pin still set: error!\n');
end