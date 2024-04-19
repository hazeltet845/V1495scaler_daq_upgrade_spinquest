LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity edge_detector_tb is
end edge_detector_tb;

architecture tb of edge_detector_tb is

component edge_detector is 
port(
	clk   : in std_logic;
	pulse_in : in std_logic;
	edge  : out std_logic
	);
end component;

  signal clk        : std_logic := '0';
  signal pulse_in			: std_logic := '0';
  signal edge			: std_logic := '0';

begin
  clk   <= not clk   after 2 ns;
  
  
  
  process
  begin
  
  wait for 20 ns;
  
  pulse_in <= '1';
  wait for 20 ns;
  pulse_in <= '0';
  
  wait for 100 ns;
  
  pulse_in <= '1';
  wait for 20 ns;
  pulse_in <= '0';
  
  wait for 100 ns;
  
  assert false report "Test: OK" severity failure;
  
  end process;



  I0: edge_detector
	PORT MAP(
	 clk => clk,
    pulse_in => pulse_in,
    edge => edge);
	 
end tb;