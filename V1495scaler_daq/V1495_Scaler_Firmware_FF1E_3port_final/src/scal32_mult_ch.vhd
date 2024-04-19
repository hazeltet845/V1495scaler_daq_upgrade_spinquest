-------------------------------------------------------------------------------
-- General reusable Scaler/Counter 
-- Ethan Hazelton
--
-- Description: Used to loop scal_single_ch in order to implement scaler 
-- for each channel
-------------------------------------------------------------------------------
 
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_misc.all;
USE ieee.std_logic_unsigned.all;

LIBRARY work;
USE work.v1495scaler_pkg.all;

entity scal32_mult_ch is
  --generic(
	-- ch_num : integer := 32
  --);
  port (
    clk            : in std_logic;
    input_vec      : in std_logic_vector(31 downto 0);
    reset          : in std_logic;
    enable         : in std_logic;
    count_data_arr : out  arr32(31 downto 0)
 
    );
end scal32_mult_ch;

architecture scaler_log of scal32_mult_ch is

signal enable_r : std_logic := '0';

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

--component spill_state is
--  port (
--    clk      : in  std_logic;
--    BOS      : in  std_logic;
--    EOS      : in  std_logic;
--    enable   : out std_logic
--    );
--end component spill_state;
  
begin

--   SPILL: spill_state port map(
--	 clk => clk,
--    BOS => BOS,
--	 EOS => EOS,
--	 enable => enable_r);
   enable_r <= enable;
	
	S0: scal_single_ch
	port map(
	clk => clk,
	input => input_vec(0),
	reset => reset,
	enable => enable_r,
	count_data => count_data_arr(0));
	
	S1: scal_single_ch
	port map(
	clk => clk,
	input => input_vec(1),
	reset => reset,
	enable => enable_r,
	count_data => count_data_arr(1));
	
	S2: scal_single_ch
	port map(
	clk => clk,
	input => input_vec(2),
	reset => reset,
	enable => enable_r,
	count_data => count_data_arr(2));
	
	S3: scal_single_ch
	port map(
	clk => clk,
	input => input_vec(3),
	reset => reset,
	enable => enable_r,
	count_data => count_data_arr(3));
	
	S4: scal_single_ch
	port map(
	clk => clk,
	input => input_vec(4),
	reset => reset,
	enable => enable_r,
	count_data => count_data_arr(4));
	
	S5: scal_single_ch
	port map(
	clk => clk,
	input => input_vec(5),
	reset => reset,
	enable => enable_r,
	count_data => count_data_arr(5));
	
	S6: scal_single_ch
	port map(
	clk => clk,
	input => input_vec(6),
	reset => reset,
	enable => enable_r,
	count_data => count_data_arr(6));
	
	S7: scal_single_ch
	port map(
	clk => clk,
	input => input_vec(7),
	reset => reset,
	enable => enable_r,
	count_data => count_data_arr(7));
	
	S8: scal_single_ch
	port map(
	clk => clk,
	input => input_vec(8),
	reset => reset,
	enable => enable_r,
	count_data => count_data_arr(8));
	
	S9: scal_single_ch
	port map(
	clk => clk,
	input => input_vec(9),
	reset => reset,
	enable => enable_r,
	count_data => count_data_arr(9));
	
	S10: scal_single_ch
	port map(
	clk => clk,
	input => input_vec(10),
	reset => reset,
	enable => enable_r,
	count_data => count_data_arr(10));
	
	S11: scal_single_ch
	port map(
	clk => clk,
	input => input_vec(11),
	reset => reset,
	enable => enable_r,
	count_data => count_data_arr(11));
	
	S12: scal_single_ch
	port map(
	clk => clk,
	input => input_vec(12),
	reset => reset,
	enable => enable_r,
	count_data => count_data_arr(12));
	
	S13: scal_single_ch
	port map(
	clk => clk,
	input => input_vec(13),
	reset => reset,
	enable => enable_r,
	count_data => count_data_arr(13));
	
	S14: scal_single_ch
	port map(
	clk => clk,
	input => input_vec(14),
	reset => reset,
	enable => enable_r,
	count_data => count_data_arr(14));
	
	S15: scal_single_ch
	port map(
	clk => clk,
	input => input_vec(15),
	reset => reset,
	enable => enable_r,
	count_data => count_data_arr(15));
	
	S16: scal_single_ch
	port map(
	clk => clk,
	input => input_vec(16),
	reset => reset,
	enable => enable_r,
	count_data => count_data_arr(16));
	
	S17: scal_single_ch
	port map(
	clk => clk,
	input => input_vec(17),
	reset => reset,
	enable => enable_r,
	count_data => count_data_arr(17));
	
	S18: scal_single_ch
	port map(
	clk => clk,
	input => input_vec(18),
	reset => reset,
	enable => enable_r,
	count_data => count_data_arr(18));
	
	S19: scal_single_ch
	port map(
	clk => clk,
	input => input_vec(19),
	reset => reset,
	enable => enable_r,
	count_data => count_data_arr(19));

	S20: scal_single_ch
	port map(
	clk => clk,
	input => input_vec(20),
	reset => reset,
	enable => enable_r,
	count_data => count_data_arr(20));
	
	S21: scal_single_ch
	port map(
	clk => clk,
	input => input_vec(21),
	reset => reset,
	enable => enable_r,
	count_data => count_data_arr(21));
	
	S22: scal_single_ch
	port map(
	clk => clk,
	input => input_vec(22),
	reset => reset,
	enable => enable_r,
	count_data => count_data_arr(22));
	
	S23: scal_single_ch
	port map(
	clk => clk,
	input => input_vec(23),
	reset => reset,
	enable => enable_r,
	count_data => count_data_arr(23));
	
	S24: scal_single_ch
	port map(
	clk => clk,
	input => input_vec(24),
	reset => reset,
	enable => enable_r,
	count_data => count_data_arr(24));
	
	S25: scal_single_ch
	port map(
	clk => clk,
	input => input_vec(25),
	reset => reset,
	enable => enable_r,
	count_data => count_data_arr(25));
	
	S26: scal_single_ch
	port map(
	clk => clk,
	input => input_vec(26),
	reset => reset,
	enable => enable_r,
	count_data => count_data_arr(26));
	
	S27: scal_single_ch
	port map(
	clk => clk,
	input => input_vec(27),
	reset => reset,
	enable => enable_r,
	count_data => count_data_arr(27));
	
	S28: scal_single_ch
	port map(
	clk => clk,
	input => input_vec(28),
	reset => reset,
	enable => enable_r,
	count_data => count_data_arr(28));
	
	S29: scal_single_ch
	port map(
	clk => clk,
	input => input_vec(9),
	reset => reset,
	enable => enable_r,
	count_data => count_data_arr(29));
	
	S30: scal_single_ch
	port map(
	clk => clk,
	input => input_vec(30),
	reset => reset,
	enable => enable_r,
	count_data => count_data_arr(30));
	
	S31: scal_single_ch
	port map(
	clk => clk,
	input => input_vec(31),
	reset => reset,
	enable => enable_r,
	count_data => count_data_arr(31));
	
	
--	ch_loop: for i in 0 to 31 generate
--	 ch_i: scal_single_ch
--	  PORT MAP(
--	   clk   => clk,
--      input => input_vec(i),
--      enable => enable,
--      reset => reset,
--      count_data	 => count_data_arr(i));
--	end generate ch_loop;
 
end scaler_log;