-- Test bench for hex7seg. It goes to tb1.vhd.
-- The 4 LS SWs are displayed on HEX0 as well as LEDR(3:0).

-- Fill in one blank.

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

USE work.dig1pack.all;			-- ****** This is new! It makes package available to Quartus.

ENTITY tb IS 
	PORT (MAX10_CLK1_50	: IN STD_LOGIC;
			SW 	: IN	STD_LOGIC_VECTOR (9 DOWNTO 0);
			LEDR	: OUT	STD_LOGIC_VECTOR (9 DOWNTO 0);
			KEY	: IN	STD_LOGIC_VECTOR (1 DOWNTO 0);
			HEX0,	
			HEX1, 
			HEX2, 
			HEX3, 
			HEX4, 
			HEX5 : OUT 	STD_LOGIC_VECTOR (6 DOWNTO 0)
			);		
END tb;


ARCHITECTURE Structure OF tb IS
		
		SIGNAL current_state : STD_LOGIC_VECTOR(2 downto 0);
		signal clk_btn       : STD_LOGIC;
		signal reset_btn    : STD_LOGIC;
		
BEGIN

	clk_btn    <= not KEY(0); -- pressed = '1'
	reset_btn <= not KEY(1);
	
	 -- Instantiate FSM
	fsm_inst: entity work.dfa_fsm
	  port map (
			FPGA_clk	 => MAX10_CLK1_50,
			clk       => clk_btn,        -- Step clock
			reset     => reset_btn,        -- Reset
			input_bit => SW(0),        -- Input bit
			state_out => current_state
	  );
	  
	-- Instantiate hex7seg 
	-- ********** Fill in the blank. See Figure 5 as well as component declaration for hex7seg. **********
	--decoder_0: hex7seg PORT MAP (current_state, HEX0);
	
	    decoder_inst: hex7seg
        port map (
            input => current_state,
            seg   => HEX0,
				seg1	=> HEX1,
				seg2	=>	HEX2,
				seg3	=>	HEX3,
				seg4	=>	HEX4,
				seg5	=>	HEX5
        );
	 LEDR(3) <= clk_btn;
	LEDR(2 DOWNTO 0) <= current_state; --SW(3 DOWNTO 0);	-- Display the number on 4 LEDs.
	LEDR(9 DOWNTO 4) <= "000000";			-- Make sure unsued LEDs are off.
	 
-- Turn off unused 7-segment displays
	--HEX1 <= "1111111"; 
	--HEX2 <= "1111111";
	--HEX3 <= "1111111";
	--HEX4 <= "1111111";
	--HEX5 <= "1111111";

END Structure;
