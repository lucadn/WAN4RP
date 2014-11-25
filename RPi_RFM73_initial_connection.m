mypi=raspi;
enableSPI(mypi);
mypi.AvailableSPIChannels
RFM73=spidev(mypi,'CE0');
%RFM73_init(mypi, RFM73);