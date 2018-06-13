
----------------------------------------------------------------------------------
-- text v2

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use IEEe.std_logic_arith.all;

			

entity pong_text is
port 
(
	clock			: in std_logic ;
	reset 		: in std_logic ;
	pixel_x		: in std_logic_vector( 9 downto 0 );
	pixel_y		: in std_logic_vector( 9 downto 0 );
	--dig0			: in std_logic_vector( 3 downto 0 );
	--dig1			: in std_logic_vector( 3 downto 0 );
	--winner 		: in std_logic ;
	--win_on  		: in std_logic ;
	
	text_rgb		: out std_logic_vector( 9 downto 0 );
	text_on 		: out std_logic;
	move			: in std_logic_vector(1 downto 0);
	target_x		: out std_logic_vector(9 downto 0);
	target_y		: out std_logic_vector(9 downto 0);
	clk_out : out std_logic
	
	--inp_x			: in 	std_logic_vector( 31 downto 0 );
	--inp_y			: in 	std_logic_vector( 31 downto 0 )
);

end pong_text;

architecture Behavioral of pong_text is
constant x_min : integer:=300;
constant y_min : integer:=50;
constant x_max : integer:=1000;
constant y_max : integer:=600;
constant line_width : integer:=5;
constant u_x_target_1 : integer:=0; -- unscaled points
constant u_y_target_1 : integer:=2;
constant u_x_target_2 : integer:=8;
constant u_y_target_2 : integer:=7;
constant point_size : integer:=10;

constant x_target_4 : integer:=x_min+(((((8*10**8)/(2**20))*(x_max - x_min))/(512))*5/8);
constant y_target_4 : integer:=y_min+(((((7*10**8)/(2**20))*(y_max-y_min))/(512))*5/8);
constant x_target_5 : integer:= x_min+0;
constant y_target_5 : integer:=y_min+((((2*10**8)/(2**20)*(y_max-y_min))/(512))*5/8);

signal x_target_3 : integer;--:=x_min+((3)*(x_max-x_min))/(8);
signal y_target_3 : integer;--:=y_min+(2*(y_max-y_min))/(8);
signal u_x_target_3 : integer;--:=x_min+((3)*(x_max-x_min))/(8);
signal u_y_target_3 : integer;--
--type position is array (1 downto 0)(19 downto 0) of bit;--integer range 0 to 1023;
type position is array (0 to 15) of std_logic_vector(9 downto 0);
signal y : position;
signal x : position;
signal startW, endW, target_pointer : integer range 0 to 15;
signal pix_x , pix_y , counter: integer ;
signal clk : std_logic;
signal clk_en : std_logic:='0';
type arrayBit is array (0 to 15) of std_logic;
signal show : arrayBit;
type position1 is array (0 to 15) of std_logic_vector(9 downto 0);
constant target_x_point : position1 := (
conv_std_logic_vector( 400, 10), 
conv_std_logic_vector( 700, 10), 
conv_std_logic_vector( 500, 10), 
conv_std_logic_vector( 800, 10),
conv_std_logic_vector( 600, 10), 
conv_std_logic_vector( 400, 10), 
conv_std_logic_vector( 600, 10), 
conv_std_logic_vector( 750, 10), 
conv_std_logic_vector( 500, 10),
conv_std_logic_vector( 510, 10), 
conv_std_logic_vector( 300, 10), 
conv_std_logic_vector( 700, 10), 
conv_std_logic_vector( 400, 10), 
conv_std_logic_vector( 500, 10),
conv_std_logic_vector( 600, 10), 
conv_std_logic_vector( 700, 10));
constant target_y_point : position1 := (
conv_std_logic_vector( 550, 10), 
conv_std_logic_vector( 550, 10), 
conv_std_logic_vector( 300, 10), 
conv_std_logic_vector( 400, 10),
conv_std_logic_vector( 500, 10), 
conv_std_logic_vector( 560, 10), 
conv_std_logic_vector( 490, 10), 
conv_std_logic_vector( 360, 10), 
conv_std_logic_vector( 100, 10),
conv_std_logic_vector( 110, 10), 
conv_std_logic_vector( 300, 10), 
conv_std_logic_vector( 400, 10), 
conv_std_logic_vector( 500, 10), 
conv_std_logic_vector( 100, 10),
conv_std_logic_vector( 200, 10), 
conv_std_logic_vector( 300, 10));
begin
pix_x <= to_integer(unsigned(pixel_x));
pix_y <= to_integer(unsigned(pixel_y));
clk_out<=clk;
--x(5)<=conv_std_logic_vector( 500, 10);
--	y(5)<=conv_std_logic_vector( 400, 10);
--	x(3)<=conv_std_logic_vector( 700, 10);
--	y(3)<=conv_std_logic_vector( 200, 10);
process (clock)
	begin
		if (reset='1') then
			counter <=0;
			clk <= '1';
			--lost <= '0';
		elsif rising_edge(clock) then
			if(clk_en='1')then
				counter <= counter +1;
			end if;
			if (counter > 8000000) then
				counter <=0;
				clk <= '1';
			elsif (counter > 4000000 and counter <= 8000000) then
				clk <='0';
			end if;
		end if;
end process;

process (clk, reset)
	begin
		if (reset='1') then
			startW <= 0;
			clk_en <= '1';
			endW <= 15;
			target_pointer <= 0;
			for I in 0 to 15 loop
				x(I)<=conv_std_logic_vector( 500, 10);
				y(I)<=conv_std_logic_vector( 400, 10);
				if(I=0) then
					show(I) <= '1';
				else
					show(I) <= '0';
				end if;
			end loop;
		elsif rising_edge(clk) then
			target_x <= target_x_point(target_pointer);
			target_y <= target_y_point(target_pointer);
			for I in 0 to 15 loop
				if((x(I)=x(startW)) and (y(I)=y(startW)) and (show(I)='1') and not(I=startW))then
					clk_en <= '0';
				end if;
			end loop;
			if(target_pointer >= 15)then
				clk_en <= '0';
			end if;
			if(move ="00" or move = "11")then
				if((x(0)>x(15))and (y(0)=y(15)) and (startW=0))then
					x((startW+1) mod 16)<= x(startW)+10;
					y((startW+1) mod 16)<= y(startW);
				elsif((x(startW)>x((startW-1) mod 16))and (y(startW)=y((startW-1) mod 16)))then
					x((startW+1) mod 16)<= x(startW)+10;
					y((startW+1) mod 16)<= y(startW);
				elsif((y(0)>y(15))and (x(0)=x(15)) and (startW=0))then
					y((startW+1) mod 16)<= y(startW)+10;
					x((startW+1) mod 16)<= x(startW);
				elsif((y(startW)>y((startW-1) mod 16))and (x(startW)=x((startW-1) mod 16)))then
					y((startW+1) mod 16)<= y(startW)+10;
					x((startW+1) mod 16)<= x(startW);
				elsif((y(0)<y(15))and (x(0)=x(15)) and (startW=0))then
					y((startW+1) mod 16)<= y(startW)-10;
					x((startW+1) mod 16)<= x(startW);
				elsif((y(startW)<y((startW-1) mod 16))and (x(startW)=x((startW-1) mod 16)))then
					y((startW+1) mod 16)<= y(startW)-10;
					x((startW+1) mod 16)<= x(startW);
				elsif((x(0)<x(15))and (y(0)=y(15)) and (startW=0))then
					x((startW+1) mod 16)<= x(startW)-10;
					y((startW+1) mod 16)<= y(startW);
				elsif((x(startW)<x((startW-1) mod 16))and (y(startW)=y((startW-1) mod 16)))then
					x((startW+1) mod 16)<= x(startW)-10;
					y((startW+1) mod 16)<= y(startW);
				else
					x((startW+1) mod 16)<= x(startW)+10;
					y((startW+1) mod 16)<= y(startW);
				end if;
			elsif(move ="01")then
				if((x(0)>x(15))and (y(0)=y(15)) and (startW=0))then
					y((startW+1) mod 16)<= y(startW)-10;
					x((startW+1) mod 16)<= x(startW);
				elsif((x(startW)>x(startW-1))and (y(startW)=y(startW-1)))then
					y((startW+1) mod 16)<= y(startW)-10;
					x((startW+1) mod 16)<= x(startW);
				elsif((y(0)>y(15))and (x(0)=x(15)) and (startW=0))then
					x((startW+1) mod 16)<= x(startW)+10;
					y((startW+1) mod 16)<= y(startW);
				elsif((y(startW)>y(startW-1))and (x(startW)=x(startW-1)))then
					x((startW+1) mod 16)<= x(startW)+10;
					y((startW+1) mod 16)<= y(startW);
				elsif((y(0)<y(15))and (x(0)=x(15)) and (startW=0))then
					x((startW+1) mod 16)<= x(startW)-10;
					y((startW+1) mod 16)<= y(startW);
				elsif((y(startW)<y(startW-1))and (x(startW)=x(startW-1)))then
					x((startW+1) mod 16)<= x(startW)-10;
					y((startW+1) mod 16)<= y(startW);
				elsif((x(0)<x(15))and (y(0)=y(15)) and (startW=0))then
					y((startW+1) mod 16)<= y(startW)+10;
					x((startW+1) mod 16)<= x(startW);
				elsif((x(startW)<x(startW-1))and (y(startW)=y(startW-1)))then
					y((startW+1) mod 16)<= y(startW)+10;
					x((startW+1) mod 16)<= x(startW);
				else
					x((startW+1) mod 16)<= x(startW)-10;
					y((startW+1) mod 16)<= y(startW);
				end if;
			elsif(move ="10")then
				if((x(0)>x(15))and (y(0)=y(15)) and (startW=0))then
					y((startW+1) mod 16)<= y(startW)+10;
					x((startW+1) mod 16)<= x(startW);
				elsif((x(startW)>x(startW-1))and (y(startW)=y(startW-1)))then
					y((startW+1) mod 16)<= y(startW)+10;
					x((startW+1) mod 16)<= x(startW);
				elsif((y(0)>y(15))and (x(0)=x(15)) and (startW=0))then
					x((startW+1) mod 16)<= x(startW)-10;
					y((startW+1) mod 16)<= y(startW);
				elsif((y(startW)>y(startW-1))and (x(startW)=x(startW-1)))then
					x((startW+1) mod 16)<= x(startW)-10;
					y((startW+1) mod 16)<= y(startW);
				elsif((y(0)<y(15))and (x(0)=x(15)) and (startW=0))then
					x((startW+1) mod 16)<= x(startW)+10;
					y((startW+1) mod 16)<= y(startW);
				elsif((y(startW)<y(startW-1))and (x(startW)=x(startW-1)))then
					x((startW+1) mod 16)<= x(startW)+10;
					y((startW+1) mod 16)<= y(startW);
				elsif((x(0)<x(15))and (y(0)=y(15)) and (startW=0))then
					y((startW+1) mod 16)<= y(startW)-10;
					x((startW+1) mod 16)<= x(startW);
				elsif((x(startW)<x(startW-1))and (y(startW)=y(startW-1)))then
					y((startW+1) mod 16)<= y(startW)-10;
					x((startW+1) mod 16)<= x(startW);
				else
					x((startW+1) mod 16)<= x(startW)+10;
					y((startW+1) mod 16)<= y(startW);
				end if;
			end if;
				startW <= ((startW+1) mod 16);
				show((startW+1) mod 16) <= '1';
				if((x(startW)> 990 or x(startW)< 300 or y(startW)> 590 or y(startW)< 50) or
				((x(startW) >= 640 and x(startW) < 650 and (y(startW) <150 or y(startW) >= 500)) or
				(y(startW) >= 320 and y(startW) < 330 and (x(startW) <400 or x(startW) >= 900))))then
				clk_en <= '0';
				elsif ((target_x_point(target_pointer) = x(startW) ) and (target_y_point(target_pointer) = y(startW)))then
					target_pointer <= target_pointer + 1;
				else
					endW <= ((endW+1) mod 16);
					show((endW) mod 16) <= '0';
				end if;
	end if;
end process;
process (clock)
begin
	
	if rising_edge(clock) then
		if(
		(
		(pix_x > 295 and pix_x < 300) or (pix_y > 45  and pix_y < 50) or 
		(pix_x > 1000 and pix_x < 1005) or (pix_y > 600  and pix_y < 605)
		)
		or
		(
			(pix_x>=x( 0) and pix_x<x( 0)+point_size and pix_y>=y( 0) and pix_y<y( 0)+point_size and show( 0)='1') or 
			(pix_x>=x( 1) and pix_x<x( 1)+point_size and pix_y>=y( 1) and pix_y<y( 1)+point_size and show( 1)='1') or 
			(pix_x>=x( 2) and pix_x<x( 2)+point_size and pix_y>=y( 2) and pix_y<y( 2)+point_size and show( 2)='1') or 
			(pix_x>=x( 3) and pix_x<x( 3)+point_size and pix_y>=y( 3) and pix_y<y( 3)+point_size and show( 3)='1') or 
			(pix_x>=x( 4) and pix_x<x( 4)+point_size and pix_y>=y( 4) and pix_y<y( 4)+point_size and show( 4)='1') or 
			(pix_x>=x( 5) and pix_x<x( 5)+point_size and pix_y>=y( 5) and pix_y<y( 5)+point_size and show( 5)='1') or 
			(pix_x>=x( 6) and pix_x<x( 6)+point_size and pix_y>=y( 6) and pix_y<y( 6)+point_size and show( 6)='1') or 
         (pix_x>=x( 7) and pix_x<x( 7)+point_size and pix_y>=y( 7) and pix_y<y( 7)+point_size and show( 7)='1') or 
         (pix_x>=x( 8) and pix_x<x( 8)+point_size and pix_y>=y( 8) and pix_y<y( 8)+point_size and show( 8)='1') or 
         (pix_x>=x( 9) and pix_x<x( 9)+point_size and pix_y>=y( 9) and pix_y<y( 9)+point_size and show( 9)='1') or 
         (pix_x>=x(10) and pix_x<x(10)+point_size and pix_y>=y(10) and pix_y<y(10)+point_size and show(10)='1') or 
         (pix_x>=x(11) and pix_x<x(11)+point_size and pix_y>=y(11) and pix_y<y(11)+point_size and show(11)='1') or 
         (pix_x>=x(12) and pix_x<x(12)+point_size and pix_y>=y(12) and pix_y<y(12)+point_size and show(12)='1') or 
         (pix_x>=x(13) and pix_x<x(13)+point_size and pix_y>=y(13) and pix_y<y(13)+point_size and show(13)='1') or 
         (pix_x>=x(14) and pix_x<x(14)+point_size and pix_y>=y(14) and pix_y<y(14)+point_size and show(14)='1') or 
         (pix_x>=x(15) and pix_x<x(15)+point_size and pix_y>=y(15) and pix_y<y(15)+point_size and show(15)='1')  
		)
		or
		(
			pix_x>=target_x_point(target_pointer)	and pix_x<target_x_point(target_pointer)+point_size and 
			pix_y>=target_y_point(target_pointer) and pix_y<target_y_point(target_pointer)+point_size
		)
		or
		(
			clk_en = '0' and pix_x>=300 and pix_x<=1000 and pix_y>=50 and pix_y<=600
		)
		or
		(
		(pix_x > 640 and pix_x < 650 and (pix_y <150 or pix_y >500)) or
		(pix_y > 320 and pix_y < 330 and (pix_x <400 or pix_x >900))
		)
		)
		then
			text_on <= '1';
		else
			text_on <= '0';
		end if;
	end if;
end process;
	 text_rgb <= "1111111111" ;  
end Behavioral;

