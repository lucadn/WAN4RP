function [status]=RFM73_init(rpidevID, spidevID)
rpiConnected=1;
CONFIG='00';
Bank0_reg_0_9=['0F' '3F' '3F' '03' 'FF' '17' '07' '07' '00' '00'];
%Bank0_reg_0_9=[15 63 63 3 255 23 7 7 0 0];
Bank0_reg_12_15=['C3' 'C4' 'C5' 'C6'];
%Bank0_reg_12_15=[195 196 197 198];
Bank0_reg_17_23=['20' '20' '20' '20' '20' '20' '00'];
%Bank0_reg_17_23=[32 32 32 32 32 32 0];
Bank0_reg_28='3F';
Bank0_reg_29='07';

Bank1_reg_0_13(1,:)=['E2' '01' '4B' '40'];
Bank1_reg_0_13(2,:)=['00' '00' '4B' 'C0'];
Bank1_reg_0_13(3,:)=['02' '8C' 'FC' 'D0'];
Bank1_reg_0_13(4,:)=['41' '39' '00' '99'];
Bank1_reg_0_13(5,:)=['1B' '82' '96' 'D9'];
Bank1_reg_0_13(6,:)=['A6' '7F' '02' '24'];
Bank1_reg_0_13(7,:)=['00' '00' '00' '00'];
Bank1_reg_0_13(8,:)=['00' '00' '00' '00'];
Bank1_reg_0_13(9,:)=['00' '00' '00' '00'];
Bank1_reg_0_13(10,:)=['00' '00' '00' '00'];
Bank1_reg_0_13(11,:)=['00' '00' '00' '00'];
Bank1_reg_0_13(12,:)=['00' '00' '00' '00'];
Bank1_reg_0_13(13,:)=['00' '12' '73' '00'];
Bank1_reg_0_13(14,:)=['46' 'B4' '80' '00'];
Bank1_reg_14=['41' '20' '08' '04' '81' '20' 'CF' 'F7' 'FE' 'FF' 'FF'];

RX0_Address=['34' '43' '10' '10' '01'];
RX1_Address=['39' '38' '37' '36' 'C2'];
%From here: Write registers in Bank 0
if(rpiConnected)
    RFM73_switchRegisterBank(spidevID,0); %First, switch to Bank 0
    for i=1:10
        status=RFM73_writeRegister(spidevID,dec2hex(i-1,2),Bank0_reg_0_9(2*(i-1)+1:2*i));
    end
    for i=1:4
        status=RFM73_writeRegister(spidevID,dec2hex(i-1+12,2),Bank0_reg_12_15(2*(i-1)+1:2*i));
    end
    for i=1:6
        status=RFM73_writeRegister(spidevID,dec2hex(i-1+17,2),Bank0_reg_17_23(2*(i-1)+1:2*i));
    end
    
    status=RFM73_writeRegister(spidevID,dec2hex(10,2),RX0_Address);
    status=RFM73_writeRegister(spidevID,dec2hex(11,2),RX1_Address);
    status=RFM73_writeRegister(spidevID,dec2hex(16,2),RX0_Address);
    
    %Check if Register 29 is set to 0; in case it is, activate the chip.
    [reg status]=RFM73_readRegister(spidevID,dec2hex(29,2),1);
    if (reg==0)
        fprintf('Activating features\n');
        RFM73_activate(spidevID,'73');
        status=RFM73_writeRegister(spidevID,dec2hex(29,2),Bank0_reg_29);
        [reg status]=RFM73_readRegister(spidevID,dec2hex(29,2),1);
        pause(0.1);
        if(reg==0)
             fprintf('Error activating features\n');
        elseif (reg==7)
             fprintf('Features activated correctly\n');
        end
    elseif (reg==7)
        fprintf('Features already activated\n');
    end
    status=RFM73_writeRegister(spidevID,dec2hex(28,2),Bank0_reg_28);
    %end of registers in Bank 0
end
%From here: Write registers in Bank 1
if(rpiConnected)
    RFM73_switchRegisterBank(spidevID,1);
end

for i=1:9
    for(j=1:4)
        flippedValue(2*j-1)=Bank1_reg_0_13(i,8-(2*j-1));
        flippedValue(2*j)=Bank1_reg_0_13(i,8-2*(j-1));
    end
    %Bank1_reg_0_13(i,:)
    %flippedValue
    if(rpiConnected)
        status=RFM73_writeRegister(spidevID,dec2hex(i-1,2),flippedValue);
    end
end
if(rpiConnected)
    for i=10:14
        status=RFM73_writeRegister(spidevID,dec2hex(i-1,2),Bank1_reg_0_13(i,:));
    end
    status=RFM73_writeRegister(spidevID,dec2hex(14,2),Bank1_reg_14);
end
%The code below is used to toggle bits 25 and 26 of Register 4 in
%Bank 1. First they are set to '1' and next they are set back to '0'
for(j=1:4)
    flippedValue(2*j-1)=Bank1_reg_0_13(5,8-(2*j-1));
    flippedValue(2*j)=Bank1_reg_0_13(5,8-2*(j-1));
end
%MSBbin
%pause
%Bank1_reg_0_13(5,:)
Bank1_reg_4_flipped=flippedValue;

MSB=Bank1_reg_4_flipped(1:2);

MSBbin=dec2bin(hex2dec(MSB),8);
% if(length(MSBbin)<8)
%     for q=1:8-length(MSBbin)
%         MSBbin_long(q)='0';
%     end
%     MSBbin= [MSBbin_long MSBbin];
% end

MSBbin(6)='1';
MSBbin(7)='1';
%MSBbin
MSB=dec2hex(bin2dec(MSBbin),2);
Bank1_reg_4_flipped(1:2)=MSB;
%pause
if(rpiConnected)
    status=RFM73_writeRegister(spidevID,dec2hex(4,2),Bank1_reg_4_flipped);
end
MSB=Bank1_reg_4_flipped(1:2);
MSBbin=dec2bin(hex2dec(MSB),8);
% if(length(MSBbin)<8)
%     for q=1:8-length(MSBbin)
%         MSBbin_long(q)='0';
%     end
%     MSBbin= [MSBbin_long MSBbin];
% end
%MSBbin

%pause
MSBbin(6)='0';
MSBbin(7)='0';
%MSBbin
%pause
MSB=dec2hex(bin2dec(MSBbin),2);
Bank1_reg_4_flipped(1:2)=MSB;
if(rpiConnected)
    status=RFM73_writeRegister(spidevID,dec2hex(4,2),Bank1_reg_4_flipped);
    %end of registers in Bank 1
    %After writing all registers, switch to Bank 0 and set the device in RX
    %Mode
    writeDigitalPin(rpidevID,17,1)% Activate chip by setting the PAEN pin
    status=RFM73_switchRegisterBank(spidevID,0);
    [config, status]=RFM73_readRegister(spidevID,CONFIG,1);
    configBinaryValue=dec2bin(config,8);
    configBinaryValue(7)='1'; %Value of the PWR_UP bit set to 1
    config=bin2dec(configBinaryValue)
    status=RFM73_writeRegister( spidevID, CONFIG, dec2hex(config,2));
    status=RFM73_switch_to_RX(rpidevID, spidevID);
end