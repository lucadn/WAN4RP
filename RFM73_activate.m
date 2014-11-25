function [ status ] = RFM73_activate( spidevID, activateData)
%RFM73_activate sends to the RFM73 transceiver the ACTIVATE command followed by the code received in input 
ACTIVATE='50';%'ACTIVATE' command, corresponding to binary word '01010000'
status=writeRead(spidevID, [hex2dec(ACTIVATE) hex2dec(activateData)]);

end

