library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity dfa_fsm is
    Port (
        FPGA_clk	: in	STD_LOGIC;
		  clk       : in  STD_LOGIC;
        reset     : in  STD_LOGIC;
        input_bit : in  STD_LOGIC;
        state_out : out STD_LOGIC_VECTOR(2 downto 0)
    );
end dfa_fsm;

architecture Behavioral of dfa_fsm is
    type state_type is (S0, S1, S2);
    signal current_state, next_state : state_type;
	 signal finished : STD_LOGIC := '0';
	 signal prev_reset : STD_LOGIC := '0'; -- To detect falling edge of reset
	 signal prev_clk	:	STD_LOGIC := '0';
	 
begin

    -- State transition process
    process(FPGA_clk)
    begin
		
		if rising_edge(FPGA_clk) then
			if prev_reset = '1' AND reset = '0' then --on reset
				prev_reset <= '0';
				finished <= '0';
				current_state <= S0;
			elsif prev_reset = '0' AND reset = '1' then
				prev_reset <= '1';
				finished <= '1';
			elsif finished <= '0'  then
				--current_state <= next_state;
				prev_reset <= reset;
			end if;
			
			
			if prev_clk = '0' AND clk = '1' then --clk pressed
				current_state <= next_state;
				prev_clk <= '1';
			end if;
			
			prev_clk <= clk;
		end if;

    end process;

    -- Transition logic
    process(current_state, input_bit)
    begin
        case current_state is
            when S0 =>
                if input_bit = '0' then
                    next_state <= S1;
                else
                    next_state <= S0;
                end if;

            when S1 =>
                if input_bit = '1' then
                    next_state <= S2;  -- Accepting
                else
                    next_state <= S1;
                end if;

            when S2 =>
                if input_bit = '0' then
                    next_state <= S1;
                else
                    next_state <= S0;
                end if;

        end case;
    end process;

    -- Encode state to output
    process(current_state, finished)
    begin
		if finished = '1' then
			if current_state = S2 then
				state_out <= "110"; --success
			
			else
				state_out <= "111"; --failure
			end if;
		else
        case current_state is
            when S0       => state_out <= "000";
            when S1       => state_out <= "001";
            when S2       => state_out <= "010";
        end case;
		end if;
    end process;

end Behavioral;
