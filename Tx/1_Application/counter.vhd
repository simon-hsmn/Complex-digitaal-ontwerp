-----------------------
--| Simon Huijsman	|--
--| 26/10/2026		|--
-----------------------
--#     COUNTER   	#--
-----------------------

-- Library
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

--This is the VHDL implementation of a binary up/down counter. It uses a two-process method, with
--one process for sequential logic and another for combinational logic. The counter has a synchronous
--reset and has an enable signal to control counting. The output of the counter is a std_logic_vector
--representing the current count value, and a divN signal indicates when the counter has reached its
--maximum or minimum value.
--@Param W:            generic parameter specifying the bit-length of the counter (default is 32 bits)
--@Input clk:          clock signal
--@Input EC:           enable clock
--@Input rst_b:        synchronous reset
--@Input sig:          direction signal (up/down)
--@Input ce:           count enable signal
--@Output count_out:   the current count value (W bits wide)
--@Output divN:        detects overflow or underflow; 1 when count exceeds max or min, 0 otherwise

-- Inputs and outputs
ENTITY counter IS
GENERIC (W :	natural	:= 32);		-- bit-length of counter (standard 32-bit)
PORT(
    clk, EC, rst_b: IN  std_logic;
    sig, ce:        IN  std_logic;
	count_out:	    OUT std_logic_vector ((W-1) DOWNTO 0);
    divN:			OUT std_logic
	);
END;

ARCHITECTURE behaviour OF counter IS
-- Constants en signals declaration
SIGNAL p_count, n_count:    std_logic_vector ((W-1) DOWNTO 0) := (OTHERS => '0');   -- signals to implement state machine for counting
SIGNAL prev_count:          std_logic_vector ((W-1) DOWNTO 0) := (OTHERS => '0');   -- signal to check overflow/underflow
CONSTANT ones:			    std_logic_vector ((W-1) DOWNTO 0) := (OTHERS => '1');   -- maximum value of the counter
CONSTANT zero:			    std_logic_vector ((W-1) DOWNTO 0) := (OTHERS => '0');   -- minimum value of the counter

BEGIN
-- Two process method (sequential and combinational)
    -- Process 1: sequential logic
    seq: PROCESS(clk)
    BEGIN
    IF rising_edge(clk) AND EC = '1' THEN
        IF (rst_b = '0') THEN p_count <= zero; prev_count <= zero;
        ELSE                  p_count <= n_count; prev_count <= p_count;
        END IF;
    END IF;
    END PROCESS seq;

    -- Process 2: combinational logic
    comb: PROCESS(p_count, ce, sig)
    BEGIN
    IF ce = '1' THEN
        IF sig = '1' THEN
            IF (p_count = zero AND prev_count = ones) THEN divN <= '1';
            ELSE    divN <= '0';
            END IF;
            n_count <= p_count + 1;
        ELSE
            IF (p_count = ones AND prev_count = zero) THEN divN <= '1';
            ELSE    divN <= '0';
            END IF;
            n_count <= p_count - 1;
        END IF;
    ELSE    n_count <= p_count; divN <= '0';
    END IF;
    count_out <= p_count;
    END PROCESS comb;
END;
