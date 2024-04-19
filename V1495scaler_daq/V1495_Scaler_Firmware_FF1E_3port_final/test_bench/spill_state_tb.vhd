LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity spill_state_tb is
end spill_state_tb;

architecture tb of spill_state_tb is

component spill_state is
  port (
    BOS      : in  std_logic;
    EOS      : in  std_logic;
    enable   : out  std_logic
    );
end component spill_state;

signal BOS    : std_logic := '0';
signal EOS    : std_logic := '0';
signal enable :std_logic;

begin

  
  process
  begin
  
  wait for 1000 ms;
  
  BOS <= '1';
  wait for 500 ms;
  BOS <= '0';
  wait for 4300 ms;
  
  EOS <= '1';
  wait for 500 ms;
  EOS <= '0'; 
  wait for 50000 ms;
  
  
  BOS <= '1';
  wait for 500 ms;
  BOS <= '0';
  wait for 4300 ms;
  
  EOS <= '1';
  wait for 500 ms;
  EOS <= '0'; 
  wait for 1000 ms;
  
  
  
  
 
  
  assert false report "Test: OK" severity failure;
  
  end process;

  I0: spill_state 
  port map (
		BOS => BOS,
		EOS => EOS,
		enable => enable
	);

	 
end tb;