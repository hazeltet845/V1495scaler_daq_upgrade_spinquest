LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity edge_detector is 
port(
	clk   : in std_logic;
	pulse_in : in std_logic;
	edge  : out std_logic
	);
end edge_detector;

architecture edge_arch of edge_detector is
	
	signal reg1 : std_logic := '0';
	signal reg2 : std_logic := '0';
	
begin
	detect: process(clk)
	begin 
		if(rising_edge(clk)) then 
			reg1 <= pulse_in;
			reg2 <= reg1;
		end if;
	end process;
	
	edge <= reg1 and (not reg2);
	
	
end edge_arch;
