function [status]=RFM73_writeToTXFIFO(spidevID,type,writeData)
    %dataToWrite=hex2dec(writeData);
    dataToWrite=writeData;
    outVector = writeRead(spidevID, [hex2dec(type) dataToWrite]);     %Indicate to RFM73 the intention to write to TX FIFO while reading status register, and write data
    status=outVector(1);
end