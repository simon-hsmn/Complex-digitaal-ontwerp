---------------------------
--| Simon Huijsman	    |--
--| 06/11/2026		    |--
---------------------------
--#SEVEN-SEGMENT DECODER#--
-->	     TESTBENCH	    <--
---------------------------

-- SIMULATION_TIME: 1000ns

-- Library
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY seg_dec_test IS
END seg_dec_test;

ARCHITECTURE structural OF seg_dec_test IS 

-- Unit Under Test: uut
    COMPONENT seg_dec
	    PORT(dec_in:    IN  std_logic_vector(3 DOWNTO 0);
             disp:      OUT std_logic_vector(7 DOWNTO 0);
             an:        OUT std_logic_vector(7 DOWNTO 0)
             );
    END COMPONENT;

  FOR uut: seg_dec USE ENTITY work.seg_dec(behaviour);
 
    CONSTANT period:	    time := 100 ns;
	CONSTANT delay:		    time :=  10 ns;
	SIGNAL   end_of_sim:	boolean := false;

-- Interconnection (signals - ports)
    SIGNAL clk:		std_logic;
    SIGNAL dec_in:	std_logic_vector(3 DOWNTO 0);
	SIGNAL disp:    std_logic_vector(7 DOWNTO 0);
	SIGNAL an:	    std_logic_vector(7 DOWNTO 0);
 
BEGIN
    uut : seg_dec
	PORT MAP(
        dec_in 	    => dec_in,
		disp	    => disp,
		an		    => an);

	clock : PROCESS
    BEGIN 
       clk <= '0';
       WAIT FOR period/2;
       LOOP
       clk <= '0';
       WAIT FOR period/2;
       clk <= '1';
       WAIT FOR period/2;
       EXIT WHEN end_of_sim;
       END LOOP;
       WAIT;
    END PROCESS clock;

--	Test Bench: TVI-generator
    tb_gen : PROCESS
    PROCEDURE testvector(CONSTANT stimvect : IN std_logic_vector(3 DOWNTO 0))IS
    BEGIN
	    dec_in	<= stimvect;
	    WAIT FOR period;
    END testvector;
    BEGIN
	-- testvector assignment:
	-- Bit 0: dec_in(0)
	-- Bit 1: dec_in(1)
	-- Bit 2: dec_in(2)
	-- Bit 3: dec_in(3)

	-- Small offset to simulate true asynchronous behaviour (10% offset with clock)
	WAIT FOR delay;

-- change testvector values to test the entity
	testvector("0000");
    testvector("0001");
    testvector("0010");
    testvector("0011");
    testvector("0100");
    testvector("0101");
    testvector("XXXX"); -- Invalid input to test the "others" case
    testvector("0110");
    testvector("0111");
    testvector("1000");
    testvector("1001");
    testvector("1010");
    testvector("1011");
    testvector("1100");
    testvector("1101");
    testvector("1110");
    testvector("1111");
    testvector("UUUU"); -- Invalid input to test the "others" case
-- end testvector section

    end_of_sim <= true;
    WAIT;
    END PROCESS tb_gen;
END structural;