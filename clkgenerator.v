module clkgenerator(clock);                                  
output reg clock;   
initial 
clock = 1;
always 
begin
#5
clock = ~ clock;

end
endmodule