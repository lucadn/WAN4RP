function [ status ] = RFM73_switch_to_TX( rpidevID,spidevID )
%RFM73_switch_to_TX Sets the RFM73 transceiver to TX mode

configRegister='00';
statusRegister='07';
status=RFM73_Flush_TX_FIFO( spidevID );
%NOTE: reset of bits in the STATUS register missing in the HopeRF code...
%From HERE
status=RFM73_readRegister(spidevID,statusRegister,1);
status=RFM73_writeRegister(spidevID,statusRegister,dec2hex(status,2)); %Clears RX_DR, TX_DS or MAX_RT bits in the STATUS register if any of them is set
%to HERE

writeDigitalPin(rpidevID,23,0)%CE pin set to 0

[config, status]=RFM73_readRegister(spidevID,configRegister,1);
configBinaryValue=dec2bin(config,8);
configBinaryValue(end)='0'; %Value of the PRIM_RX bit set to 0
config=bin2dec(configBinaryValue);
status=RFM73_writeRegister( spidevID, configRegister, dec2hex(config,2));
writeDigitalPin(rpidevID,23,1)%CE pin set back to 1
%writeDigitalPin(rpidevID,25,1)%TREN pin set to 1
end

