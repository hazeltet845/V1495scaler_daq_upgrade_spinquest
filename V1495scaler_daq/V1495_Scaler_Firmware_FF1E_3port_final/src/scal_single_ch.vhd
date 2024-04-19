-------------------------------------------------------------------------------
-- General reusable Scaler/Counter 
-- Ethan Hazelton
--
-- Description: Increase value of count at rising edge of input pulse
-------------------------------------------------------------------------------
 
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

LIBRARY work;
USE work.v1495scaler_pkg.all;
 
entity scal_single_ch is
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
end scal_single_ch;


architecture scaler_log of scal_single_ch is

component edge_detector is 
port(
	clk   : in std_logic;
	pulse_in : in std_logic;
	edge  : out std_logic
	);
end component;


   signal edge : std_logic := '0';
	signal temp : std_logic := '0';
   signal r_CNT : unsigned(scal_width - 1 downto 0) := (others => '0');  
	--signal temp: std_logic_vector(2 downto 0) := (others => '0');
	--signal enable_t : std_logic_vector(1 downto 0) := (others => '0');
	
begin
 
	 
 -- Rising edge of pulse means that the counter will increase by 1
 -- Rising edge of the reset means that the counter will be set to 0
  -- creat module multiscaler readout => setup 
  --cnt : process (input,reset,enable) is
  --begin
	--if(reset = '1') then
	--	r_CNT <= (others => '0');
	--elsif rising_edge(input) then
	--	if(enable = '1') then
	--		r_CNT <= r_CNT + 1;
	--	else 
	--	   r_CNT <= r_CNT;
	--	end if;
	--end if;
  --end process cnt;
  
  
  
--  cnt : process(clk,reset) is
--  begin
--	if(reset = '1') then
--		r_CNT <= (others => '0');
--	elsif (rising_edge(clk)) then 
--		--if(enable = '1') then
--			temp(0) <= input and enable;
--			temp(1) <= temp(0);
--			temp(2) <= not temp(1) and temp(0);
--			
--			--r_CNT <= r_CNT + temp;
--			 
--			if (temp(2) = '1') then
--			  r_CNT <= r_CNT + 1;
--			else 
--			  r_CNT <= r_CNT;
--	      end if;
--			
--		--end if;	
--			
--				
--	end if;
--	
--			
--  end process cnt;
  
  
--  cnt : process(clk) is
--  begin
--  
--  if(rising_edge(clk)) then
--	if(reset = '1') then
--		r_CNT <= (others => '0');
--	else 
--		--if(enable = '1') then
--			temp(0) <= input and enable;
--			temp(1) <= temp(0);
--			temp(2) <= not temp(1) and temp(0);
--			
--			--r_CNT <= r_CNT + temp;
--			 
--			if (temp(2) = '1') then
--			  r_CNT <= r_CNT + 1;
--			else 
--			  r_CNT <= r_CNT;
--	      end if;
--			
--		--end if;	
--			
--				
--	end if;
--  end if;
--	
--			
--  end process cnt;
  
  
  cnt : process(clk, reset) is
  begin
	if(reset = '1') then
		r_CNT <= (others => '0');
	elsif (rising_edge(clk)) then 
		--if(enable = '1') then
		   temp <= edge and enable;
			if(temp = '1') then 
				r_CNT <= r_CNT + 1;
			end if; 
		--else 
		--	r_CNT <= r_CNT;
		--end if;	
	end if;
  end process cnt;
  
  
---- -- connects the counter register to the output 
  count_data <=  std_logic_vector(r_CNT);

  
 I0: edge_detector
	PORT MAP(
	 clk => clk,
    pulse_in => input,
    edge => edge);
 
end scaler_log;