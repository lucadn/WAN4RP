function [imgArrayData, successRate] = RFM73_transmitImage(rpidevID, spidevID, filename, format, maxBytePerPacket )
%transmitImage - this function reads an image from file and breaks it in
%blocks of maxBytePerPacket, while generating control information required
%for reception.
%Detailed explanation goes here
W_TX_PAYLOAD='A0';
totalTx=0;
successfulTx=0;
imgArrayData=imread(filename,format);
packetsPerRow=ceil(size(imgArrayData,2)/maxBytePerPacket);
nRows=size(imgArrayData,1);
totalPackets=nRows*packetsPerRow;
nColumns=size(imgArrayData,2);
nColumnsCoded=dec2hex(nColumns);
if mod(length(nColumnsCoded),2)
    nColumnsCoded=['0' nColumnsCoded];
end
nRowsCoded=dec2hex(nRows);
if mod(length(nRowsCoded),2)
    nRowsCoded=['0' nRowsCoded];
end
txControlData=[length(nColumnsCoded) length(nRowsCoded)];
for i=1:length(nColumnsCoded)/2
    txControlData=[txControlData hex2dec(nColumnsCoded(2*(i-1)+1:2*i))];
end
for i=1:length(nRowsCoded)/2
    txControlData=[txControlData hex2dec(nRowsCoded(2*(i-1)+1:2*i))];
end
RFM73_sendPacket( rpidevID,spidevID,W_TX_PAYLOAD,txControlData);
outcome=RFM73_checkTxOutcome( rpidevID,spidevID);
totalTx=totalTx+1;
if outcome==0
    successfulTx=successfulTx+1;
end
for i=1:nRows
    if outcome==0
        for j=1:packetsPerRow
            if j<packetsPerRow
                txData=imgArrayData(i,(j-1)*maxBytePerPacket+1:j*maxBytePerPacket);
            else
                txData=imgArrayData(i,(j-1)*maxBytePerPacket+1:length(imgArrayData(i,:)));
            end
            pause(0.005)
            RFM73_sendPacket(rpidevID,spidevID,W_TX_PAYLOAD,txData);
            outcome=RFM73_checkTxOutcome(rpidevID,spidevID);
            txAttempts=1;
            while ((outcome==-1))
                RFM73_sendPacket(rpidevID,spidevID,W_TX_PAYLOAD,txData);
                outcome=RFM73_checkTxOutcome(rpidevID,spidevID);
                fprintf('Packet %d out of %d: transmission failed, attempt # %d\n', successfulTx+1,totalPackets+1,txAttempts+1);
                txAttempts=txAttempts+1;
            end        
            totalTx=totalTx+1;
            if outcome==0
                successfulTx=successfulTx+1;
                 fprintf('Packet %d out of %d successfully transmitted\n', successfulTx,totalPackets+1);
            else
                break;
            end
        end
    else
        break;
    end
end
successRate=successfulTx/totalTx;
fprintf('Transmitted packets: %d; received packets: %d; success rate: %f\n',totalTx,successfulTx,successRate);
end
