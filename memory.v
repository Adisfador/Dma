module memory(memWR,databus,index,clk,firstempty);// remember memfull 
input wire [8:0]index ;
input memWR;
wire MemCS=index[8];
wire [7:0]addr =index[7:0];
inout [31:0] databus;
reg [31:0] Odatabus;
input clk;
reg [31:0] memoryReg [0:191];
integer k;
reg [7:0]i;
//output reg memfull;
output reg [7:0] firstempty; 
wire [31:0] anything;



assign databus = (!memWR)?Odatabus:32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz; //if read databusassign memoryReg[191]=memoryReg[191];
assign anything = (!memWR)?32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz:databus; 
//assign databus = (!memWR)?32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz:databus;


initial 
begin
memoryReg[191] =0;
k=0;
for(k=0;k<100;k=k+1)
begin 
 memoryReg[k]=k+1;
end
for(k=100;k<191;k=k+1) 
begin 
 memoryReg[k]=0;
end

end

integer file, count;

//always @(memWR)
// begin
////	#50 // delay between writing to the memory and then writing to the file
// file = $fopen("C:\\intelFPGA_lite\\DMANNN\\memory.txt","w");
//
//for(count=0;count<192;count=count+4)
//	begin
//		$fwrite(file,"%04d: ", count);
//  $fwrite(file,"%h %h %h %h",memoryReg[count],memoryReg[count+1],memoryReg[count+2],memoryReg[count+3]);
//		$fwrite(file,"\n");		
//	end
//	$fclose(file);
//
//end



always @(clk or MemCS or memWR)
begin
i=190;
for (i=190;i>0;i=i-1)
begin
if(memoryReg[i]==32'h0000_0000)
begin
memoryReg[191]=i;
firstempty = i;
end

end

if (MemCS)
begin
  if(memWR && addr!=191) 
  begin
   memoryReg[addr]  = databus; 
  end

  else if(!memWR)
  begin
  Odatabus = memoryReg[addr];
  end
//$writememb("C:\\Users\\fares\\Desktop\\year work\\DMA proj\\GUI\\memory.mem", memoryReg); 
end

else
Odatabus = 32'hzzzzzzzz;

end

endmodule 

