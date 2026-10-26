---------------------------
--| Simon Huijsman	    |--
--| 26/10/2026		    |--
---------------------------
--#       COUNTER       #--
-->	     TESTBENCH	    <--
---------------------------

-- SIMULATION_TIME: 5000ns

-- Library
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY counter_test IS
END counter_test;

ARCHITECTURE structural OF counter_test IS 

-- Unit Under Test: uut
    COMPONENT counter
    GENERIC (W :	natural	:= 4);		-- bit-length of counter (standard 32-bit)
	    PORT(clk, rst_b, EC:IN  std_logic;
             sig, ce:       IN  std_logic;
		     count_out:     OUT std_logic_vector(3 DOWNTO 0);
		     divN:			OUT std_logic);
    END COMPONENT;

  FOR uut: counter USE ENTITY work.counter(behaviour);
 
    CONSTANT period:	    time := 100 ns;
	CONSTANT delay:		    time :=  10 ns;
	SIGNAL   end_of_sim:	boolean := false;

-- Interconnection (signals - ports)
    SIGNAL clk:		    std_logic;
    SIGNAL rst_b:	    std_logic;
    SIGNAL EC:		    std_logic;
	SIGNAL sig:         std_logic;
	SIGNAL ce:	        std_logic;
	SIGNAL count_out:   std_logic_vector(3 DOWNTO 0);
	SIGNAL divN:		std_logic;
 
BEGIN
    uut : counter
	PORT MAP(
        clk 	    => clk,
		rst_b	    => rst_b,
		EC		    => EC,
		sig         => sig,
		ce	        => ce,
		count_out	=> count_out,
		divN		=> divN);

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
	    sig	<= stimvect(0);
        ce	<= stimvect(1);
	    WAIT FOR period;
    END testvector;
    BEGIN
	-- testvector assignment:
	-- Bit 0: sig
    -- Bit 1: ce

	-- Small offset to simulate true asynchronous behaviour (10% offset with clock)
	WAIT FOR delay;
    EC <= '1';

    -- reset for 5 clock cycles
    rst_b <= '0';
    WAIT FOR period*5;
    rst_b <= '1';

    -- start counting for 10 clock cycles
    testvector("11");
    WAIT FOR period*9;
    --stop counting and start counting down for 3 clock cycles
    testvector("01");
    testvector("00");
    testvector("10");
    WAIT FOR period*2;
    --count up for another 10 clock cycles; this should trigger the divN signal
    testvector("11");
    WAIT FOR period*9;
    -- check if divN also works when counting down
    testvector("10");
    WAIT FOR period*4;
    rst_b <= '0';
    WAIT FOR period;
    rst_b <= '1';
    testvector("11");
    WAIT FOR period*2;

    end_of_sim <= true;
    WAIT;
    END PROCESS tb_gen;
END structural;