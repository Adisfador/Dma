module iodevice1 (Ack1,GPIO1,databus,IOWrite1,clk,index);
input IOWrite1; 
input Ack1;
input wire [8:0] index;
wire IO1CS = index[8];
wire [7:0] IO1_addr = index[7:0];
output reg GPIO1;
//reg GP ;
inout[31:0] databus ;
reg [31:0] Odatabus;
integer i,k,startcount ;
input clk ;
//integer f;
reg interrupt1 [0:1];
wire [31:0] anything;

//buffer register to store  

reg [31:0] BufferReg1 [0:31];
reg [7:0] StatusReg;
integer count;

assign databus = (!IOWrite1)?Odatabus:32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz; //if read databusassign memoryReg[191]=memoryReg[191];
assign anything = (!IOWrite1)?32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz:databus;



initial 
begin 

StatusReg = 0;
count = 0;
i=0;
//f = $fopen("D:\Folder2/databusfile.txt","w");

for(k=0;k<32;k=k+1)
begin 
 BufferReg1[k]=k;
end
end 


integer file,counter;
//always @(*)
//begin
//file = $fopen("C:\\intelFPGA_lite\\DMANNN\\IO1_status.txt");
//	// $fwrite(file,"StatusReg    = %h\n",StatusReg);
//	for(counter = 0; counter < 31; counter = counter + 1)
//	    begin
//
//		    $fwrite(file,"Buffer[%3d]	= %h\n",counter,BufferReg1[counter]);  
//	    end
//
//$fclose(file);$display("end");
//end


always@(clk)
begin
// checking interrupt1 by gui 
//count=0;
$readmemb("C:\\intelFPGA_lite\\DMANNN\\interrupt1.txt", interrupt1);
if (interrupt1[0]==0)
begin
 GPIO1 =0;

end
else if (interrupt1[0]==1)
begin 
 GPIO1 = 1;
for(k=0;k<31;k=k+1)
begin 
 BufferReg1[k]=0;

end
$readmemh("C:\\intelFPGA_lite\\DMANNN\\buffermemory1.mem", BufferReg1);
end 
end

always @(clk or IO1CS or IOWrite1)
begin

if (IO1CS ==1)
begin
if(IOWrite1 == 1) //write
begin 

 BufferReg1[IO1_addr] = databus ;
end
else if(IOWrite1 == 0) //write
begin 
//to store in buffer
//GP <= 1;
 Odatabus = BufferReg1[IO1_addr] ;
end
else if(IOWrite1 == 1'bx)
begin
Odatabus = 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
end
end

else if (Ack1 ==1)
begin

$readmemh("C:\\intelFPGA_lite\\DMANNN\\buffermemory1.mem", BufferReg1);
for(i=0;i<32;i=i+1)
begin
 if(BufferReg1[i])
begin
	count = count+1;
end
end
if (!IOWrite1) begin // read

 if(count>0)
 begin
i=0;
startcount=count+1;
// $fwrite(f,"%b\n",BufferReg1[count-1]);
for(i=0;i<startcount & i<32 ;i=i+1)
begin
@(negedge clk);
if(count>0)
begin
 Odatabus = BufferReg1[i] ;
 BufferReg1[i] = 0 ;
$writememh("C:\\intelFPGA_lite\\DMANNN\\buffermemory1.mem", BufferReg1);
 count = count-1;
end
if (count==32'h00000000)
begin
 GPIO1 = 0;
interrupt1[0]=0;
$writememb("C:\\intelFPGA_lite\\DMANNN\\interrupt1.txt", interrupt1);
end
end


 end


end

end


else
Odatabus = 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
end


endmodule
