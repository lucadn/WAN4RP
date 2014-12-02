function [status] = RFM73_shutdown( rpidevID, spidevID)
%RFM73_shutdown The functions brings the RFM73 transceiver back to the
%shutdown state
%   Detailed explanation goes here
CONFIG='00';
[config status]=RFM73_readRegister(spidevID, CONFIG,1);
config_bin=dec2bin(config,8);
config_bin(7)=0;%Reset the PWR_UP bit to 0.
config=bin2dec(config_bin);
[status]=RFM73_writeRegister(spidevID, CONFIG,dec2hex(config,2));
writeDigitalPin(rpidevID,17,0)% Deactivate chip by resetting the PAEN pin
end

