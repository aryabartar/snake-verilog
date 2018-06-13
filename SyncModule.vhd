
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

			

entity SyncModule is
generic (

-- Video Parametrs 
-- VGA 800-by-600 sync Parametrs
-- Screen refresh rate : 60Hz
-- pixel freq : 40.0 MH 

	h_varea	: integer := 800 ; 	-- Horizontal Resulation 
	h_fporch : integer := 40 ; 	-- Horizontal Front Porch 
	h_bporch : integer := 88 ; 	-- Horizontal Back Porch 
	h_spulse : integer := 128 ;  -- Horizontal Retrac 
	h_wline  : integer := 1056 ;	-- Horizontal Whole line  
	v_varea	: integer := 600 ; 	-- Verical Resulation 
	v_fporch : integer := 1 ;   -- Vertical Front Porch
	v_bporch : integer := 23 ; 	-- Vertical Back Porch 
	v_spulse : integer := 4 ; 	-- Vertical Retrace 
	v_wline : integer := 628 	-- Vertical Whole line  

	
	
);
port 
(

	clock 	: in std_logic ;
	reset 	: in std_logic ;
	y_cntrl	: out std_logic_vector( 9 downto 0) ;
	x_cntrl	: out std_logic_vector( 9 downto 0) ;
	h_sync	: out std_logic ;
	v_sync	: out std_logic 

) ;
end SyncModule;


architecture Behavioral of SyncModule is


signal h_count: integer:=0;-- range 0 to h_wline-1;
signal v_count: integer:=0 ;---range 0 to v_wline-1;

signal h_temp: std_logic;

-- video_on_off 
signal video : std_logic ;
--signal clk : std_logic ;


begin


hsync_proc: process(clock , reset)
begin

if ( reset = '1' )then 
	
		h_count <= 0 ;
	
elsif(rising_edge(clock)) then
 
	
		h_count <= h_count+1;
		
		if(h_count = h_wline-1) then
			h_count <= 0;
		end if;
		
		if(h_count < h_spulse) then
			h_temp <= '0';
		else
			h_temp <= '1';		

		end if;	
end if;

end process;
vsync_proc: process(h_temp , clock , reset)

begin

	if ( reset = '1') then 
	
		v_count <= 0 ;

	elsif(falling_edge(h_temp)) then

	v_count <= v_count+1;
	
	if(v_count = v_wline-1) then
		v_count <= 0;
	end if;
	
	if(v_count < v_spulse) then
		v_sync <= '0';
	else
		v_sync <= '1';
		
	end if;
end if;

end process;


---- video on/off 
video <= '1' when ( h_count >=  h_spulse + h_bporch and h_count < h_spulse + h_bporch + h_varea ) and ( v_count >= v_spulse + v_bporch and v_count < v_spulse + v_bporch + v_varea )else '0' ;



---- output 
y_cntrl <= conv_std_logic_vector( v_count , 10 ) ;
x_cntrl <= conv_std_logic_vector( h_count , 10 ) ;
h_sync <= h_temp ;

--video_on <= video ;


end Behavioral;