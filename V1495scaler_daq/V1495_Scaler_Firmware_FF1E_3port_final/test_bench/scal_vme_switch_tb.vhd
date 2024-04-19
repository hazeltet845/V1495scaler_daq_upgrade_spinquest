LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity scal_vme_switch_tb is
end scal_vme_switch_tb;

architecture tb of scal_vme_switch_tb is

component scal_vme_switch is
  port (
    switch      : in  std_logic;
	 input_0     : in  std_logic;
	 input_1     : in  std_logic;
	 output      : out std_logic
    );
end component scal_vme_switch;

signal switch    : std_logic := '0';
signal input_0   : std_logic := '0';
signal input_1   : std_logic := '0';
signal output    : std_logic := '0';


begin

  input_0 <= not input_0 after 10 ns;
  input_1 <= not input_1 after 25 ns;
  
  process
  begin
  
  wait for 300 ns;
  
  switch <= '1';
  
  wait for 200 ns;
  
  switch <= '0';
  
  wait for 200 ns;
  

  assert false report "Test: OK" severity failure;
  
  end process;


  IO: scal_vme_switch port map(
		switch => switch,
		input_0 => input_0,
		input_1 => input_1,
		output => output);
  
	 
end tb;