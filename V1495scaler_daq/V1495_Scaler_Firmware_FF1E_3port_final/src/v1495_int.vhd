LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity v1495_int is 
port(
   clk      : in std_logic; -- 40 MHz
	clk_KHZ  : in std_logic; -- 7.5 KHz clock from clock divider
	EOS      : in std_logic;
	enable   : in std_logic;
	switch   : in std_logic;
	int_cnt  : out std_logic_vector(15 downto 0);
	int      : out std_logic
	);
end v1495_int;

architecture int_arch of v1495_int is

--signal edge_EOS : std_logic := '0'; 
signal edge_KHz : std_logic := '0';
signal clk_10   : std_logic := '0';
signal clk_20   : std_logic := '0';
signal int_sig  : std_logic := '0';
signal reg      : std_logic_vector(2 downto 0) := (others => '0');
signal edge_EOS      : std_logic_vector(8 downto 0) := (others => '0');
	
	
-- FLUSH INterrupt:
type state_type is (IDLE, PULSE);
signal state      : state_type := IDLE; -- State of the FSM
signal count      : integer := 0;       -- Counter for 100 clock pulses
signal pulse_reg  : std_logic := '0';   -- Register for the pulse output	
signal flush		: std_logic := '0'; --  Flush interrupt	
	
component edge_detector is 
port(
	clk   : in std_logic;
	pulse_in : in std_logic;
	edge  : out std_logic
	);
end component edge_detector;

component scal_single_ch is
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
end component scal_single_ch;

component clk_divider is
  generic(
	 MAX_CNT: integer := 2667
  );
  port (
    clk_in      : in  std_logic; --40MHz
	 clk_out      : out std_logic --7.5KHz
    );
end component clk_divider;
	
	
begin

----------- Flush interrupt:
	process(clk_KHZ)
    begin
		if rising_edge(clk_KHZ) then
         case state is
            when IDLE =>
               pulse_reg <= '0';
               if EOS = '1' then
                  state <= PULSE;
                  count <= 0;
					end if;

             when PULSE =>
                pulse_reg <= '1';
                if count < 100 then
                   count <= count + 1;
                else
                   state <= IDLE;
                   pulse_reg <= '0';
                end if;
          end case;
        end if;
    end process;

flush <= pulse_reg;



---------------- All From Ethan:	
	process(edge_KHZ, enable, edge_EOS,switch)
	begin
		if(switch = '1') then	
			--int_sig <= (edge_KHZ and enable) or edge_EOS(0)  or edge_EOS(2) or edge_EOS(4) or edge_EOS(6) or edge_EOS(8); 
			  int_sig <= (edge_KHZ and enable) or (edge_KHZ and flush);
		else
			int_sig <= '1';
		end if;
	end process;
	
	int <= not int_sig;
	
	
	I10: edge_detector
	port map(
	clk => clk_20,
	pulse_in => EOS,
	edge => edge_EOS(0));
	
	I11: edge_detector
	port map(
	clk => clk_20,
	pulse_in => edge_EOS(0),
	edge => edge_EOS(1));
	
	I12: edge_detector
	port map(
	clk => clk_20,
	pulse_in => edge_EOS(1),
	edge => edge_EOS(2));
	
	I13: edge_detector
	port map(
	clk => clk_20,
	pulse_in => edge_EOS(2),
	edge => edge_EOS(3));
	
	I14: edge_detector
	port map(
	clk => clk_20,
	pulse_in => edge_EOS(3),
	edge => edge_EOS(4));
	
	I16: edge_detector
	port map(
	clk => clk_20,
	pulse_in => edge_EOS(4),
	edge => edge_EOS(5));
	
	I17: edge_detector
	port map(
	clk => clk_20,
	pulse_in => edge_EOS(5),
	edge => edge_EOS(6));
	
	I18: edge_detector
	port map(
	clk => clk_20,
	pulse_in => edge_EOS(6),
	edge => edge_EOS(7));
	
	I19: edge_detector
	port map(
	clk => clk_20,
	pulse_in => edge_EOS(7),
	edge => edge_EOS(8));
	
	I1: edge_detector
	port map(
	clk => clk_10,
	pulse_in => clk_KHZ,
	edge => edge_KHZ);
	
	I2: clk_divider
	generic map(
	MAX_CNT => 10
	)
	port map(
	clk_in => clk,
	clk_out => clk_10);
	
	I3: clk_divider
	generic map(
	MAX_CNT => 2000 --800
	)
	port map(
	clk_in => clk,
	clk_out => clk_20);
	
	I4: scal_single_ch 
	generic map( 
	scal_width => 16
	)
	port map(
	clk => clk,
	input => int_sig,
	reset => EOS,
	enable => enable,
	count_data => int_cnt);
	
	
	
end int_arch;