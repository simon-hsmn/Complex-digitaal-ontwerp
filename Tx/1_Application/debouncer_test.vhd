---------------------------
--| Simon Huijsman	    |--
--| 14/10/2026		    |--
---------------------------
--#     DEBOUNCER	    #--
-->	    TESTBENCH	    <--
---------------------------

-- Library
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY debounce_test IS
END debounce_test;

ARCHITECTURE structural OF debounce_test IS 

-- Unit Under Test: uut
    COMPONENT debouncer
	    GENERIC (N:	natural);
	    PORT(clk:			    IN  std_logic;
		     sig_in, rst_b, EC:	IN  std_logic;
		     sig_out_deb:		OUT std_logic);
    END COMPONENT;

  FOR uut: debouncer USE ENTITY work.debouncer(behaviour);
 
    CONSTANT period:	    time := 100 ns;
	CONSTANT delay:		    time :=  10 ns;
	SIGNAL   end_of_sim:	boolean := false;

-- Interconnection (signals - ports)
	SIGNAL clk, sig_in, rst_b, EC:	std_logic;
	SIGNAL sig_out_deb:		        std_logic;
 
BEGIN
    uut : debouncer
	GENERIC MAP(N => 4)
	PORT MAP(
        clk		    => clk,
        sig_in 		=> sig_in,
		rst_b		=> rst_b,
		EC		    => EC,
		sig_out_deb	=> sig_out_deb);

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
	    sig_in	<= stimvect(0);
	    WAIT FOR period;
    END testvector;
    BEGIN
	-- testvector assignment:
	-- Bit 1: rst_b
	-- Bit 0: sig_in

	EC <= '1';
	-- Small offset to simulate true asynchronous behaviour (10% offset with clock)
	WAIT FOR delay;

	-- Reset for 2 clockcycles
	testvector("00");
	WAIT FOR period;
      
	-- Simulate rising edge with spikes
		--> No testvector, because we want to generate an asynchronous signal with spikes
		--> The testvector would be synchronous with the clock
	rst_b <= '1';
	sig_in <= '1';
	WAIT FOR 50 ns;
	sig_in <= '0';
	WAIT FOR 30 ns;
	sig_in <= '1';
	WAIT FOR 30 ns;
	sig_in <= '0';
	WAIT FOR 10 ns;
	sig_in <= '1';
	WAIT FOR 500 ns;
	sig_in <= '0';
	WAIT FOR 800 ns;
	sig_in <= '1';
	WAIT FOR 80 ns;
	sig_in <= '0';
	WAIT FOR 40 ns;
	sig_in <= '1';
	WAIT FOR 130 ns;
	sig_in <= '0';
	WAIT FOR 60 ns;
	sig_in <= '1';
	WAIT FOR 500 ns;
	sig_in <= '0';
	WAIT FOR 50 ns;
	rst_b <= '0';
	WAIT FOR period;
	rst_b <= '1';
	sig_in <= '1';
	WAIT FOR period*20;

    end_of_sim <= true;
    WAIT;
    END PROCESS tb_gen;
END structural;