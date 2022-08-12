--*********************************************************************************
-- scal_vme_switch
-- Ethan Hazelton 
--  => Switch controls whether the scaler module is using the VMEBus(switch = '0') 
--     to control the scaler module or using the BOS and EOS signals(switch = '1')
--********************************************************************************
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity scal_vme_switch is
  port (
    clk         : in  std_logic;
    switch      : in  std_logic;
	 input_0     : in  std_logic;
	 input_1     : in  std_logic;
	 output      : out std_logic
    );
end scal_vme_switch;

architecture arch of scal_vme_switch is

	signal out_sig : std_logic:= '0';
	
begin

	switch_log: process(clk)
	begin
	if(rising_edge(clk)) then
		if(switch = '0') then
			out_sig <= input_0;
		elsif(switch = '1') then 
			out_sig <= input_1;
		end if;
	end if;
	end process switch_log;
 
   output <= out_sig; 
	
end arch;