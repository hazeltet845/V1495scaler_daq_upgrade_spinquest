LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY work;
USE work.v1495scalar_pkg.all;

entity scalar_single_ch_tb is
end scalar_single_ch_tb;

architecture tb of scalar_single_ch_tb is


component edge_detector is 
port(
	clk   : in std_logic;
	pulse_in : in std_logic;
	edge  : out std_logic
	);
end component;

component scalar_single_ch is
  generic (
    scal_width: integer := 32
  );
  port (
    clk        : in std_logic;
    input      : in std_logic;
    reset      : in std_logic;
    enable     : in std_logic;
    count_data : out  std_logic_vector(scal_width-1 downto 0)
    );
end component;

  signal clk_320       : std_logic := '0';
  
  signal reset      : std_logic := '0';
  signal enable        : std_logic := '1';
  signal input			: std_logic := '0';
  signal count_data: std_logic_vector(31 downto 0) :=(others => '0');
  
  signal edge  : std_logic := '0';

begin
  clk_320   <= not clk_320   after 3.125 ns;
  
  input <= not input after 12 ns;
  
  
  process
  begin
  ------ signals here
  wait for 500 ns;
  
  
  enable <= '0';
  
  wait for 200 ns;
  
  assert false report "Test: OK" severity failure;
  
  end process;

   I1: edge_detector
	PORT MAP(
	 clk => clk_320,
    pulse_in => input,
    edge => edge);

  I0: scalar_single_ch
	PORT MAP(
	 clk => clk_320,
    input => input,
    enable => enable,
    reset => reset,
    count_data	 => count_data);
	
end tb;