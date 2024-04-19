--*******************************************************************
-- slow_to_fast_clk
-- Ethan Hazelton 
--  =>
--*******************************************************************
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity slow_to_fast_clk is
  port (
    fast_clk      : in  std_logic;
    slow_data     : in  std_logic;
    out_data      : out std_logic
    );
end slow_to_fast_clk;

architecture arch of slow_to_fast_clk is

  signal r1_data : std_logic := '0';
  signal r2_data : std_logic := '0';  
	
begin


process (fast_clk)
begin
	if (rising_edge(fast_clk)) then
		r1_data <= slow_data;
		r2_data <= r1_data;
   end if;
end process;

out_data <= r2_data;

--enable <= enable_sig;

 
end arch;