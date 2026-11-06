-----------------------
--| Simon Huijsman	|--
--| 06/11/2026		|--
-----------------------
--#  SEVEN SEGMENT  #--
--#     DECODER     #--
-----------------------

-- Library
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

-- The segment decoder translates a 4-bit binary input into the corresponding 7-segment display output.
-- 
-- @Param dec_in: 4-bit input signal
-- @Output disp: active-low 8-bit output signal with 7-segment data
-- @Output an: active-high 8-bit output signal to control the anodes of the 7-segment display

-- In en uitgangen
ENTITY seg_dec IS
PORT(
	dec_in:     IN  std_logic_vector (3 DOWNTO 0);
	disp:	    OUT std_logic_vector (7 DOWNTO 0);
	an:	        OUT std_logic_vector (7 DOWNTO 0)
	);
END;

ARCHITECTURE behaviour OF seg_dec IS
-- Constants en signals declaration
CONSTANT an_on: std_logic_vector (7 DOWNTO 0) := "11111110";
CONSTANT zero: 	std_logic_vector (7 DOWNTO 0) := "11000000";
CONSTANT one: 	std_logic_vector (7 DOWNTO 0) := "11111001";
CONSTANT two: 	std_logic_vector (7 DOWNTO 0) := "10100100";
CONSTANT three: std_logic_vector (7 DOWNTO 0) := "10110000";
CONSTANT four: 	std_logic_vector (7 DOWNTO 0) := "10011001";
CONSTANT five: 	std_logic_vector (7 DOWNTO 0) := "10010010";
CONSTANT six: 	std_logic_vector (7 DOWNTO 0) := "10000010";
CONSTANT seven: std_logic_vector (7 DOWNTO 0) := "11111000";
CONSTANT eight: std_logic_vector (7 DOWNTO 0) := "10000000";
CONSTANT nine: 	std_logic_vector (7 DOWNTO 0) := "10010000";
CONSTANT a: 	std_logic_vector (7 DOWNTO 0) := "10001000";
CONSTANT b: 	std_logic_vector (7 DOWNTO 0) := "10000011";
CONSTANT c: 	std_logic_vector (7 DOWNTO 0) := "11000110";
CONSTANT d: 	std_logic_vector (7 DOWNTO 0) := "10100001";
CONSTANT e: 	std_logic_vector (7 DOWNTO 0) := "10000110";
CONSTANT f: 	std_logic_vector (7 DOWNTO 0) := "10001110";
CONSTANT dash:	std_logic_vector (7 DOWNTO 0) := "10111111";

BEGIN
PROCESS (dec_in)
BEGIN
    CASE dec_in IS
        WHEN "0000" => disp <= zero;
        WHEN "0001" => disp <= one;
        WHEN "0010" => disp <= two;
        WHEN "0011" => disp <= three;
        WHEN "0100" => disp <= four;
        WHEN "0101" => disp <= five;
        WHEN "0110" => disp <= six;
        WHEN "0111" => disp <= seven;
        WHEN "1000" => disp <= eight;
        WHEN "1001" => disp <= nine;
        WHEN "1010" => disp <= a;
        WHEN "1011" => disp <= b;
        WHEN "1100" => disp <= c;
        WHEN "1101" => disp <= d;
        WHEN "1110" => disp <= e;
        WHEN "1111" => disp <= f;
        WHEN OTHERS => disp <= dash;
    END CASE;
    an <= an_on;
END PROCESS;
END;

