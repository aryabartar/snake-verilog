module test;
reg  clock , reset;
reg [9:0] target_x ,target_y;
wire  [1:0] move;
fsm dut( target_x , target_y , reset , clock , move );
initial
begin
reset = 0;
clock = 0;
target_x = 400 ; target_y = 300;
#8000
target_x = 900 ; target_y = 200;
#8000
target_x = 500 ; target_y = 300;
#8000
target_x = 800 ; target_y = 400;
#8000
target_x = 600 ; target_y = 500;
end
always #50 clock = ~clock;
 initial  
#240000 $finish; 
endmodule  