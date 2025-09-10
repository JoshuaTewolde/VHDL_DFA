-- Add your components to this package as you get them ready:

LIBRARY ieee;
USE ieee.std_logic_1164.all;

PACKAGE dig1pack IS
    
COMPONENT hex7seg
PORT (input	: IN	STD_LOGIC_VECTOR	(2 DOWNTO 0);
		seg5,
		seg4,
		seg3,
		seg2,
		seg1,
      seg 	: OUT	STD_LOGIC_VECTOR	(6 DOWNTO 0)
	  );	
END COMPONENT;	


COMPONENT min_max IS 
PORT (A, B			: 	IN		STD_LOGIC_VECTOR (3 DOWNTO 0);
      min_max_sel	: 	IN		STD_LOGIC;							-- ‘0’ selects min
      Z				: 	OUT	STD_LOGIC_VECTOR (3 DOWNTO 0)
		); 
END COMPONENT;


COMPONENT dcd IS 
	PORT (	S	: 	IN		STD_LOGIC_VECTOR (2 DOWNTO 0);
	         	E	: 	IN 		STD_LOGIC;
			L	: 	OUT 	STD_LOGIC_VECTOR (7 DOWNTO 0)
		    ); 
END COMPONENT;

COMPONENT pri IS 
	PORT (	 R		: IN		STD_LOGIC_VECTOR (7 DOWNTO 0);
			NO_REQ	: OUT 	STD_LOGIC;
			N		: OUT 	STD_LOGIC_VECTOR (2 DOWNTO 0)
		    ); 
END COMPONENT;
	
END dig1pack;

