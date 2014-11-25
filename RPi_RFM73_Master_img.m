clear
close all
%txData=['AA' 'AA' 'AA' 'AA' 'AA' 'AA' 'AA' 'AA' 'AA' 'AA' 'AA' 'AA' 'AA' 'AA' 'AA' 'AA' 'AA' 'AA' 'AA' 'AA' 'AA' 'AA' 'AA' 'AA'];
%txData=[5 28 41];
W_TX_PAYLOAD='A0';
W_TX_PAYLOAD_NO_ACK='B0';
STATUS='07';
CONFIG='00';
RPi_RFM73_initial_connection;
[status]=RFM73_init(mypi, RFM73);
tic

if(status==14)
    fprintf('RFM73 transceiver connected and correctly initialized: status is ');
else
    fprintf('RFM73 transceiver returned the unusual status ');
end 
fprintf([dec2bin(status,8) '\n']);
[imgArrayData, successRate] = RFM73_transmitImage(mypi, RFM73, 'car.jpg', 'jpg', 32 );
toc
image(imgArrayData)
colormap gray
axis image
[status]=RFM73_shutdown(mypi,RFM73);
% IRQ=1;
% transmitTime=0;
% configureDigitalPin(mypi,24,'input');
% while((IRQ==1)&&(transmitTime<1))
%     fprintf('RFM73 in TX mode\n');
%     IRQ=readDigitalPin(mypi,24);
%     pause(0.01);
%     transmitTime=transmitTime+0.01;
% end
% if(IRQ==0)
%     fprintf('IRQ set!\n');
% else
%     fprintf('Timeout, not good!\n');
% end
% [status]=RFM73_readRegister(RFM73,STATUS,1);
% status_bin=dec2bin(status,8);
% if(status_bin(3)=='1') %TX_DS bit set: good!
%     fprintf('TX_DS bit set: packet sent and acknowledged\n');
% end
% if(status_bin(4)=='1') %MAX_RT bit set: bad!
%     fprintf('MAX_RT bit set: packet retransmitted the maximum number of allowed times without receiving an ACK\n');
% end
% writeDigitalPin(mypi,17,0)% Deactivate chip by resetting the PAEN pin
% [config, status]=RFM73_readRegister(RFM73,CONFIG,1);
% configBinaryValue=dec2bin(config,8);
% configBinaryValue(7)='0'; %Value of the PWR_UP bit set to 0
% config=bin2dec(configBinaryValue);
% status=RFM73_writeRegister( RFM73, CONFIG, dec2hex(config,2));
% [status]=RFM73_writeRegister(RFM73,STATUS,dec2hex(status,2)); %Reset the TX_DS or MAX_RT bit
% [status]=RFM73_readRegister(RFM73,STATUS,1);
% status_bin=dec2bin(status,8);
% if((status_bin(3)=='0')&& (status_bin(4)=='0'))
%     fprintf('RFM73 TX IRQ bits reset completed\n');
% else
%     fprintf('RFM73 TX IRQ bits reset failed\n');
% end
% IRQ=readDigitalPin(mypi,24);
% if (IRQ==1)
%     fprintf('RFM73 IRQ pin reset: ok!\n');
% else
%     fprintf('RFM73 IRQ pin still set: error!\n');
% end
%outcome=RFM73_checkTxOutcome(mypi,RFM73)
%txData