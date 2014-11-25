function [readData, status]=RFM73_readFromRXFIFO(spidevID,byteLength)
    R_RX_PAYLOAD='61';%'R_RX_PAYLOAD' command, corresponding to binary word '01100001'                                                        
	outVector = writeRead(spidevID, [hex2dec(R_RX_PAYLOAD) zeros(1,byteLength)]);     %Indicate to RFM73 the intention to read from RX FIFO, while reading status register and read data from RFM73
    status=outVector(1);
    readData=outVector(2:length(outVector));
end