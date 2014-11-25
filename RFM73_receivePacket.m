function [ readData, status] = RFM73_receivePacket(spidevID)
%RFM73_receivePacket reads packet from RX_FIFO
%Inputs: 
%spidevID - id of the RFM73 transceiver as returned by MatLab following a call
%to the spidev() function
%Outputs:
%readData: vector containing the data read from the RX FIFO
STATUS='07';
status=RFM73_readRegister(spidevID, STATUS,1);
status_bin=dec2bin(status,8);
R_RX_PL_WID_CMD='60';
if(status_bin(2)=='1') %Bit RX_DR set: data ready to be received...
    payloadLength=RFM73_readRegister(spidevID,R_RX_PL_WID_CMD,1);
    [readData, status]=RFM73_readFromRXFIFO(spidevID,payloadLength);
end
RFM73_writeRegister(spidevID,STATUS,dec2hex(status));%Clear the RX_DR bit by writing it to 1.
