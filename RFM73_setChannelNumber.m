function [ status ] = RFM73_setChannelNumber( spidevID,channelNumber )
%RFM73_setChannelNumber selects the RF channel used to transmit/receive.
%Channels go from  0 to 83 (1 MHz channel width), and the selected channel
%is 2400 + channelNumber [MHz]
%channelNumber is expected in decimal notation for readability
    channelSelectRegister='05';
    if(channelNumber<0)||(channelNumber >83)
        fprint('[RFM73_setChannelNumber] Error: the selected channel is out of the range of allowed channels\n');
    else
        status=RFM73_writeRegister(spidevID, [hex2dec(channelSelectRegister) channelNumber]);
    end
end

