function [ status ] = RFM73_switchRegisterBank( spidevID, bank )
STATUS='07';
activateData='53';
switchRequired=0;
status=RFM73_readRegister(spidevID,STATUS,1);
statusBinaryValue=dec2bin(status,8);

if ((statusBinaryValue(1)=='1'))
    if(bank==0)
        switchRequired=1;
    end
else %bit 7 is set to 0
    if bank==1
        switchRequired=1;
    end
end
if switchRequired
    fprintf('RFM73 switching from Bank %d to Bank %d\n',abs(bank-1),bank);
    status=RFM73_activate(spidevID,activateData);
else
    fprintf('RFM73 staying in Bank %d \n',bank);
end