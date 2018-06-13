----------------------------------------------------------------------------------

--toppong v7
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_arith.all;



entity top_pong is
port
(

	clock 	: in std_logic ;
	reset 	: in std_logic ;
	hsync		: out std_logic ;
	vsync		: out std_logic ;
	rgb		: out std_logic_vector(9 downto 0 );
	
	--inp_x			: in 	std_logic_vector( 31 downto 0 );
	--inp_y			: in 	std_logic_vector( 31 downto 0 ) ;
	move			: in std_logic_vector(1 downto 0);
	target_x		: out std_logic_vector(9 downto 0);
	target_y		: out std_logic_vector(9 downto 0);
	clk_out : out std_logic
	
	
);

end top_pong;


architecture Behavioral of top_pong is


--*************************************************

component SyncModule  
port 
(
	clock 	: in std_logic ;
	reset 	: in std_logic ;
	y_cntrl	: out std_logic_vector( 9 downto 0) ;
	x_cntrl	: out std_logic_vector( 9 downto 0) ;
	h_sync	: out std_logic ;
	v_sync	: out std_logic 
) ;

end component ;

--*************************************************

--component Timer 
--port (
--		clock 	: in std_logic ;
--		reset 	: in std_logic ;
--		timer_tick : in std_logic ;
--		timer_start	: in std_logic ;
--		timer_up  : out std_logic 
--
--		);
--end component ;


--*************************************************

component pong_text is
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
	
	--inp_x			: in 	std_logic_vector( 31 downto 0 );
	--inp_y			: in 	std_logic_vector( 31 downto 0 ) ;
	move			: in std_logic_vector(1 downto 0);
	target_x		: out std_logic_vector(9 downto 0);
	target_y		: out std_logic_vector(9 downto 0);
	clk_out : out std_logic
	
	
);

end component ;

--*************************************************



--*************************************************

signal pix_x , pix_y : std_logic_vector(9 downto 0 ) ;
signal   text_on  : std_logic ;
signal text_rgb : std_logic_vector(9 downto 0);



signal rgb_reg : std_logic_vector(9 downto 0 ):= "0000000000" ;

--type state is ( new_game , play , new_ball , over ) ;
--signal curr , nxt : state ;   --Declare internal signals for all outputs of the state-machine
--signal graph_still_i	: std_logic :=  '1' ;
--signal d_inc0_i 		: std_logic := '0' ;
--signal d_inc1_i		: std_logic := '0' ;
--signal d_clr_i			: std_logic := '0' ;

--signal timer_start_i	: std_logic := '0' ;
--signal ball_reg : integer range 0 to 20 := 20 ;
--signal ball_nxt : integer range 0 to 20 ;

--signal winner_i : std_logic := '0' ;
--signal win_on_i : std_logic := '0' ; 
---------------------------------------------------


--*************************************************
begin

--timer_tick <= '1' when (pix_x = "1111111111" ) and  (pix_y = "0000000000" ) else '0' ;

	--=======================================================
   -- instantiation
   --=======================================================
	
-- instantiate video synchronization unit
vsync_unit : SyncModule  port map 
(
		clock 	=> clock , 
		reset 	=> reset , 
		y_cntrl	=> pix_y ,
		x_cntrl	=> pix_x ,
		h_sync	=> hsync , 
		v_sync	=> vsync 

) ;
      
		
-- instantiate text module
text_unit : pong_text port map  
(
		clock			=> clock ,
		reset 		=> reset ,
		pixel_x		=> pix_x , 
		pixel_y		=> pix_y ,
		
		text_rgb		=> text_rgb ,
		text_on 		=> text_on ,
	move			=> move,
	target_x		=>	target_x,
	target_y		=>	target_y,
	clk_out => clk_out
);
--
	--=======================================================
   -- rgb multiplexing circuit
   --=======================================================
	
rgb_prcss : process(text_on,text_rgb)
begin
	if ( text_on = '1'  )then 
			rgb_reg <= text_rgb ;  --  yellow background score 
	else
		   rgb_reg <= "0000000000"; 	 --  black screen 
	
	end if ;

end process ; 

   rgb <= rgb_reg ;
	
	
end Behavioral;

