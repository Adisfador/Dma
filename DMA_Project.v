module DMA_Project(firstempty,D_address,grant,D_IOWrite1,D_IOWrite2,D_memwrite,D_IOAck1,D_IOAck2,DMA_instruction,clock,IOIP1,IOIP2,busybus,next_source,next_destination); //,databus
input [25:0] DMA_instruction ;

wire[1:0] op,type; 
wire [5:0] count;
output reg [7:0]D_address;
input clock,IOIP1,IOIP2,grant; 
wire clk,gnt;

wire[31:0] data; 
output reg D_IOWrite1,D_IOWrite2,D_memwrite,D_IOAck1,D_IOAck2,busybus; 
input [7:0] next_source,next_destination,firstempty;
reg [7:0] source,destination,IPaddress;
reg [5:0]up_count;
assign op = DMA_instruction [25:24];

assign clk = clock;
assign type = DMA_instruction [23:22];
assign count = DMA_instruction [5:0];





// always @(grant )//or posedge clk
// begin 
// if (grant == 1)
// busybus=1;
// else
// busybus=0; 
// end


always@( posedge clk)
begin
source = next_source;
destination = next_destination;
IPaddress = firstempty;

end


//always @ (grant or posedge clk) 

always @ ( posedge clk)  // put grant or 
begin
if (grant==1)
begin
if (op == 2'b01 && type ==2'b01 ) // put && busybus==0
begin
if (destination <= 223 && destination >= 192) // from memory to I/O1
begin
D_IOWrite1 = 1;
D_IOWrite2= 1'b0;
D_memwrite = 0;
busybus=1;
D_IOAck1 =0;
D_IOAck2 =0;
D_address = source;
#5
D_address = destination;
#4
D_address = 8'bx; 
end
else if (destination <= 255 && destination >= 224) // from memory to I/O2
begin
D_IOWrite1 = 1'b0;
D_IOWrite2 = 1;
D_memwrite = 0;
busybus=1;
D_IOAck1 =0;
D_IOAck2 =0;
D_address = source;
#5
D_address = destination;
#4
D_address = 8'bx; 
end
end

else if (op == 2'b00 && type ==2'b01 ) // put && busybus==0
begin
if (source <= 223 && source >= 192) // from I/O1 to memory 
begin
D_IOWrite1 = 0;
D_IOWrite2 = 1'b0;
D_memwrite = 1;       
busybus=1;
D_IOAck1 =0;
D_IOAck2=0;
D_address = source;
#5
D_address = destination;
#4
D_address = 8'bz; 
end
else if (source <= 255 && source >= 224) // from I/O2 to memory 
begin
D_IOWrite1 = 1'b0;
D_IOWrite2 = 0;
D_memwrite = 1;
busybus=1;
D_IOAck1 =0;
D_IOAck2 =0;
D_address = source;
#5
D_address = destination;
#4
D_address = 8'bx; 
end
end


else if (( (op == 2'b01 && type == 2'b10)) ) // from memory to memory  // put && (busybus == 0) //(op == 2'b00 && type == 2'b10) ||
begin    
D_IOWrite1 = 1'b1;
D_IOWrite2 = 1'b0;
D_memwrite = 0;   // read from any place in memory at posedge
busybus=1;
D_IOAck1 =0;
D_IOAck2 =0;
D_address = source;
#2
D_address = 223;
#2
D_IOWrite1 = 1'b0;
D_memwrite = 1;  // write in any place in memory at negedge of same cycle 
#3
D_address = destination;
#2
D_address = 8'bx; 
end

else 
begin
if ((IOIP1==1) &&(IOIP2==1) )  //I/O1 will have higher priority than I/O2 .. it's just a design choice  // put && (busybus!=1)
begin
D_IOWrite1 = 0;
D_IOWrite2 = 1'b0;
busybus=1;
D_IOAck1 =1;
D_IOAck2 =0;
D_memwrite = 1'b0;
D_address=8'bx;
#5
D_memwrite = 1;
D_address=IPaddress;
#4
D_address = 8'bx; 
end


else if ((IOIP1==1) &&(IOIP2!=1) )  // put && (busybus!=1)
begin
D_IOWrite1 = 0;
D_IOWrite2 = 1'b0;
busybus=1;
D_IOAck1 =1;
D_IOAck2 =0;
D_memwrite = 1'b0;
D_address=8'bx;
#5
D_memwrite = 1;
D_address=IPaddress;
#4
D_address = 8'bx; 
end

else if ((IOIP1!=1) &&(IOIP2==1) )  // put && (busybus!=1)
begin
D_IOWrite1 = 1'b0;
D_IOWrite2 = 0;
busybus=1;
D_IOAck1 =0;
D_IOAck2 =1;
D_memwrite = 1'b0;
D_address=8'bx;
#5
D_memwrite = 1;
D_address=IPaddress;
#4
D_address = 8'bx; 
end

else
begin
D_IOWrite1 = 1'b0;
D_IOWrite2 = 1'b0;
D_memwrite = 1'b0;
busybus=0;
D_IOAck1 =0;
D_IOAck2 =0;
D_address=IPaddress;
#5
D_address = 8'bz; 
end

end
end
else
busybus=0; 
end

endmodule


