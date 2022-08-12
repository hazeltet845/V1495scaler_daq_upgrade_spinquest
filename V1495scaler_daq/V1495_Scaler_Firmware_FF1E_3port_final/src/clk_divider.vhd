--*********************************************************************************
-- 
-- Ethan Hazelton 
--  => 
--********************************************************************************
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity clk_divider is
  generic(
	 MAX_CNT: integer := 2667
  );
  port (
    clk_in      : in  std_logic; --40MHz
	 clk_out      : out std_logic --7.5KHz
    );
end clk_divider;

architecture arch of clk_divider is

	signal count : integer := 1;
	signal temp  : std_logic := '0';
	
begin

divider: process(clk_in)
begin
	if(rising_edge(clk_in)) then
		count <= count + 1;
		if(count = MAX_CNT) then
			temp <= not temp;
			count <= 1;
		end if;
	end if;
	clk_out <= temp;
end process divider;


end arch;