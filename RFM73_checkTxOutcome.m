function [outcome] = RFM73_checkTxOutcome(rpidevID, spidevID)
%RFM73_checkTxOutcome - This function checks the outcome of last
%transmission by waiting for IRQ to be set.
%   Detailed explanation goes here
STATUS='07';
CONFIG='00';
IRQ=1;
transmitTime=0;
configureDigitalPin(rpidevID,24,'input');
outcome=-1;
while((IRQ==1)&&(transmitTime<1))
    %fprintf('RFM73 in TX mode\n');
    IRQ=readDigitalPin(rpidevID,24);
    pause(0.001);
    transmitTime=transmitTime+0.001;
end
% if(IRQ==0)
%     fprintf('IRQ set!\n');
% else
%     fprintf('Timeout, not good!\n');
% end
[status]=RFM73_readRegister(spidevID,STATUS,1);
status_bin=dec2bin(status,8);
if(status_bin(3)=='1') %TX_DS bit set: good!
    outcome=0;
%     fprintf('TX_DS bit set: packet sent and acknowledged\n');
    [status]=RFM73_writeRegister(spidevID,STATUS,dec2hex(status,2)); %Reset the TX_DS or MAX_RT bit
end
if(status_bin(4)=='1') %MAX_RT bit set: bad!
    outcome=-1;
%     fprintf('MAX_RT bit set: packet retransmitted the maximum number of allowed times without receiving an ACK\n');
    writeDigitalPin(rpidevID,17,0)% Deactivate chip by resetting the PAEN pin
    [config, status]=RFM73_readRegister(spidevID,CONFIG,1);
    configBinaryValue=dec2bin(config,8);
    configBinaryValue(7)='0'; %Value of the PWR_UP bit set to 0
    config=bin2dec(configBinaryValue);
    status=RFM73_writeRegister( spidevID, CONFIG, dec2hex(config,2));
    [status]=RFM73_writeRegister(spidevID,STATUS,dec2hex(status,2)); %Reset the TX_DS or MAX_RT bit
    [status]=RFM73_readRegister(spidevID,STATUS,1);
    status_bin=dec2bin(status,8);
    configBinaryValue(7)='1'; %Value of the PWR_UP bit set back to 1
    config=bin2dec(configBinaryValue);
    status=RFM73_writeRegister( spidevID, CONFIG, dec2hex(config,2));
    writeDigitalPin(rpidevID,17,1)% Reactivate chip by resetting the PAEN pin
%     if((status_bin(3)=='0')&& (status_bin(4)=='0'))
%         fprintf('RFM73 TX IRQ bits reset completed\n');
%     else
%         fprintf('RFM73 TX IRQ bits reset failed\n');
%     end
end
IRQ=readDigitalPin(rpidevID,24);
% if (IRQ==1)
%     fprintf('RFM73 IRQ pin reset: ok!\n');
% else
%     fprintf('RFM73 IRQ pin still set: error!\n');
% end

end

