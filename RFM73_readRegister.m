function [ regValue, status ] = RFM73_readRegister(spidevID, registerAddress,byteLength)
%RFM73_readRegister: Reads data from register provided in input. Register address is expected in hex
%format.
readRegisterCommand=hex2dec(registerAddress);
outVector=writeRead(spidevID,[readRegisterCommand zeros(1,byteLength)]);
status=outVector(1);
regValue=outVector(2:length(outVector));
end

