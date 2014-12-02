function [status] = RFM73_sendPacket( rpidevID,spidevID,type,writeData )
%RFM73_sendPacket -used to send a packet through the RFM73 transceiver
%Inputs: 
%rpidevID - id of the RaspberryPI returned by MatLab following a call
%to the raspi function
%spidevID - id of the RFM73 transceiver as returned by MatLab following a call
%to the spidev() function
%type - type of transmission, can be 'W_TX_PAYLOAD' command, corresponding to binary word '10100000', or 'W_TX_PAYLOAD_NOACK' corresponding to word '10110000'  
%writeData - a vector of the data to be transmitted in decimal format
FIFO_STATUS='17';
status=RFM73_switch_to_TX(rpidevID,spidevID);
fifo_status=RFM73_readRegister(spidevID, FIFO_STATUS,1);
fifo_status_bin=dec2bin(fifo_status,8);
status=0;
if(fifo_status_bin(end-1)=='1')
    status=-1;
    return
else
    RFM73_writeToTXFIFO(spidevID,type,writeData);
end
