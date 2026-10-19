---------------------------
--| Simon Huijsman	    |--
--| 19/10/2026		    |--
---------------------------
--#    FALLING EDGE 	#--
--#		 DETECTOR	  	#--
-->	    TEST BENCH	    <--
---------------------------

-- SIMULATION_TIME: 2100ns

-- Library
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY edge_det_test IS
END edge_det_test;

ARCHITECTURE structural OF edge_det_test IS 

-- Unit Under Test: uut
    COMPONENT edge_det
	    PORT(clk:		        IN  std_logic;
             sig, rst_b, EC:    IN  std_logic;
		     edge:              OUT std_logic);
    END COMPONENT;

  FOR uut: edge_det USE ENTITY work.edge_det(behaviour);
 
    CONSTANT period:	    time := 100 ns;
	CONSTANT delay:		    time :=  10 ns;
	SIGNAL   end_of_sim:	boolean := false;

-- Interconnection (signals - ports)
    SIGNAL clk:	    std_logic;
	SIGNAL sig:     std_logic;
    SIGNAL rst_b:   std_logic;
    SIGNAL EC:      std_logic;
	SIGNAL edge:    std_logic;
 
BEGIN
    uut : edge_det
	PORT MAP(
        clk 	    => clk,
		sig	        => sig,
		rst_b		=> rst_b,
		EC			=> EC,
		edge		=> edge);

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
    PROCEDURE testvector(CONSTANT stimvect : IN std_logic_vector(1 DOWNTO 0))IS
    BEGIN
        rst_b	<= stimvect(1);
	    sig	    <= stimvect(0);
	    WAIT FOR period;
    END testvector;
    BEGIN
	-- testvector assignment:
    -- Bit 1: rst_b
	-- Bit 0: sig

	EC <= '1';
	-- Small offset to simulate true asynchronous behaviour (10% offset with clock)
	WAIT FOR delay;

    -- Reset for 3 clockcycles
	testvector("00");
	WAIT FOR period*2;

	testvector("11");	-- sig is '1' for 3 clockcycles
	WAIT FOR period*2;

	-- sig to '0' => edge expected
	testvector("10");
	WAIT FOR period;
      
	-- Reset
	testvector("01");      
	testvector("10");	-- this should not activate edge

	-- Try getting 3 pulses with 1 clockcycle in between
	testvector("11");
	testvector("10");
	testvector("11");
	testvector("10");
	testvector("11");
	testvector("10");

	WAIT FOR period*2;

	testvector("11");
	testvector("00");

    end_of_sim <= true;
    WAIT;
    END PROCESS tb_gen;
END structural;