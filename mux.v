module mux(signalout,signal1,signal2,sel); 
output reg signalout; 
input wire signal1,signal2,sel;
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
