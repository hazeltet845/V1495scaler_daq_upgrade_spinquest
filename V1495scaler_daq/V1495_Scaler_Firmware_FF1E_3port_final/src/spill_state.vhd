--*******************************************************************
-- spill_state
-- Ethan Hazelton 
--  => State machine with two states: SPILL_s and IDLE_s. In the IDLE_s
--     state, the scaler module is disabled. In the SPILL_s state the
--     scaler module is enabled. BOS is the signal for the beginning
--     of the spill. EOS is the signal for the end of the spill. The 
--     state STILL_s is activated with a BOS signal and ends with an 
--     EOS signal. 
--*******************************************************************
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity spill_state is
  port (
    clk      : in  std_logic;
    BOS      : in  std_logic;
    EOS      : in  std_logic;
    enable   : out std_logic
    );
end spill_state;

architecture arch of spill_state is

signal temp_BOS : std_logic := '0'; 
signal temp_EOS : std_logic := '0'; 
signal enable_reg :std_logic := '0';
	
component edge_detector is 
port(
	clk   : in std_logic;
	pulse_in : in std_logic;
	edge  : out std_logic
	);
end component edge_detector;
	
begin

--process(clk) 
--begin
--  if(rising_edge(clk)) then
--    temp_BOS(0) <= BOS;
--	 temp_BOS(1) <= temp_BOS(0);
--	 
--	 temp_EOS(0) <= EOS;
--	 temp_EOS(1) <= temp_EOS(0);
--  end if;
--
--end process;

process (clk)
begin
	if (rising_edge(clk)) then
		if(temp_BOS = '1') then 
			enable_reg <= '1';
		elsif (temp_EOS = '1') then
			enable_reg <= '0';
      end if;
	end if;
end process;

enable <= enable_reg;

I14: edge_detector
	port map(
	clk => clk,
	pulse_in => EOS,
	edge => temp_EOS);
	
I15: edge_detector
	port map(
	clk => clk,
	pulse_in => BOS,
	edge => temp_BOS);

 
end arch;