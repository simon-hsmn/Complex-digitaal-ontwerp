-----------------------
--| Simon Huijsman	|--
--| 14/10/2026		|--
-----------------------
--#	   DEBOUNCER	#--
-----------------------

-- Library
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

-- In en uitgangen
ENTITY debouncer IS
GENERIC (N:			NATURAL := 4);
PORT(
	clk, rst_b, EC:	IN  std_logic;
	sig_in:			IN  std_logic := '0';
	sig_out_deb:	OUT std_logic
	);
END;

ARCHITECTURE behaviour OF debouncer IS
-- Constants en signals declaratie
SIGNAL shift_data:	std_logic_vector((N-1) DOWNTO 0)	:= (OTHERS => sig_in);	-- shift register (voor shift)
SIGNAL shift_new:	std_logic_vector((N-1) DOWNTO 0)	:= (OTHERS => sig_in);	-- updated shift register (na shift)
SIGNAL SL:			std_logic;		-- signaal voor shift/load

BEGIN
-- 2 Process methode

    shift_reg: PROCESS(clk)
	BEGIN
	IF rising_edge(clk) AND EC = '1' THEN							-- Bij stijgende klokflank en als EC (enable clock) '1' is:
	    IF (rst_b = '0') THEN shift_data <= (OTHERS => sig_in);		-- als reset_b laag is dan resetten,
	    ELSE shift_data <= shift_new;								-- anders 1 keer shiften
	    END IF;
	END IF;
	END PROCESS shift_reg;

    comb: PROCESS(shift_data, sig_in, SL)
	BEGIN
	SL <= sig_in XOR shift_data(0);
	IF (SL = '1') THEN
	    shift_new <= NOT(shift_data(0)) & shift_data((N-1) DOWNTO 1);	-- als SL (shift/load) hoog is 1 keer doorschuiven
	ELSIF (SL = '0') THEN
	    shift_new <= (OTHERS => shift_data(0));		-- of als SL laag is het shiftregister resetten 
	END IF;
	--IF (shift_data(N-1) = shift_data(0)) THEN
	    sig_out_deb <= shift_data(0);
	--END IF;
	END PROCESS comb;
END;
