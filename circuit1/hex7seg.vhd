library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity hex7seg is
    Port (
        input : IN  STD_LOGIC_VECTOR (2 downto 0);
		  seg5,
		  seg4,
		  seg3,
		  seg2,
		  seg1,
        seg   : OUT STD_LOGIC_VECTOR (6 downto 0)
    );
end hex7seg;

architecture Behavioral of hex7seg is
begin
    process(input)
    begin
        case input is
            when "000" => seg <= "1000000"; -- 0
            when "001" => seg <= "1111001"; -- 1
            when "010" => seg <= "0100100"; -- 2 
				--when "110" => seg <= "0010010"; -- S (success)
            --when "111" => seg <= "0001110"; -- F (Failure)
            when others => seg <= "1111111"; -- Blank
        end case;
		  
		  if input(2) = '0' then
				seg5 <= "1111111";
				seg4 <= "1111111";
				seg3 <= "1111111";
				seg2 <= "1111111";
				seg1 <= "1111111";
			end if;
			
			if input = "110" then	--success
				seg5 <= "0001100"; --P
				seg4 <= "0001000"; --A
				seg3 <= "0010010"; --S
				seg2 <= "0010010"; --S
				seg1 <= "1111111"; --dash
			end if;
			
			if input = "111" then	--failure
				seg5 <= "0001110"; --F
				seg4 <= "0001000"; --A
				seg3 <= "1111001"; --I
				seg2 <= "1000111"; --L
				seg1 <= "1111111"; --dash
			end if;


    end process;
end Behavioral;
