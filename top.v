`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:25:32 05/01/2018 
// Design Name: 
// Module Name:    top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module top(
    input clock,
    input reset,
    output hsync,
    output vsync,
    output [9:0] rgb,
	 output clk_out
    );
	 wire [9:0] target_x, target_y;
	 wire [1:0] move;
	 wire clock_fsm;

top_pong u1 (.clock(clock), .reset(~reset), .hsync(hsync), .vsync(vsync),
				.rgb(rgb), .move(move), .target_x(target_x), .target_y(target_y), 
				.clk_out(clock_fsm));
   fsm u2(.target_x(target_x), .target_y(target_y),.clock(clock_fsm), .move(move),.reset(reset));
endmodule
 module fsm(
 input  [9:0] target_x,
 input  [9:0] target_y,
 input reset,
 input clock,
 output  reg [1:0] move
 );

parameter  s0 = 2'b00, s1 = 2'b01, s2 = 2'b10;
reg [1:0] state= s0; 
reg [250:0] xs , ys;
reg [10:0] x1,y1;
reg [10:0] xt,yt;
reg [10:0] xhelp,yhelp;
reg [1:0] flag;
reg [10:0] tempx1,tempy1;
reg [10:0] xstemp , ystemp;
reg [10:0] xttemp , yttemp ;
reg [1:0] locsnake;
reg [1:0] loctarget;
reg [2:0] out;
reg [1:0] tempstate , tempmove ; 
reg [1:0] loc ;

initial 
begin
 xs[9:0] = 500;
  ys[9:0] = 400;
 
  xs [19:10] = 490; 
  ys[19:10] = 400; 
 
  
 xs[250:20] = 0 ; 
 ys[250:20] = 0 ; 
 
 
  out = 3'b0;
 end 
  
  
   always @ (posedge clock or negedge reset)
  
	 begin 
		 
	 if(~reset) 
	 begin 
	 state = s0;
	  out = 3'b0 ;
	 end 
	 
		 else  
		 begin 
		 
			xt = target_x; 
			yt = target_y;
	  			
			if((target_x >= 300) && (target_x <= 630 )&& (target_y >= 50) && (target_y <= 310)) 
					loctarget = 2'b00;
			else if((target_x >= 300) && (target_x <= 630) && (target_y>= 330) && (target_y <= 590))
					loctarget = 2'b11;
			else if((target_x >= 650 )&& (target_x <= 990) && (target_y >= 50) && (target_y <= 310))
					loctarget = 2'b01;
			else if((target_x >= 650) && (target_x <= 990 )&& (target_y >= 330) && (target_y <= 590))
					loctarget = 2'b10;
				
				
				if((xs[9:0] >= 300) && (xs[9:0] <= 630 )&& (ys[9:0] >= 50) && (ys[9:0] <= 310)) 
					locsnake = 2'b00;
			else if((xs[9:0] >= 300) && (xs[9:0] <= 630) && (ys[9:0] >= 330) && (ys[9:0] <= 590))
					locsnake = 2'b11;
			else if((xs[9:0] >= 650 )&& (xs[9:0] <= 990) && (ys[9:0] >= 50) && (ys[9:0] <= 310))
					locsnake = 2'b01;
			else if((xs[9:0] >= 650) && (xs[9:0] <= 990 )&& (ys[9:0] >= 330) && (ys[9:0] <= 590))
					locsnake = 2'b10;





			if(locsnake == 2'b00 && loctarget == 2'b00)
				begin
				xt = target_x; 
				yt = target_y;
				end
		

		else if(locsnake == 2'b01 && loctarget == 2'b00)
				begin
				
				if(out == 3'b000)begin
				xt = 670; 
				yt = 290;
				if (((xs[9:0] - xt < 20) || ( xt - xs[9:0] < 20 )) && ((ys[9:0] - yt < 20) || (yt - ys[9:0] < 20)))
				out = 3'b001;
				end
				
				if(out ==3'b001)begin
				xt = 610;
				yt = 290;
				if (((xs[9:0] - xt < 20) || ( xt - xs[9:0] < 20 )) && ((ys[9:0] - yt < 20) || (yt - ys[9:0] < 20)))
				out = 3'b010;		

				end
				
				if(out == 3'b010)begin
				xt = target_x; 
				yt = target_y;
				if (((xs[9:0] - xt < 20) || ( xt - xs[9:0] < 20 )) && ((ys[9:0] - yt < 20) || (yt - ys[9:0] < 20)))
				out = 3'b000;
				end
			
			end
		
		else if(locsnake == 2'b10 && loctarget == 2'b00)
				begin
				if(out == 3'b000)begin
				xt = 670; 
				yt = 350;
				if (((xs[9:0] - xt < 20) || ( xt - xs[9:0] < 20 )) && ((ys[9:0] - yt < 20) || (yt - ys[9:0] < 20)))
				out = 3'b001;
				end
				else if(out == 3'b001)begin
				xt = 610;
				yt = 290;
				if (((xs[9:0] - xt < 20) || ( xt - xs[9:0] < 20 )) && ((ys[9:0] - yt < 20) || (yt - ys[9:0] < 20)))
				out = 3'b010;
				end
				else if(out ==3'b010)begin
				xt = target_x; 
				yt = target_y;
				if (((xs[9:0] - xt < 20) || ( xt - xs[9:0] < 20 )) && ((ys[9:0] - yt < 20) || (yt - ys[9:0] < 20)))
				out = 3'b000;			
				end
				end
			

		else if(locsnake == 2'b11 && loctarget == 2'b00)
				begin
				if(out == 3'b000)begin
				xt = 610; 
				yt = 350;
				if (((xs[9:0] - xt < 20) || ( xt - xs[9:0] < 20 )) && ((ys[9:0] - yt < 20) || (yt - ys[9:0] < 20)))
				out = 3'b001 ;
				end
				if(out == 3'b001)begin
				xt = 610;
				yt = 290;
				if (((xs[9:0] - xt < 20) || ( xt - xs[9:0] < 20 )) && ((ys[9:0] - yt < 20) || (yt - ys[9:0] < 20)))
				out = 3'b010 ;				
				end
			 if(out ==3'b010) begin
				xt = target_x; 
				yt = target_y;
				if (((xs[9:0] - xt < 20) || ( xt - xs[9:0] < 20 )) && ((ys[9:0] - yt < 20) || (yt - ys[9:0] < 20)))
				out = 3'b000 ;	
				end 
				end		
	

	else if(locsnake == 2'b00 && loctarget == 2'b01)
				begin
				if(out ==3'b000) begin
				xt = 610;
				yt = 290;
				if (((xs[9:0] - xt < 20) || ( xt - xs[9:0] < 20 )) && ((ys[9:0] - yt < 20) || (yt - ys[9:0] < 20)))
				out = 3'b001;
				end
				else if(out ==3'b001) begin
				xt = 670;
				yt = 290;
				if (((xs[9:0] - xt < 20) || ( xt - xs[9:0] < 20 )) && ((ys[9:0] - yt < 20) || (yt - ys[9:0] < 20)))
				out = 3'b010;
				end
				else if(out ==3'b010) begin
				xt = target_x; 
				yt = target_y;
				if (((xs[9:0] - xt < 20) || ( xt - xs[9:0] < 20 )) && ((ys[9:0] - yt < 20) || (yt - ys[9:0] < 20)))
				out = 3'b000;
				end
				end
		

		else if(locsnake == 2'b01 && loctarget == 2'b01)
				begin
				xt = target_x; 
				yt = target_y;
				end
		
		

		else if(locsnake == 2'b10 && loctarget == 2'b01)
				begin
				if(out == 3'b000) begin
				xt = 670;
				yt = 350;
				if (((xs[9:0] - xt < 20) || ( xt - xs[9:0] < 20 )) && ((ys[9:0] - yt < 20) || (yt - ys[9:0] < 20)))
				out = 3'b001;
				end
				else if(out == 3'b001) begin
				xt = 670;
				yt = 290;
				if (((xs[9:0] - xt < 20) || ( xt - xs[9:0] < 20 )) && ((ys[9:0] - yt < 20) || (yt - ys[9:0] < 20)))
				out = 3'b010;
				end
				else if(out == 3'b010) begin 
				xt = target_x; 
				yt = target_y;
				if (((xs[9:0] - xt < 20) || ( xt - xs[9:0] < 20 )) && ((ys[9:0] - yt < 20) || (yt - ys[9:0] < 20)))
				out = 3'b000;
				end
				end
	

	else if(locsnake == 2'b11 && loctarget == 2'b01)
				begin
				if(out ==3'b000) begin
				xt = 610;
				yt = 350;
				if (((xs[9:0] - xt < 20) || ( xt - xs[9:0] < 20 )) && ((ys[9:0] - yt < 20) || (yt - ys[9:0] < 20)))
				out = 3'b001;
				end
				else if(out == 3'b001) begin
				xt = 670;
				yt = 290;
				if (((xs[9:0] - xt < 20) || ( xt - xs[9:0] < 20 )) && ((ys[9:0] - yt < 20) || (yt - ys[9:0] < 20)))
				out = 3'b010;
				end
				else if(out == 3'b010) begin 
				xt = target_x; 
				yt = target_y;
				if (((xs[9:0] - xt < 20) || ( xt - xs[9:0] < 20 )) && ((ys[9:0] - yt < 20) || (yt - ys[9:0] < 20)))
				out = 3'b000;
				end
				end
		

		else if(locsnake == 2'b00 && loctarget == 2'b10)
				begin
				if(out == 3'b000) begin
				xt = 610;
				yt = 290;
				if (((xs[9:0] - xt < 20) || ( xt - xs[9:0] < 20 )) && ((ys[9:0] - yt < 20) || (yt - ys[9:0] < 20)))
				out = 3'b001;
				end
				else if(out == 3'b001) begin
				xt = 670;
				yt = 350;
				if (((xs[9:0] - xt < 20) || ( xt - xs[9:0] < 20 )) && ((ys[9:0] - yt < 20) || (yt - ys[9:0] < 20)))
				out = 3'b010;
				end
				else if(out == 3'b010) begin 
				xt = target_x; 
				yt = target_y;
				if (((xs[9:0] - xt < 20) || ( xt - xs[9:0] < 20 )) && ((ys[9:0] - yt < 20) || (yt - ys[9:0] < 20)))
				out = 3'b000;
				end
				end
	

	else if(locsnake == 2'b01 && loctarget == 2'b10)
				begin
				if(out == 3'b000) begin
				xt = 670;
				yt = 290;
				if (((xs[9:0] - xt < 20) || ( xt - xs[9:0] < 20 )) && ((ys[9:0] - yt < 20) || (yt - ys[9:0] < 20)))
				out = 3'b001;
				end
				else if(out == 3'b001) begin
				xt = 670;
				yt = 350;
				if (((xs[9:0] - xt < 20) || ( xt - xs[9:0] < 20 )) && ((ys[9:0] - yt < 20) || (yt - ys[9:0] < 20)))
				out = 3'b010;
				end
				else if(out == 3'b010) begin 
				xt = target_x; 
				yt = target_y;
				if (((xs[9:0] - xt < 20) || ( xt - xs[9:0] < 20 )) && ((ys[9:0] - yt < 20) || (yt - ys[9:0] < 20)))
				out = 3'b000;
				end
				end
		

		else if(locsnake == 2'b10 && loctarget == 2'b10)
				begin
				xt = target_x; 
				yt = target_y;
				end
		

		else if(locsnake == 2'b11 && loctarget == 2'b10)
				begin
				if(out == 3'b000) begin
				xt = 610;
				yt = 350;
				if (((xs[9:0] - xt < 20) || ( xt - xs[9:0] < 20 )) && ((ys[9:0] - yt < 20) || (yt - ys[9:0] < 20)))
				out = 3'b001;
				end
				else if(out == 3'b001) begin
				xt = 670;
				yt = 350;
				if (((xs[9:0] - xt < 20) || ( xt - xs[9:0] < 20 )) && ((ys[9:0] - yt < 20) || (yt - ys[9:0] < 20)))
				out = 3'b010;
				end
				else if(out ==3'b010) begin 
				xt = target_x; 
				yt = target_y;
				if (((xs[9:0] - xt < 20) || ( xt - xs[9:0] < 20 )) && ((ys[9:0] - yt < 20) || (yt - ys[9:0] < 20)))
				out = 3'b000;
				end
				end


			else if(locsnake == 2'b00 && loctarget == 2'b11)
				begin
				if(out == 3'b000) begin
				xt = 610;
				yt = 290;
				if (((xs[9:0] - xt < 20) || ( xt - xs[9:0] < 20 )) && ((ys[9:0] - yt < 20) || (yt - ys[9:0] < 20)))
				out = 3'b001;		
				end
				else if(out == 3'b001) begin
				xt = 610;
				yt = 350;
				if (((xs[9:0] - xt < 20) || ( xt - xs[9:0] < 20 )) && ((ys[9:0] - yt < 20) || (yt - ys[9:0] < 20)))
				out = 3'b010;			
				end
				else if(out == 3'b010) begin 
				xt = target_x; 
				yt = target_y;
				if (((xs[9:0] - xt < 20) || ( xt - xs[9:0] < 20 )) && ((ys[9:0] - yt < 20) || (yt - ys[9:0] < 20)))
				out = 3'b000;
				end
				end
		

		else if(locsnake == 2'b01 && loctarget == 2'b11)
				begin
				if(out == 3'b000) begin
				xt = 670;
				yt = 290;
				if (((xs[9:0] - xt < 20) || ( xt - xs[9:0] < 20 )) && ((ys[9:0] - yt < 20) || (yt - ys[9:0] < 20)))
				out = 3'b001;
				end
				else if(out == 3'b001) begin
				xt = 610;
				yt = 350;
				if (((xs[9:0] - xt < 20) || ( xt - xs[9:0] < 20 )) && ((ys[9:0] - yt < 20) || (yt - ys[9:0] < 20)))
				out = 3'b010;
				end
				else if(out == 3'b010) begin 
				xt = target_x; 
				yt = target_y;
				if (((xs[9:0] - xt < 20) || ( xt - xs[9:0] < 20 )) && ((ys[9:0] - yt < 20) || (yt - ys[9:0] < 20)))
				out = 3'b000;
				end
				end
		

		else if(locsnake == 2'b10 && loctarget == 2'b11)
				begin
				if(out == 3'b000) begin
				xt = 670;
				yt = 350;
				if (((xs[9:0] - xt < 20) || ( xt - xs[9:0] < 20 )) && ((ys[9:0] - yt < 20) || (yt - ys[9:0] < 20)))
				out = 3'b001;
				end
				else if(out == 3'b001) begin
				xt = 610;
				yt = 350;
				if (((xs[9:0] - xt < 20) || ( xt - xs[9:0] < 20 )) && ((ys[9:0] - yt < 20) || (yt - ys[9:0] < 20)))
				out = 3'b010;
				end
				else if(out == 3'b010) begin 
				xt = target_x; 
				yt = target_y;
				if (((xs[9:0] - xt < 20) || ( xt - xs[9:0] < 20 )) && ((ys[9:0] - yt < 20) || (yt - ys[9:0] < 20)))
				out = 3'b000;
				end
				end
			
			
			else if(locsnake == 2'b11 && loctarget == 2'b11)
				begin 
				xt = target_x; 
				yt = target_y;
				end
				
				
				
			xhelp = xs[9:0]-xs[19:10];
			yhelp = ys[9:0]-ys[19:10];
	  
		 if((xs[9:0]>xs[19:10]) && (yhelp == 0)) flag = 00; //shargh
		 else if((xs[9:0]<xs[19:10]) && (yhelp == 0)) flag = 01; //gharb
	 	 else if((ys[9:0]<ys[19:10] ) && (xhelp == 0)) flag = 11; //shomal
		 else if((ys[9:0]>ys[19:10]) && (xhelp ==0 )) flag = 10; // jonob
  
		 
	    case(flag)
		
		 2'b00 : begin  ystemp = 990 - xs[9:0]; xstemp = ys[9:0] - 50;yttemp = 990 - xt; xttemp = yt - 50; end // shargh
		 
		 2'b11 : begin ystemp = ys[9:0] - 50 ; xstemp = xs[9:0] -300;yttemp = yt -50 ; xttemp = xt - 300; end // shomal
		 
		 2'b01 :begin ystemp = xs[9:0] -300 ; xstemp =590-ys[9:0];yttemp = xt - 300 ; xttemp = 590 - yt; end // gharb
		 
		 2'b10 : begin ystemp = 590 - ys[9:0]; xstemp = 990 - xs[9:0];yttemp = 590 - yt ; xttemp = 990 - xt; end // jonoob 
		 
		endcase
			
		
		 
		 x1 = xttemp-xstemp[9:0];
		 y1 = yttemp-ystemp[9:0]; 
	 
		case(state)
		
			s0 : begin 
				if(xttemp > xstemp[9:0] && yttemp > ystemp[9:0] )
					tempstate = s1;
				
				else if((yttemp + 10 == ystemp[9:0])&& xttemp > xstemp[9:0] && flag == 00)
					tempstate = s1;
			
				else if((yttemp + 10 == ystemp[9:0])&& xttemp > xstemp[9:0] && flag == 10)
					tempstate = s1;
			
			 
				else if((xttemp == xstemp[9:0] && yttemp > ystemp[9:0] ) || (xttemp < xstemp[9:0] && yttemp + 10 >= ystemp[9:0] ))
					tempstate = s2;
				else 
					tempstate = s0;
			
						end
						
			s1 : begin 
			
			tempstate = s0;
			
					end
			
			s2 : begin 
			
				tempstate = s0;

					end
			endcase
		
		
		
	case(state)
			s0: tempmove =2'b00;
               
               
			s1: tempmove = 2'b10;  
               
              
			s2: tempmove = 2'b01;
             
		endcase


			tempx1 = xs[9:0];
			tempy1= ys[9:0];

	

	case(tempmove)
			
			2'b00: 	 
		begin
			case(flag)
		
		 2'b00 : begin xs[9:0] = tempx1 + 10 ; xs[19:10] = tempx1; end ///shargh
		 
		 2'b11 : begin ys[9:0] = tempy1 -10; ys[19:10] = tempy1;end  // shomal
		 
		 2'b01 :begin xs[9:0] = tempx1 - 10 ; xs[19:10] = tempx1; end // gharb
		 
		 2'b10 : begin ys[9:0] = tempy1 + 10; ys[19:10] = tempy1 ; end  // jonob
		 
			endcase
			
       end        
               
			2'b10:
			begin 
			case(flag)
		
		 2'b00 : begin ys[9:0] = tempy1 +10 ; xs[19:10] = tempx1 ; end // shargh 
		 
		 2'b11 : begin xs[9:0] = tempx1 + 10 ; ys[19:10] = tempy1;end // shomal
		 
		 2'b01 :begin ys[9:0] = tempy1-10 ; xs[19:10] = tempx1; end // gharb
		 
		 2'b10 : begin xs[9:0] = tempx1 - 10  ; ys[19:10] = tempy1; end //jonob
		 
			endcase
          end     
              
			2'b01:  
		begin
			case(flag)
		
			2'b00 : begin ys[9:0] = tempy1 -10 ; xs[19:10] = tempx1 ; end // shargh
		 
		  2'b11 : begin xs[9:0] = tempx1 - 10 ; ys[19:10] = tempy1 ; end // shomal 
		 
		  2'b01 :begin  ys[9:0] = tempy1 +10  ; xs[19:10] = tempx1 ; end // gharb
		 
		 2'b10 : begin xs[9:0] =  tempx1 + 10 ; ys[19:10] =  tempy1; end // jonob
		  
		endcase 
				end
        
		endcase
		 
		 
		 
		 
		 
		 
		 
		 
		 
		 
		 
		 
		 
		 
		 
		 
		 
		 
		 
		 
		 
		 
		 
		 
		 
		 
		 
		 		 
		 x1 = xttemp-xstemp[9:0];
		 y1 = yttemp-ystemp[9:0]; 
	
		case(state)
		
			s0 : begin 
				if(xttemp > xstemp[9:0] && yttemp > ystemp[9:0] )
					state = s1;
				
				else if((yttemp + 10 == ystemp[9:0])&& xttemp > xstemp[9:0] && flag == 00)
					state = s1;
			
				else if((yttemp + 10 == ystemp[9:0])&& xttemp > xstemp[9:0] && flag == 10)
					state = s1;
			
			 
				else if((xttemp == xstemp[9:0] && yttemp > ystemp[9:0] ) || (xttemp < xstemp[9:0] && yttemp + 10 >= ystemp[9:0] ))
					state = s2;
				else 
					state = s0;
			
						end
						
			s1 : begin 
			
			state = s0;
			
					end
			
			s2 : begin 
			
				state = s0;

					end
			endcase
		
		
		
	case(state)
			s0: move =2'b00;
               
               
			s1: move = 2'b10;  
               
              
			s2: move = 2'b01;
             
		endcase

		 
 
		 

end
end

 endmodule  