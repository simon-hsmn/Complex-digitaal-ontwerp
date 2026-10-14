-----------------------
--| Simon Huijsman	|--
--| 14/10/2026		|--
-----------------------
--#  FALLING EDGE   #--
--#    DETECTOR     #--
-----------------------

-- Library
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

-- In en uitgangen
ENTITY edge_det IS
PORT(
    clk:		    IN  std_logic;
	sig, rst_b, EC:	IN  std_logic;
	edge:			OUT std_logic);
END;

ARCHITECTURE behaviour OF edge_det IS
-- Constants en signals declaratie
CONSTANT s0:	std_logic_vector(1 DOWNTO 0) := "00";
CONSTANT s1:	std_logic_vector(1 DOWNTO 0) := "01";
CONSTANT p:		std_logic_vector(1 DOWNTO 0) := "10";

SIGNAL pres_state, next_state:	std_logic_vector(1 DOWNTO 0);
BEGIN

    edge_sync:	PROCESS (clk)
	BEGIN
	IF rising_edge(clk) AND EC = '1' THEN
	    IF (rst_b = '0') THEN pres_state <= s0;
	    ELSE pres_state <= next_state;
	    END IF;
	END IF;
	END PROCESS edge_sync;

    edge_comb:	PROCESS (pres_state, sig)			-- sig verandert direct, signalen veranderen pas op de klokflank, en edge dus ook...
	BEGIN
	CASE pres_state IS
	    WHEN s0 => edge <= '0';
			IF (sig = '1') THEN	next_state <= s1;
			ELSE next_state <= s0;
			END IF;
	    WHEN s1 => edge <= '0';
			IF (sig = '1') THEN	next_state <= s1;
			ELSE next_state <= p;
			END IF;
	    WHEN p  => edge <= '1';
			IF (sig = '1') THEN	next_state <= s1;
			ELSE next_state <= s0;
			END IF;
	    WHEN OTHERS =>	edge <= '0';	next_state <= s0;
	END CASE;
	END PROCESS edge_comb;

END;
