-----------------------
--| Simon Huijsman	|--
--| 09/11/2026		|--
-----------------------
--#   APPLICATION  	#--
--#      LAYER    	#--
-----------------------

-- Library
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

-- This is a template for a VHDL entity. It contains the basic structure of a VHDL entity and architecture,
-- including the library declarations, entity declaration, and architecture declaration.
-- @Param sig_in: input signal of type std_logic
-- @Output sig_out: output signal of type std_logic

-- In en uitgangen
ENTITY App_Layer IS
PORT(
	clk:        IN  std_logic;
    EC:         IN  std_logic;
    rst_b:      IN  std_logic;
    btn_up:     IN  std_logic;
    btn_down:   IN  std_logic;
    data:       OUT std_logic_vector(3 DOWNTO 0);
    seg_out:    OUT std_logic_vector(7 DOWNTO 0);
    an_out:     OUT std_logic_vector(7 DOWNTO 0)
	);
END;

ARCHITECTURE behaviour OF App_Layer IS
-- Constants en signals declaration
SIGNAL deb_up:		std_logic;
SIGNAL deb_down:	std_logic;
SIGNAL edge_up:     std_logic;
SIGNAL edge_down:   std_logic;
SIGNAL ud:          std_logic;
SIGNAL ce:          std_logic;
SIGNAL count_out:   std_logic_vector(3 DOWNTO 0);

-- Components import
COMPONENT debouncer
	--GENERIC (N: NATURAL := 4);
	PORT(
		clk, EC:        IN  std_logic;
		rst_b, sig_in:  IN  std_logic;
		sig_out_deb:    OUT std_logic
	);
END COMPONENT;

COMPONENT edge_det
	PORT(
		clk, EC:        IN  std_logic;
		sig, rst_b:     IN  std_logic;
		edge:           OUT std_logic
	);
END COMPONENT;

COMPONENT counter
    GENERIC (W :	natural	:= 4);		-- bit-length of counter (standard 32-bit)
    PORT(
        clk, EC:        IN  std_logic;
        rst_b, ud, ce:  IN  std_logic;
        count_out:      OUT std_logic_vector(3 DOWNTO 0);
        divN:           OUT std_logic
    );
END COMPONENT;

COMPONENT seg_dec
	PORT(
		dec_in:         IN  std_logic_vector(3 DOWNTO 0);
		disp:           OUT std_logic_vector(7 DOWNTO 0);
		an:             OUT std_logic_vector(7 DOWNTO 0)
	);
END COMPONENT;

-- Link components to their architecture
FOR debouncer_up: debouncer     USE ENTITY work.debouncer(behaviour);
FOR debouncer_down: debouncer   USE ENTITY work.debouncer(behaviour);
FOR edge_detector_up: edge_det  USE ENTITY work.edge_det(behaviour);
FOR edge_detector_dwn: edge_det USE ENTITY work.edge_det(behaviour);
FOR data_counter: counter       USE ENTITY work.counter(behaviour);
FOR segment_decoder: seg_dec    USE ENTITY work.seg_dec(behaviour);

BEGIN
-- Component port mapping
debouncer_up : debouncer
    PORT MAP(
        clk         => clk,
        EC          => EC,
        rst_b       => rst_b,
        sig_in      => btn_up,
        sig_out_deb => deb_up);

debouncer_down : debouncer
    PORT MAP(
        clk         => clk,
        EC          => EC,
        rst_b       => rst_b,
        sig_in      => btn_down,
        sig_out_deb => deb_down);

edge_detector_up : edge_det
    PORT MAP(
        clk         => clk,
        EC          => EC,
        rst_b       => rst_b,
        sig         => deb_up,
        edge        => edge_up);

edge_detector_down : edge_det
    PORT MAP(
        clk         => clk,
        EC          => EC,
        rst_b       => rst_b,
        sig         => deb_down,
        edge        => edge_down);

data_counter : counter
    PORT MAP(
        clk         => clk,
        EC          => EC,
        rst_b       => rst_b,
        ud          => edge_up,
        ce          => edge_down,
        count_out   => count_out,
        divN        => open);

segment_decoder : seg_dec
    PORT MAP(
        dec_in      => count_out,
        disp        => seg_out,
        an          => an_out);

-- Combinatorial logic to control the counter
up_down_logic : PROCESS(edge_up, edge_down)
BEGIN
    IF (edge_up = '1') THEN
        ud <= '1'; ce <= '1';
    ELSIF (edge_down = '1') THEN
        ud <= '0'; ce <= '1';
    ELSE
        ce <= '0'; -- No change in count
    END IF;
END PROCESS up_down_logic;

data <= count_out;
END;
