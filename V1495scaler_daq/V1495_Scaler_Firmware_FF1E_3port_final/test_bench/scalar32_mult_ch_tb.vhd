LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_misc.all;
USE ieee.std_logic_unsigned.all;

LIBRARY work;
USE work.v1495scalar_pkg.all;

entity scalar32_mult_ch_tb is
generic( 
	ch_num : integer := 4
	);
end scalar32_mult_ch_tb;

architecture tb of scalar32_mult_ch_tb is

  component scalar32_mult_ch is
  generic(
	 ch_num : integer := 32
  );
  port (
    input_vec      : in  std_logic_vector(ch_num -1 downto 0);
    reset          : in std_logic;
    enable         : in std_logic;
    count_data_arr : out  arr32(ch_num - 1 downto 0)
 
    );
end component scalar32_mult_ch;

  signal reset         : std_logic := '0';
  signal enable        : std_logic := '0';
  signal input_vec     : std_logic_vector(ch_num -1 downto 0) := (others => '0');
  signal count_data_arr: arr32(ch_num - 1 downto 0) := (others =>(others => '0'));

begin

  process
  begin
  
	-- initialization 
    wait for 20 ns;
	 enable <= '1';
	 
	 wait for 100 ns;
	 

    -- Reset testing
    reset <= '1';
    wait for 5 ns;
	 reset <= '0';
	 wait for 30 ns; 
	 
	 wait for 100 ns;
	 
	 enable <= '0';
	 
	 wait for 50 ns;

	 
	 assert false report "Test: OK" severity failure;

  end process;

  --creating test pulses
  input_vec(0) <= not input_vec(0) after 5 ns;
  input_vec(1) <= not input_vec(1) after 10 ns;
  input_vec(2) <= not input_vec(2) after 20 ns;
  input_vec(3) <= not input_vec(3) after 40 ns;
	

  I0: scalar32_mult_ch 
   GENERIC MAP(
		ch_num => ch_num
	)
	PORT MAP(
    input_vec => input_vec,
    reset => reset,
    enable => enable,
    count_data_arr => count_data_arr);
	 
end tb;