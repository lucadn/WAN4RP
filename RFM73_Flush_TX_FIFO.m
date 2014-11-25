function [ status ] = RFM73_Flush_TX_FIFO( spidevID )
%RFM73_Flush_TX_FIFO This function flushes the TX FIFO, deleting any data
%waiting for transmission.
FLUSH_TX='E1';%'FLUSH_TX' command, corresponding to binary word '11100001'
status=writeRead(spidevID, hex2dec(FLUSH_TX));
end

