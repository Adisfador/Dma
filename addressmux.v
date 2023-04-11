module addressmux(signalout,signal1,signal2,sel);
output reg [7:0]signalout; 
input wire [7:0]signal1,signal2;
input wire sel;
always @(signal1 or signal2 or sel)
begin
if (sel==0)
signalout = signal1;
else if (sel==1)
signalout = signal2;
else
signalout = 1'bx;
end
endmodule 
