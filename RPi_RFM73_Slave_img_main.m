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
[rxImageArray] = RFM73_receiveImage(mypi, RFM73, 32);
image(rxImageArray);
[status]=RFM73_shutdown(mypi,RFM73);