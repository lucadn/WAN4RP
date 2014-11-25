function [rxImageArray] = RFM73_receiveImage(rpidevID, spidevID, maxBytePerPacket )
%receiveImage - this function receives an image broken in
%blocks of maxBytePerPacket, and uses information to rebuild an array
%containing the image data
%Detailed explanation goes here
STATUS='07';
configureDigitalPin(rpidevID,24,'input')
receivingTime=0;
IRQ=1;
receivedPackets=0;
rxImageArray=0;
while(IRQ==1 && receivingTime<100)
    fprintf('RFM73 in RX mode, waiting for packets\n');
    IRQ=readDigitalPin(rpidevID,24);
    if (IRQ==0)
        receivingTime=0;
        fprintf('IRQ set!\n');
        [status]=RFM73_readRegister(spidevID,STATUS,1);
        status_bin=dec2bin(status,8)
        if(status_bin(2)=='1') %RX_DR bit set: good!
            fprintf('RX_DR bit set: packet received and acknowledged\n');
            [rxDataDec, status]= RFM73_receivePacket(spidevID);
            receivedPackets=receivedPackets+1;
            rxDataDec
            if receivedPackets==1 %First packet: it should contain control information
                nColumnsCoded=zeros(1,rxDataDec(1));
                nRowsCoded=zeros(1,rxDataDec(2));
                for i=1:length(nColumnsCoded)/2
                    byteHexCoded=dec2hex(rxDataDec(i+2),2);
                    nColumnsCoded(2*(i-1)+1:2*i)=byteHexCoded;
                end
                for i=1:length(nRowsCoded)/2
                    byteHexCoded=dec2hex(rxDataDec(i+2+length(nColumnsCoded)/2),2);
                    nRowsCoded(2*(i-1)+1:2*i)=byteHexCoded;
                end
                nRows=hex2dec(nRowsCoded)
                nColumns=hex2dec(nColumnsCoded)
                packetsPerRow=ceil(nColumns/maxBytePerPacket);
                rxImageArray=zeros(nRows,nColumns);
                packetPositionInRow=1;
                activeRow=1;
            else %Data packets with data to be put in the image array
                rxImageArray(activeRow,(packetPositionInRow-1)*maxBytePerPacket+1:(packetPositionInRow-1)*maxBytePerPacket+length(rxDataDec))=rxDataDec;
                packetPositionInRow=mod(packetPositionInRow,packetsPerRow)+1;
                if packetPositionInRow==1
                    activeRow=activeRow+1;
                end
            end
            IRQ=readDigitalPin(rpidevID,24);
        else
           fprintf('Error: RX_DR not set, but IRQ=0\n'); 
           rxImageArray=0;
        end
    else
        receivingTime=receivingTime+0.1;
    end
    
end

end