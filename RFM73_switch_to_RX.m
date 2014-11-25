function [ status ] = RFM73_switch_to_RX( rpidevID,spidevID )
%RFM73_switch_to_RX Sets the RFM73 transceiver to RX mode

configRegister='00';
statusRegister='07';
status=RFM73_Flush_RX_FIFO( spidevID );
status=RFM73_readRegister(spidevID,statusRegister,1);
status=RFM73_writeRegister(spidevID,statusRegister,dec2hex(status,2)); %Clears RX_DR, TX_DS or MAX_RT bits in the STATUS register if any of them is set

writeDigitalPin(rpidevID,23,0)%CE pin set to 0
writeDigitalPin(rpidevID,25,0)%TREN pin set to 0

[config, status]=RFM73_readRegister(spidevID,configRegister,1);
configBinaryValue=dec2bin(config,8);
configBinaryValue(end)='1'; %Value of the PRIM_RX bit set to 1
config=bin2dec(configBinaryValue);
status=RFM73_writeRegister( spidevID, configRegister, dec2hex(config,2));
writeDigitalPin(rpidevID,23,1)%CE pin set back to 1
end

