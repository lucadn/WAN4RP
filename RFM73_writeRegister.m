function [ status ] = RFM73_writeRegister( spidevID, registerAddress, writeData)
%RFM73_writeRegister: writes data to register provided in input. Register address is expected in hex
%format.
writeToRegisterCommand=hex2dec(registerAddress)+32;
for i=1:length(writeData)/2
    hexValue=writeData(2*(i-1)+1:2*i);
    dataToWrite(i)=hex2dec(hexValue);
end
outVector=writeRead(spidevID,[writeToRegisterCommand dataToWrite]);
status=outVector(1);
end

