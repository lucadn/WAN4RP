function [ status ] = RFM73_Flush_RX_FIFO( spidevID )
%RFM73_Flush_RX_FIFO This function flushes the RX FIFO, deleting any received data
%waiting for being read by the MCU.
FLUSH_RX='E2';%'FLUSH_RX' command, corresponding to binary word '11100010'
status=writeRead(spidevID, hex2dec(FLUSH_RX));
end

