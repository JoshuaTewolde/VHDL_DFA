-- 3-to-8 active-low binary decoder with an active-low enable.

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY dcd IS 
PORT (S: IN		STD_LOGIC_VECTOR (2 DOWNTO 0);
	   E: IN		STD_LOGIC;
		L: OUT 	STD_LOGIC_VECTOR (7 DOWNTO 0)
	  ); 
END dcd;

ARCHITECTURE Behavior OF dcd IS
BEGIN 
	L 	<=	"11111111"	WHEN 	E = '1'	 	ELSE
			"11111110"	WHEN 	S = "000"  	ELSE 
			"11111101"	WHEN 	S = "001"  	ELSE
			"11111011"	WHEN 	S = "010" 	ELSE	
			"11110111" 	WHEN 	S = "011" 	ELSE
			"11101111" 	WHEN 	S = "100" 	ELSE
			"11011111" 	WHEN 	S = "101" 	ELSE
			"10111111" 	WHEN 	S = "110" 	ELSE
			"01111111";
END Behavior;
