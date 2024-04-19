-- ****************************************************************************
-- V1495_REFERENCE
-- Ethan Hazelton  05/24/2022
-- => COIN_REFERENCE(CAEN demo for v1495) used as template for V1495_REFERENCE
-- ----------------------------------------------------------------------------
-- Module:          V1495_REFERENCE
-- Description:     Scaler module that stores count in ASCAL(32 ch x 32 bits),
--						  BSCAL, and DSCAL for inputs from A,B, and D. Interrupts are 
--                  sent with v1495_int module. 

-- ############################################################################
-- Revision History:
--   Date         Author          Revision             Comments
-- ############################################################################

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_misc.all;  -- Use OR_REDUCE function

USE work.v1495scaler_pkg.all;

ENTITY v1495_reference IS
   PORT( 
      nLBRES      : IN     std_logic;                       -- Async Reset (active low)
      LCLK        : IN     std_logic;                       -- Local Bus Clock
      --*************************************************
      -- REGISTER INTERFACE
      --*************************************************
      REG_WREN    : IN     std_logic;                       -- Write pulse (active high)
      REG_RDEN    : IN     std_logic;                       -- Read  pulse (active high)
      REG_ADDR    : IN     std_logic_vector (15 DOWNTO 0);  -- Register address
      REG_DIN     : IN     std_logic_vector (15 DOWNTO 0);  -- Data from CAEN Local Bus
      REG_DOUT    : OUT    std_logic_vector (15 DOWNTO 0);  -- Data to   CAEN Local Bus
      USR_ACCESS  : IN     std_logic;                       -- Current register access is 
                                                            -- at user address space(Active high)
      --*************************************************
      -- V1495 Front Panel Ports (PORT A,B,C,G)
      --*************************************************
      A_DIN       : IN     std_logic_vector (31 DOWNTO 0);  -- In A (32 x LVDS/ECL)
      B_DIN       : IN     std_logic_vector (31 DOWNTO 0);  -- In B (32 x LVDS/ECL) 
      C_DOUT      : OUT    std_logic_vector (31 DOWNTO 0);  -- Out C (32 x LVDS)
      G_LEV       : OUT    std_logic;                       -- Output Level Select (NIM/TTL)
      G_DIR       : OUT    std_logic;                       -- Output Enable
      G_DOUT      : OUT    std_logic_vector (1 DOWNTO 0);   -- Out G - LEMO (2 x NIM/TTL)
      G_DIN       : IN     std_logic_vector (1 DOWNTO 0);   -- In G - LEMO (2 x NIM/TTL)
      --*************************************************
      -- A395x MEZZANINES INTERFACES (PORT D,E,F)
      --*************************************************
      -- Expansion Mezzanine Identifier:
      -- x_IDCODE :
      -- 000 : A395A (32 x IN LVDS/ECL)
      -- 001 : A395B (32 x OUT LVDS)
      -- 010 : A395C (32 x OUT ECL)
      -- 011 : A395D (8  x IN/OUT NIM/TTL)
      
      -- Expansion Mezzanine Port Signal Standard Select
      -- x_LEV : 
      --    0=>TTL,1=>NIM

      -- Expansion Mezzanine Port Direction
      -- x_DIR : 
      --    0=>OUT,1=>IN

      -- In/Out D (I/O Expansion)
      D_IDCODE    : IN     std_logic_vector ( 2 DOWNTO 0);  -- D slot mezzanine Identifier
      D_LEV       : OUT    std_logic;                       -- D slot Port Signal Level Select 
      D_DIR       : OUT    std_logic;                       -- D slot Port Direction
      D_DIN       : IN     std_logic_vector (31 DOWNTO 0);  -- D slot Data In  Bus
      D_DOUT      : OUT    std_logic_vector (31 DOWNTO 0);  -- D slot Data Out Bus
      -- In/Out E (I/O Expansion)
      E_IDCODE    : IN     std_logic_vector ( 2 DOWNTO 0);  -- E slot mezzanine Identifier
      E_LEV       : OUT    std_logic;                       -- E slot Port Signal Level Select
      E_DIR       : OUT    std_logic;                       -- E slot Port Direction
      E_DIN       : IN     std_logic_vector (31 DOWNTO 0);  -- E slot Data In  Bus
      E_DOUT      : OUT    std_logic_vector (31 DOWNTO 0);  -- E slot Data Out Bus
      -- In/Out F (I/O Expansion)
      F_IDCODE    : IN     std_logic_vector ( 2 DOWNTO 0);  -- F slot mezzanine Identifier
      F_LEV       : OUT    std_logic;                       -- F slot Port Signal Level Select
      F_DIR       : OUT    std_logic;                       -- F slot Port Direction
      F_DIN       : IN     std_logic_vector (31 DOWNTO 0);  -- F slot Data In  Bus
      F_DOUT      : OUT    std_logic_vector (31 DOWNTO 0);  -- F slot Data Out Bus
      --*************************************************
      -- DELAY LINES
      --*************************************************
      -- PDL = Programmable Delay Lines  (Step = 0.25ns / FSR = 64ns)
      -- DLO = Delay Line Oscillator     (Half Period ~ 10 ns)
      -- 3D3428 PDL (PROGRAMMABLE DELAY LINE) CONFIGURATION
      PDL_WR      : OUT    std_logic;                       -- Write Enable
      PDL_SEL     : OUT    std_logic;                       -- PDL Selection (0=>PDL0, 1=>PDL1)
      PDL_READ    : IN     std_logic_vector ( 7 DOWNTO 0);  -- Read Data
      PDL_WRITE   : OUT    std_logic_vector ( 7 DOWNTO 0);  -- Write Data
      PDL_DIR     : OUT    std_logic;                       -- Direction (0=>Write, 1=>Read)
      -- DELAY I/O
      PDL0_OUT    : IN     std_logic;                       -- Signal from PDL0 Output
      PDL1_OUT    : IN     std_logic;                       -- Signal from PDL1 Output
      DLO0_OUT    : IN     std_logic;                       -- Signal from DLO0 Output
      DLO1_OUT    : IN     std_logic;                       -- Signal from DLO1 Output
      PDL0_IN     : OUT    std_logic;                       -- Signal to   PDL0 Input
      PDL1_IN     : OUT    std_logic;                       -- Signal to   PDL1 Input
      DLO0_GATE   : OUT    std_logic;                       -- DLO0 Gate (active high)
      DLO1_GATE   : OUT    std_logic;                       -- DLO1 Gate (active high)
      --*************************************************
      -- SPARE PORTS
      --*************************************************
      SPARE_OUT    : OUT   std_logic_vector(11 downto 0);   -- SPARE Data Out 
      SPARE_IN     : IN    std_logic_vector(11 downto 0);   -- SPARE Data In
      SPARE_DIR    : OUT   std_logic_vector(11 downto 0);   -- SPARE Direction (0 => OUT, 1 => IN)   
      --*************************************************
      -- LED
      --*************************************************
      RED_PULSE       : OUT    std_logic;                   -- RED   Led Pulse (active high)
      GREEN_PULSE     : OUT    std_logic;  		-- GREEN Led Pulse (active high)
		
		---------------------------------------------------
		--INTERRUPT
		---------------------------------------------------
		nINT            : OUT std_logic;
		CLK_PLL         : IN std_logic
   );

-- Declarations

END v1495_reference ;

ARCHITECTURE rtl OF v1495_reference IS


-- Registers
signal A_MASK     : std_logic_vector(31 downto 0) := (others => '1'); -- R/W, Mask register of A that enables specific channels
signal B_MASK     : std_logic_vector(31 downto 0) := (others => '1'); -- R/W, Mask register of B that enables specific channels
signal D_MASK     : std_logic_vector(31 downto 0) := (others => '1'); -- R/W, Mask register of D that enables specific channels
signal E_MASK     : std_logic_vector(31 downto 0) := (others => '1'); -- R/W, Mask register of E that enables specific channels
signal SCRATCH    : std_logic_vector(15 downto 0) := X"BEEF"; -- R/W, Test R/W register
signal SCALER_EN_SPILL  : std_logic := '0'; --R register, Active high enables counter, when low the counter does not count (depends on BOS and EOS)
--signal SCALER_EN_VME    : std_logic := '0'; --R/W register, Active high enables counter, when low the counter does not count (depends on write to reg)
signal SCALER_RES       : std_logic := '0'; -- 5 clock cycle long reset, R/W register, Resets scalers to 0 and configure registers to default
--signal SCAL_CONTROL     : std_logic := '0'; --R/W register, '1' = SCALER_EN and SCALER_RES controlled by VME, 
                                            --'0' = SCALER_EN and SCALER_RES controlled by BOS and EOS
signal INT_CONTROL      : std_logic := '1'; -- R/W register that enables/disables the interrupt. Default enabled
signal INT_COUNT        : std_logic_vector(15 downto 0) := (others => '0');

signal ASCAL      : arr32(31 downto 0) := (others => (others => '0')); --R, Stores the count of input pulses from A
signal BSCAL      : arr32(31 downto 0) := (others => (others => '0')); --R, Stores the count of input pulses from B
signal DSCAL      : arr32(31 downto 0) := (others => (others => '0')); --R, Stores the count of input pulses from C
signal ESCAL      : arr32(31 downto 0) := (others => (others => '0')); --R, Stores the count of input pulses from D 



-- Local Signals
signal A     : std_logic_vector(31 downto 0); --A_DIN after mask
signal B     : std_logic_vector(31 downto 0);
signal D   : std_logic_vector(31 downto 0);
signal E   : std_logic_vector(31 downto 0);
signal SCALER_RES_VME   : std_logic := '0'; --Temporary signal for writing to SCALER_RES 
signal SCALER_RES_SPILL : std_logic := '0'; --Temporary signal for SCALER_RES from BOS
signal SCALER_RES_IN    : std_logic := '0'; --Temporary signal that is an input for Pulse Stretcher
signal SCALER_EN_IN     : std_logic := '0';    --Temporary signal that is an input for scaler module
signal ASCAL_SPILL      : arr32(7 downto 0) := (others => (others => '0')); -- Temp signal for readout during spill
--signal CLK_PLL          : std_logic := '0'; --200 MHz clock generated from pll
signal CLK_KHZ          : std_logic := '0';
signal BOS              : std_logic := '0'; 
signal EOS              : std_logic := '0'; 

--Scaler logic component----Ethan Hazelton 


component scal32_mult_ch is
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
end component scal32_mult_ch;


--Spill state component ---------------------------------------
component spill_state is
  port (
    clk      : in  std_logic;
    BOS      : in  std_logic;
    EOS      : in  std_logic;
    enable   : out  std_logic
    );
end component;

--scal_vme_switch component ---------------------------------------
--component scal_vme_switch is
--  port (
--    clk         : in  std_logic;
--    switch      : in  std_logic;
--	 input_0     : in  std_logic;
--	 input_1     : in  std_logic;
--	 output      : out std_logic
--    );
--end component scal_vme_switch;


--clk_divider component 40MHz to 7.5KHz -------------------------------------
component clk_divider is
  generic(
	 MAX_CNT: integer := 2667
  );
  port (
    clk_in      : in  std_logic; --40MHz
	 clk_out      : out std_logic --7.5KHz
    );
end component clk_divider;

--interrupt component -------------------------------------

component v1495_int is 
port(
   clk      : in std_logic; -- 40 MHz
	clk_KHZ  : in std_logic; -- 7.5 KHz clock from clock divider
	EOS      : in std_logic;
	enable   : in std_logic;
	switch   : in std_logic;
	int_cnt  : out std_logic_vector(15 downto 0);
	int      : out std_logic
	);
end component v1495_int;

------------------------------------------------------------

component edge_detector is 
port(
	clk   : in std_logic;
	pulse_in : in std_logic;
	edge  : out std_logic
	);
end component edge_detector;

BEGIN
	
   --*************************************************
   -- SCALER IMPLEMENTATION 
   --*************************************************

   A_SCALER_IO: scal32_mult_ch 
--	generic map(
--	 ch_num => 32
--	)
	port map(
	 clk => CLK_PLL,
	 input_vec => A,
	 reset => SCALER_RES,
	 enable=> SCALER_EN_IN,
	 count_data_arr => ASCAL);
	 
	 -- 8 channels used for readout during spill
	 ASCAL_SPILL(0) <= ASCAL(24);
    ASCAL_SPILL(1) <= ASCAL(25);
	 ASCAL_SPILL(2) <= ASCAL(26);
	 ASCAL_SPILL(3) <= ASCAL(27);
	 ASCAL_SPILL(4) <= ASCAL(28);
	 ASCAL_SPILL(5) <= ASCAL(29);
	 ASCAL_SPILL(6) <= ASCAL(30);
	 ASCAL_SPILL(7) <= ASCAL(31);
	 
	B_SCALER_IO: scal32_mult_ch 
--	generic map(
--	 ch_num => 32
--	)
	port map(
	 clk => CLK_PLL,
	 input_vec => B,
	 reset => SCALER_RES,
	 enable=> SCALER_EN_IN,
	 count_data_arr => BSCAL);
	 
	D_SCALER_IO: scal32_mult_ch 
--	generic map(
--	 ch_num => 32
--	)
	port map(
	 clk => CLK_PLL,
	 input_vec => D,
	 reset => SCALER_RES,
	 enable=> SCALER_EN_IN,
	 count_data_arr => DSCAL);
	 
--	E_SCALER_IO: scal32_mult_ch 
----	generic map(
----	 ch_num => 32
----	)
--	port map(
--	 clk => CLK_PLL,
--	 input_vec => E,
--	 reset => SCALER_RES,
--	 enable=> SCALER_EN_IN,
--	 count_data_arr => ESCAL);
	 
	 
	 --*************************************************
   -- RESET IMPLEMENTATION 
   --************************************************* 
	
		
	RES: edge_detector
   port map(
   clk => CLK_PLL,
   pulse_in => SCALER_RES_IN,
   edge   => SCALER_RES);	
		


	
	--*************************************************
   -- SPILL_STATE IMPLEMENTATION 
   --************************************************* 
   SPILL_STATE_IO: spill_state port map(
	   clk => CLK_PLL,
		BOS => BOS,
		EOS => EOS,
		enable => SCALER_EN_SPILL);
	
	
	
	--*************************************************
   -- SCAL_VME_SWITCH IMPLEMENTATION
   --*************************************************
	
	
   SCALER_EN_IN <= SCALER_EN_SPILL;
--	SWITCH_IO_EN: scal_vme_switch port map(
--	   clk     => CLK_PLL,
--		switch  => SCAL_CONTROL,
--		input_0 => SCALER_EN_SPILL,
--		input_1 => SCALER_EN_VME,
--		output  => SCALER_EN_IN);
--		
   --SCALER_RES <= SCALER_RES_SPILL;
	SCALER_RES_IN <= BOS;
--	SWITCH_IO_RES: scal_vme_switch port map(
--	   clk     => CLK_PLL,
--		switch  => SCAL_CONTROL,
--		input_0 => SCALER_RES_SPILL,
--		input_1 => SCALER_RES_VME,
--		output  => SCALER_RES_IN);
		
   --*************************************************
   -- CLK_DIVIDER IMPLEMENTATION
   --*************************************************
	KHZ_CLK: clk_divider 
	port map(
		clk_in => LCLK,
		clk_out => clk_KHZ);
	
	--*************************************************
   -- INTERRUPT IMPLEMENTATION
   --*************************************************
	INT: v1495_int port map(
	   clk => LCLK,
		clk_KHZ => clk_KHZ,
		EOS => EOS,
		enable => SCALER_EN_IN,
		switch => INT_CONTROL,
		int_cnt => INT_COUNT,
		int => nINT);
		
   --*************************************************
   -- LED PULSES
   --*************************************************
   RED_PULSE   <= EOS;
   GREEN_PULSE <= BOS;

	
   --*************************************************
   -- PORT SIGNAL STANDARD SELECTION                             
   --*************************************************
   -- Ports D,E,F,G signal standard set by register.
   D_LEV <= '0'; 
   E_LEV <= '0'; 
   

   --*************************************************
   -- PORT DIRECTION
   --*************************************************
   -- Ports D,E,F,G set by register.
   D_DIR  <= '1'; --Input
   E_DIR  <= '1'; --Input 
	

   --*************************************************
   -- PORT G DIRECTION & LEVEL
   --*************************************************   
   -- Port G direction is not user controllable.
   G_LEV <= '1'; --NIM('1') signal on output port, TTL = '0'
   G_DIR <= '1'; -- Port G is Input only ('0' = output, '1' = input)

	
   --*************************************************
   -- GATE G   
   --*************************************************
   -- G0 is driven by the scaler enable 
   -- G1 is driven by the scaler reset 
   --G_DOUT(0)  <= SCALER_EN;
   --G_DOUT(1)  <= SCALER_RES;
	
	--G is input
	--SCALER_RES_SPILL <= not G_DIN(0); --BOS
	-- G_DIN(1) is EOS
	BOS <=  A(16) or (not G_DIN(0));
	EOS <=  A(17) or (not G_DIN(1));
	
	--*************************************************
	--MASKING
   --*************************************************
	A <= A_DIN and A_MASK;
	B <= B_DIN and B_MASK;
	D <= D_DIN and D_MASK;
	E <= E_DIN and D_MASK;
	
	
   --********************************************************************************
   -- USER REGISTERS SECTION
   --********************************************************************************
	
   -- WRITE REGISTERS
   P_WREG : process(LCLK, nLBRES)
   begin
      if (nLBRES = '0') then
         A_MASK       <= X"FFFFFFFF"; -- Default : Unmasked
         B_MASK       <= X"FFFFFFFF"; -- Default : Unmasked
			D_MASK       <= X"FFFFFFFF"; -- Default : Unmasked
         E_MASK       <= X"FFFFFFFF"; -- Default : Unmasked

         SCRATCH      <= X"BEEF";
         
       elsif LCLK'event and LCLK = '1' then
         if (REG_WREN = '1') and (USR_ACCESS = '1') then
           case REG_ADDR is
             when A_AMASK_L   => A_MASK(15 downto 0)      <= REG_DIN;
             when A_AMASK_H   => A_MASK(31 downto 16)     <= REG_DIN;
             when A_BMASK_L   => B_MASK(15 downto 0)      <= REG_DIN;
             when A_BMASK_H   => B_MASK(31 downto 16)     <= REG_DIN;
				 when A_DMASK_L   => D_MASK(15 downto 0)      <= REG_DIN;
             when A_DMASK_H   => D_MASK(31 downto 16)     <= REG_DIN;
             when A_EMASK_L   => E_MASK(15 downto 0)      <= REG_DIN;
             when A_EMASK_H   => E_MASK(31 downto 16)     <= REG_DIN;
            
             when A_SCRATCH   => SCRATCH                  <= REG_DIN; 
				 
				 --when A_SCALER_EN_VME => SCALER_EN_VME            <= REG_DIN(0); 
				 --when A_SCALER_RES    => SCALER_RES_VME           <= REG_DIN(0);
				 --when A_SCAL_CONTROL  => SCAL_CONTROL             <= REG_DIN(0); 
				 
				 when A_INT_CONTROL   => INT_CONTROL              <= REG_DIN(0);
             
             when others      => null;
           end case;
--			else 
--				SCALER_RES_VME <='0'; -- self clears itself after 1 clock cycle
         end if;
       end if;
     end process;
   
     
  -- READ REGISTERS
  P_RREG: process(LCLK, nLBRES)
  begin
       if (nLBRES = '0') then
         REG_DOUT   <= (others => '0');
       elsif LCLK'event and LCLK = '1' then
         if (REG_RDEN = '1') and (USR_ACCESS = '1') then
           case REG_ADDR is
			    when A_AMASK_L     => REG_DOUT   <= A_MASK(15 downto 0);
				 when A_AMASK_H     => REG_DOUT   <= A_MASK(31 downto 16);
				 when A_BMASK_L     => REG_DOUT   <= B_MASK(15 downto 0);
				 when A_BMASK_H     => REG_DOUT   <= B_MASK(31 downto 16);
				 when A_DMASK_L     => REG_DOUT   <= D_MASK(15 downto 0);
				 when A_DMASK_H     => REG_DOUT   <= D_MASK(31 downto 16);
				 when A_EMASK_L     => REG_DOUT   <= E_MASK(15 downto 0);
				 when A_EMASK_H     => REG_DOUT   <= E_MASK(31 downto 16);
				 
             when A_SCRATCH     => REG_DOUT   <= SCRATCH; 
             when A_REVISION    => REG_DOUT   <= REVISION;
				 --when A_SCALER_EN_VME   => REG_DOUT(15 downto 1) <=(others=>'0'); REG_DOUT(0) <=SCALER_EN_VME;
				 when A_SCALER_EN_SPILL => REG_DOUT(15 downto 1) <=(others=>'0'); REG_DOUT(0) <=SCALER_EN_SPILL;
				 
				 --when A_SCAL_CONTROL    => REG_DOUT(15 downto 1) <=(others=>'0'); REG_DOUT(0) <=SCAL_CONTROL;
				 when A_INT_CONTROL     => REG_DOUT(15 downto 1) <=(others=>'0'); REG_DOUT(0) <=INT_CONTROL;
				 
				 when A_INT_COUNT       => REG_DOUT <= INT_COUNT;
				 
				 when A_D_IDCODE =>  REG_DOUT(15 downto 3) <= (others =>'0'); REG_DOUT(2 downto 0) <= D_IDCODE;
				 when A_E_IDCODE =>  REG_DOUT(15 downto 3) <= (others =>'0'); REG_DOUT(2 downto 0) <= E_IDCODE;
				 
				 when A_ASCAL_H(0)  => REG_DOUT   <= ASCAL(0)(31 downto 16); 
				 when A_ASCAL_L(0)  => REG_DOUT   <= ASCAL(0)(15 downto 0);
				 when A_ASCAL_H(1)  => REG_DOUT   <= ASCAL(1)(31 downto 16);
				 when A_ASCAL_L(1)  => REG_DOUT   <= ASCAL(1)(15 downto 0);
				 when A_ASCAL_H(2)  => REG_DOUT   <= ASCAL(2)(31 downto 16);
				 when A_ASCAL_L(2)  => REG_DOUT   <= ASCAL(2)(15 downto 0);
				 when A_ASCAL_H(3)  => REG_DOUT   <= ASCAL(3)(31 downto 16);
				 when A_ASCAL_L(3)  => REG_DOUT   <= ASCAL(3)(15 downto 0);
				 when A_ASCAL_H(4)  => REG_DOUT   <= ASCAL(4)(31 downto 16);
				 when A_ASCAL_L(4)  => REG_DOUT   <= ASCAL(4)(15 downto 0);
				 when A_ASCAL_H(5)  => REG_DOUT   <= ASCAL(5)(31 downto 16);
				 when A_ASCAL_L(5)  => REG_DOUT   <= ASCAL(5)(15 downto 0);
				 when A_ASCAL_H(6)  => REG_DOUT   <= ASCAL(6)(31 downto 16);
				 when A_ASCAL_L(6)  => REG_DOUT   <= ASCAL(6)(15 downto 0);
				 when A_ASCAL_H(7)  => REG_DOUT   <= ASCAL(7)(31 downto 16);
				 when A_ASCAL_L(7)  => REG_DOUT   <= ASCAL(7)(15 downto 0); 
				 when A_ASCAL_H(8)  => REG_DOUT   <= ASCAL(8)(31 downto 16);
				 when A_ASCAL_L(8)  => REG_DOUT   <= ASCAL(8)(15 downto 0);
				 when A_ASCAL_H(9)  => REG_DOUT   <= ASCAL(9)(31 downto 16);
				 when A_ASCAL_L(9)  => REG_DOUT   <= ASCAL(9)(15 downto 0);
				 when A_ASCAL_H(10)  => REG_DOUT   <= ASCAL(10)(31 downto 16);
				 when A_ASCAL_L(10)  => REG_DOUT   <= ASCAL(10)(15 downto 0);
				 when A_ASCAL_H(11)  => REG_DOUT   <= ASCAL(11)(31 downto 16);
				 when A_ASCAL_L(11)  => REG_DOUT   <= ASCAL(11)(15 downto 0);
				 when A_ASCAL_H(12)  => REG_DOUT   <= ASCAL(12)(31 downto 16);
				 when A_ASCAL_L(12)  => REG_DOUT   <= ASCAL(12)(15 downto 0);
				 when A_ASCAL_H(13)  => REG_DOUT   <= ASCAL(13)(31 downto 16);
				 when A_ASCAL_L(13)  => REG_DOUT   <= ASCAL(13)(15 downto 0);
				 when A_ASCAL_H(14)  => REG_DOUT   <= ASCAL(14)(31 downto 16);
				 when A_ASCAL_L(14)  => REG_DOUT   <= ASCAL(14)(15 downto 0);
				 when A_ASCAL_H(15)  => REG_DOUT   <= ASCAL(15)(31 downto 16);
				 when A_ASCAL_L(15)  => REG_DOUT   <= ASCAL(15)(15 downto 0);
				 when A_ASCAL_H(16)  => REG_DOUT   <= ASCAL(16)(31 downto 16);
				 when A_ASCAL_L(16)  => REG_DOUT   <= ASCAL(16)(15 downto 0);
				 when A_ASCAL_H(17)  => REG_DOUT   <= ASCAL(17)(31 downto 16);
				 when A_ASCAL_L(17)  => REG_DOUT   <= ASCAL(17)(15 downto 0);
				 when A_ASCAL_H(18)  => REG_DOUT   <= ASCAL(18)(31 downto 16);
				 when A_ASCAL_L(18)  => REG_DOUT   <= ASCAL(18)(15 downto 0);
				 when A_ASCAL_H(19)  => REG_DOUT   <= ASCAL(19)(31 downto 16);
				 when A_ASCAL_L(19)  => REG_DOUT   <= ASCAL(19)(15 downto 0);
				 when A_ASCAL_H(20)  => REG_DOUT   <= ASCAL(20)(31 downto 16);
				 when A_ASCAL_L(20)  => REG_DOUT   <= ASCAL(20)(15 downto 0);
				 when A_ASCAL_H(21)  => REG_DOUT   <= ASCAL(21)(31 downto 16);
				 when A_ASCAL_L(21)  => REG_DOUT   <= ASCAL(21)(15 downto 0);
				 when A_ASCAL_H(22)  => REG_DOUT   <= ASCAL(22)(31 downto 16);
				 when A_ASCAL_L(22)  => REG_DOUT   <= ASCAL(22)(15 downto 0);
				 when A_ASCAL_H(23)  => REG_DOUT   <= ASCAL(23)(31 downto 16);
				 when A_ASCAL_L(23)  => REG_DOUT   <= ASCAL(23)(15 downto 0);
				 when A_ASCAL_H(24)  => REG_DOUT   <= ASCAL_SPILL(0)(31 downto 16); --Temp registers used for readout during spill
				 when A_ASCAL_L(24)  => REG_DOUT   <= ASCAL_SPILL(0)(15 downto 0);
				 when A_ASCAL_H(25)  => REG_DOUT   <= ASCAL_SPILL(1)(31 downto 16);
				 when A_ASCAL_L(25)  => REG_DOUT   <= ASCAL_SPILL(1)(15 downto 0);
				 when A_ASCAL_H(26)  => REG_DOUT   <= ASCAL_SPILL(2)(31 downto 16);
				 when A_ASCAL_L(26)  => REG_DOUT   <= ASCAL_SPILL(2)(15 downto 0);
				 when A_ASCAL_H(27)  => REG_DOUT   <= ASCAL_SPILL(3)(31 downto 16);
				 when A_ASCAL_L(27)  => REG_DOUT   <= ASCAL_SPILL(3)(15 downto 0);
				 when A_ASCAL_H(28)  => REG_DOUT   <= ASCAL_SPILL(4)(31 downto 16);
				 when A_ASCAL_L(28)  => REG_DOUT   <= ASCAL_SPILL(4)(15 downto 0);
				 when A_ASCAL_H(29)  => REG_DOUT   <= ASCAL_SPILL(5)(31 downto 16);
				 when A_ASCAL_L(29)  => REG_DOUT   <= ASCAL_SPILL(5)(15 downto 0);
				 when A_ASCAL_H(30)  => REG_DOUT   <= ASCAL_SPILL(6)(31 downto 16);
				 when A_ASCAL_L(30)  => REG_DOUT   <= ASCAL_SPILL(6)(15 downto 0);
				 when A_ASCAL_H(31)  => REG_DOUT   <= ASCAL_SPILL(7)(31 downto 16);
				 when A_ASCAL_L(31)  => REG_DOUT   <= ASCAL_SPILL(7)(15 downto 0);
				 
				 when A_BSCAL_H(0)  => REG_DOUT   <= BSCAL(0)(31 downto 16);
				 when A_BSCAL_L(0)  => REG_DOUT   <= BSCAL(0)(15 downto 0);
				 when A_BSCAL_H(1)  => REG_DOUT   <= BSCAL(1)(31 downto 16);
				 when A_BSCAL_L(1)  => REG_DOUT   <= BSCAL(1)(15 downto 0);
				 when A_BSCAL_H(2)  => REG_DOUT   <= BSCAL(2)(31 downto 16);
				 when A_BSCAL_L(2)  => REG_DOUT   <= BSCAL(2)(15 downto 0);
				 when A_BSCAL_H(3)  => REG_DOUT   <= BSCAL(3)(31 downto 16);
				 when A_BSCAL_L(3)  => REG_DOUT   <= BSCAL(3)(15 downto 0);
				 when A_BSCAL_H(4)  => REG_DOUT   <= BSCAL(4)(31 downto 16);
				 when A_BSCAL_L(4)  => REG_DOUT   <= BSCAL(4)(15 downto 0);
				 when A_BSCAL_H(5)  => REG_DOUT   <= BSCAL(5)(31 downto 16);
				 when A_BSCAL_L(5)  => REG_DOUT   <= BSCAL(5)(15 downto 0);
				 when A_BSCAL_H(6)  => REG_DOUT   <= BSCAL(6)(31 downto 16);
				 when A_BSCAL_L(6)  => REG_DOUT   <= BSCAL(6)(15 downto 0);
				 when A_BSCAL_H(7)  => REG_DOUT   <= BSCAL(7)(31 downto 16);
				 when A_BSCAL_L(7)  => REG_DOUT   <= BSCAL(7)(15 downto 0);
				 when A_BSCAL_H(8)  => REG_DOUT   <= BSCAL(8)(31 downto 16);
				 when A_BSCAL_L(8)  => REG_DOUT   <= BSCAL(8)(15 downto 0);
				 when A_BSCAL_H(9)  => REG_DOUT   <= BSCAL(9)(31 downto 16);
				 when A_BSCAL_L(9)  => REG_DOUT   <= BSCAL(9)(15 downto 0);
				 when A_BSCAL_H(10)  => REG_DOUT   <= BSCAL(10)(31 downto 16);
				 when A_BSCAL_L(10)  => REG_DOUT   <= BSCAL(10)(15 downto 0);
				 when A_BSCAL_H(11)  => REG_DOUT   <= BSCAL(11)(31 downto 16);
				 when A_BSCAL_L(11)  => REG_DOUT   <= BSCAL(11)(15 downto 0);
				 when A_BSCAL_H(12)  => REG_DOUT   <= BSCAL(12)(31 downto 16);
				 when A_BSCAL_L(12)  => REG_DOUT   <= BSCAL(12)(15 downto 0);
				 when A_BSCAL_H(13)  => REG_DOUT   <= BSCAL(13)(31 downto 16);
				 when A_BSCAL_L(13)  => REG_DOUT   <= BSCAL(13)(15 downto 0);
				 when A_BSCAL_H(14)  => REG_DOUT   <= BSCAL(14)(31 downto 16);
				 when A_BSCAL_L(14)  => REG_DOUT   <= BSCAL(14)(15 downto 0);
				 when A_BSCAL_H(15)  => REG_DOUT   <= BSCAL(15)(31 downto 16);
				 when A_BSCAL_L(15)  => REG_DOUT   <= BSCAL(15)(15 downto 0);
				 when A_BSCAL_H(16)  => REG_DOUT   <= BSCAL(16)(31 downto 16);
				 when A_BSCAL_L(16)  => REG_DOUT   <= BSCAL(16)(15 downto 0);
				 when A_BSCAL_H(17)  => REG_DOUT   <= BSCAL(17)(31 downto 16);
				 when A_BSCAL_L(17)  => REG_DOUT   <= BSCAL(17)(15 downto 0);
				 when A_BSCAL_H(18)  => REG_DOUT   <= BSCAL(18)(31 downto 16);
				 when A_BSCAL_L(18)  => REG_DOUT   <= BSCAL(18)(15 downto 0);
				 when A_BSCAL_H(19)  => REG_DOUT   <= BSCAL(19)(31 downto 16);
				 when A_BSCAL_L(19)  => REG_DOUT   <= BSCAL(19)(15 downto 0);
				 when A_BSCAL_H(20)  => REG_DOUT   <= BSCAL(20)(31 downto 16);
				 when A_BSCAL_L(20)  => REG_DOUT   <= BSCAL(20)(15 downto 0);
				 when A_BSCAL_H(21)  => REG_DOUT   <= BSCAL(21)(31 downto 16);
				 when A_BSCAL_L(21)  => REG_DOUT   <= BSCAL(21)(15 downto 0);
				 when A_BSCAL_H(22)  => REG_DOUT   <= BSCAL(22)(31 downto 16);
				 when A_BSCAL_L(22)  => REG_DOUT   <= BSCAL(22)(15 downto 0);
				 when A_BSCAL_H(23)  => REG_DOUT   <= BSCAL(23)(31 downto 16);
				 when A_BSCAL_L(23)  => REG_DOUT   <= BSCAL(23)(15 downto 0);
				 when A_BSCAL_H(24)  => REG_DOUT   <= BSCAL(24)(31 downto 16);
				 when A_BSCAL_L(24)  => REG_DOUT   <= BSCAL(24)(15 downto 0);
				 when A_BSCAL_H(25)  => REG_DOUT   <= BSCAL(25)(31 downto 16);
				 when A_BSCAL_L(25)  => REG_DOUT   <= BSCAL(25)(15 downto 0);
				 when A_BSCAL_H(26)  => REG_DOUT   <= BSCAL(26)(31 downto 16);
				 when A_BSCAL_L(26)  => REG_DOUT   <= BSCAL(26)(15 downto 0);
				 when A_BSCAL_H(27)  => REG_DOUT   <= BSCAL(27)(31 downto 16);
				 when A_BSCAL_L(27)  => REG_DOUT   <= BSCAL(27)(15 downto 0);
				 when A_BSCAL_H(28)  => REG_DOUT   <= BSCAL(28)(31 downto 16);
				 when A_BSCAL_L(28)  => REG_DOUT   <= BSCAL(28)(15 downto 0);
				 when A_BSCAL_H(29)  => REG_DOUT   <= BSCAL(29)(31 downto 16);
				 when A_BSCAL_L(29)  => REG_DOUT   <= BSCAL(29)(15 downto 0);
				 when A_BSCAL_H(30)  => REG_DOUT   <= BSCAL(30)(31 downto 16);
				 when A_BSCAL_L(30)  => REG_DOUT   <= BSCAL(30)(15 downto 0);
				 when A_BSCAL_H(31)  => REG_DOUT   <= BSCAL(31)(31 downto 16);
				 when A_BSCAL_L(31)  => REG_DOUT   <= BSCAL(31)(15 downto 0);
				 
				 when A_DSCAL_H(0)  => REG_DOUT   <= DSCAL(0)(31 downto 16);
				 when A_DSCAL_L(0)  => REG_DOUT   <= DSCAL(0)(15 downto 0);
				 when A_DSCAL_H(1)  => REG_DOUT   <= DSCAL(1)(31 downto 16);
				 when A_DSCAL_L(1)  => REG_DOUT   <= DSCAL(1)(15 downto 0);
				 when A_DSCAL_H(2)  => REG_DOUT   <= DSCAL(2)(31 downto 16);
				 when A_DSCAL_L(2)  => REG_DOUT   <= DSCAL(2)(15 downto 0);
				 when A_DSCAL_H(3)  => REG_DOUT   <= DSCAL(3)(31 downto 16);
				 when A_DSCAL_L(3)  => REG_DOUT   <= DSCAL(3)(15 downto 0);
				 when A_DSCAL_H(4)  => REG_DOUT   <= DSCAL(4)(31 downto 16);
				 when A_DSCAL_L(4)  => REG_DOUT   <= DSCAL(4)(15 downto 0);
				 when A_DSCAL_H(5)  => REG_DOUT   <= DSCAL(5)(31 downto 16);
				 when A_DSCAL_L(5)  => REG_DOUT   <= DSCAL(5)(15 downto 0);
				 when A_DSCAL_H(6)  => REG_DOUT   <= DSCAL(6)(31 downto 16);
				 when A_DSCAL_L(6)  => REG_DOUT   <= DSCAL(6)(15 downto 0);
				 when A_DSCAL_H(7)  => REG_DOUT   <= DSCAL(7)(31 downto 16);
				 when A_DSCAL_L(7)  => REG_DOUT   <= DSCAL(7)(15 downto 0);
				 when A_DSCAL_H(8)  => REG_DOUT   <= DSCAL(8)(31 downto 16);
				 when A_DSCAL_L(8)  => REG_DOUT   <= DSCAL(8)(15 downto 0);
				 when A_DSCAL_H(9)  => REG_DOUT   <= DSCAL(9)(31 downto 16);
				 when A_DSCAL_L(9)  => REG_DOUT   <= DSCAL(9)(15 downto 0);
				 when A_DSCAL_H(10)  => REG_DOUT   <= DSCAL(10)(31 downto 16);
				 when A_DSCAL_L(10)  => REG_DOUT   <= DSCAL(10)(15 downto 0);
				 when A_DSCAL_H(11)  => REG_DOUT   <= DSCAL(11)(31 downto 16);
				 when A_DSCAL_L(11)  => REG_DOUT   <= DSCAL(11)(15 downto 0);
				 when A_DSCAL_H(12)  => REG_DOUT   <= DSCAL(12)(31 downto 16);
				 when A_DSCAL_L(12)  => REG_DOUT   <= DSCAL(12)(15 downto 0);
				 when A_DSCAL_H(13)  => REG_DOUT   <= DSCAL(13)(31 downto 16);
				 when A_DSCAL_L(13)  => REG_DOUT   <= DSCAL(13)(15 downto 0);
				 when A_DSCAL_H(14)  => REG_DOUT   <= DSCAL(14)(31 downto 16);
				 when A_DSCAL_L(14)  => REG_DOUT   <= DSCAL(14)(15 downto 0);
				 when A_DSCAL_H(15)  => REG_DOUT   <= DSCAL(15)(31 downto 16);
				 when A_DSCAL_L(15)  => REG_DOUT   <= DSCAL(15)(15 downto 0);
				 when A_DSCAL_H(16)  => REG_DOUT   <= DSCAL(16)(31 downto 16);
				 when A_DSCAL_L(16)  => REG_DOUT   <= DSCAL(16)(15 downto 0);
				 when A_DSCAL_H(17)  => REG_DOUT   <= DSCAL(17)(31 downto 16);
				 when A_DSCAL_L(17)  => REG_DOUT   <= DSCAL(17)(15 downto 0);
				 when A_DSCAL_H(18)  => REG_DOUT   <= DSCAL(18)(31 downto 16);
				 when A_DSCAL_L(18)  => REG_DOUT   <= DSCAL(18)(15 downto 0);
				 when A_DSCAL_H(19)  => REG_DOUT   <= DSCAL(19)(31 downto 16);
				 when A_DSCAL_L(19)  => REG_DOUT   <= DSCAL(19)(15 downto 0);
				 when A_DSCAL_H(20)  => REG_DOUT   <= DSCAL(20)(31 downto 16);
				 when A_DSCAL_L(20)  => REG_DOUT   <= DSCAL(20)(15 downto 0);
				 when A_DSCAL_H(21)  => REG_DOUT   <= DSCAL(21)(31 downto 16);
				 when A_DSCAL_L(21)  => REG_DOUT   <= DSCAL(21)(15 downto 0);
				 when A_DSCAL_H(22)  => REG_DOUT   <= DSCAL(22)(31 downto 16);
				 when A_DSCAL_L(22)  => REG_DOUT   <= DSCAL(22)(15 downto 0);
				 when A_DSCAL_H(23)  => REG_DOUT   <= DSCAL(23)(31 downto 16);
				 when A_DSCAL_L(23)  => REG_DOUT   <= DSCAL(23)(15 downto 0);
				 when A_DSCAL_H(24)  => REG_DOUT   <= DSCAL(24)(31 downto 16);
				 when A_DSCAL_L(24)  => REG_DOUT   <= DSCAL(24)(15 downto 0);
				 when A_DSCAL_H(25)  => REG_DOUT   <= DSCAL(25)(31 downto 16);
				 when A_DSCAL_L(25)  => REG_DOUT   <= DSCAL(25)(15 downto 0);
				 when A_DSCAL_H(26)  => REG_DOUT   <= DSCAL(26)(31 downto 16);
				 when A_DSCAL_L(26)  => REG_DOUT   <= DSCAL(26)(15 downto 0);
				 when A_DSCAL_H(27)  => REG_DOUT   <= DSCAL(27)(31 downto 16);
				 when A_DSCAL_L(27)  => REG_DOUT   <= DSCAL(27)(15 downto 0);
				 when A_DSCAL_H(28)  => REG_DOUT   <= DSCAL(28)(31 downto 16);
				 when A_DSCAL_L(28)  => REG_DOUT   <= DSCAL(28)(15 downto 0);
				 when A_DSCAL_H(29)  => REG_DOUT   <= DSCAL(29)(31 downto 16);
				 when A_DSCAL_L(29)  => REG_DOUT   <= DSCAL(29)(15 downto 0);
				 when A_DSCAL_H(30)  => REG_DOUT   <= DSCAL(30)(31 downto 16);
				 when A_DSCAL_L(30)  => REG_DOUT   <= DSCAL(30)(15 downto 0);
				 when A_DSCAL_H(31)  => REG_DOUT   <= DSCAL(31)(31 downto 16);
				 when A_DSCAL_L(31)  => REG_DOUT   <= DSCAL(31)(15 downto 0);
				 
				 when A_ESCAL_H(0)  => REG_DOUT   <= ESCAL(0)(31 downto 16);
				 when A_ESCAL_L(0)  => REG_DOUT   <= ESCAL(0)(15 downto 0);
				 when A_ESCAL_H(1)  => REG_DOUT   <= ESCAL(1)(31 downto 16);
				 when A_ESCAL_L(1)  => REG_DOUT   <= ESCAL(1)(15 downto 0);
				 when A_ESCAL_H(2)  => REG_DOUT   <= ESCAL(2)(31 downto 16);
				 when A_ESCAL_L(2)  => REG_DOUT   <= ESCAL(2)(15 downto 0);
				 when A_ESCAL_H(3)  => REG_DOUT   <= ESCAL(3)(31 downto 16);
				 when A_ESCAL_L(3)  => REG_DOUT   <= ESCAL(3)(15 downto 0);
				 when A_ESCAL_H(4)  => REG_DOUT   <= ESCAL(4)(31 downto 16);
				 when A_ESCAL_L(4)  => REG_DOUT   <= ESCAL(4)(15 downto 0);
				 when A_ESCAL_H(5)  => REG_DOUT   <= ESCAL(5)(31 downto 16);
				 when A_ESCAL_L(5)  => REG_DOUT   <= ESCAL(5)(15 downto 0);
				 when A_ESCAL_H(6)  => REG_DOUT   <= ESCAL(6)(31 downto 16);
				 when A_ESCAL_L(6)  => REG_DOUT   <= ESCAL(6)(15 downto 0);
				 when A_ESCAL_H(7)  => REG_DOUT   <= ESCAL(7)(31 downto 16);
				 when A_ESCAL_L(7)  => REG_DOUT   <= ESCAL(7)(15 downto 0);
				 when A_ESCAL_H(8)  => REG_DOUT   <= ESCAL(8)(31 downto 16);
				 when A_ESCAL_L(8)  => REG_DOUT   <= ESCAL(8)(15 downto 0);
				 when A_ESCAL_H(9)  => REG_DOUT   <= ESCAL(9)(31 downto 16);
				 when A_ESCAL_L(9)  => REG_DOUT   <= ESCAL(9)(15 downto 0);
				 when A_ESCAL_H(10)  => REG_DOUT   <= ESCAL(10)(31 downto 16);
				 when A_ESCAL_L(10)  => REG_DOUT   <= ESCAL(10)(15 downto 0);
				 when A_ESCAL_H(11)  => REG_DOUT   <= ESCAL(11)(31 downto 16);
				 when A_ESCAL_L(11)  => REG_DOUT   <= ESCAL(11)(15 downto 0);
				 when A_ESCAL_H(12)  => REG_DOUT   <= ESCAL(12)(31 downto 16);
				 when A_ESCAL_L(12)  => REG_DOUT   <= ESCAL(12)(15 downto 0);
				 when A_ESCAL_H(13)  => REG_DOUT   <= ESCAL(13)(31 downto 16);
				 when A_ESCAL_L(13)  => REG_DOUT   <= ESCAL(13)(15 downto 0);
				 when A_ESCAL_H(14)  => REG_DOUT   <= ESCAL(14)(31 downto 16);
				 when A_ESCAL_L(14)  => REG_DOUT   <= ESCAL(14)(15 downto 0);
				 when A_ESCAL_H(15)  => REG_DOUT   <= ESCAL(15)(31 downto 16);
				 when A_ESCAL_L(15)  => REG_DOUT   <= ESCAL(15)(15 downto 0);
				 when A_ESCAL_H(16)  => REG_DOUT   <= ESCAL(16)(31 downto 16);
				 when A_ESCAL_L(16)  => REG_DOUT   <= ESCAL(16)(15 downto 0);
				 when A_ESCAL_H(17)  => REG_DOUT   <= ESCAL(17)(31 downto 16);
				 when A_ESCAL_L(17)  => REG_DOUT   <= ESCAL(17)(15 downto 0);
				 when A_ESCAL_H(18)  => REG_DOUT   <= ESCAL(18)(31 downto 16);
				 when A_ESCAL_L(18)  => REG_DOUT   <= ESCAL(18)(15 downto 0);
				 when A_ESCAL_H(19)  => REG_DOUT   <= ESCAL(19)(31 downto 16);
				 when A_ESCAL_L(19)  => REG_DOUT   <= ESCAL(19)(15 downto 0);
				 when A_ESCAL_H(20)  => REG_DOUT   <= ESCAL(20)(31 downto 16);
				 when A_ESCAL_L(20)  => REG_DOUT   <= ESCAL(20)(15 downto 0);
				 when A_ESCAL_H(21)  => REG_DOUT   <= ESCAL(21)(31 downto 16);
				 when A_ESCAL_L(21)  => REG_DOUT   <= ESCAL(21)(15 downto 0);
				 when A_ESCAL_H(22)  => REG_DOUT   <= ESCAL(22)(31 downto 16);
				 when A_ESCAL_L(22)  => REG_DOUT   <= ESCAL(22)(15 downto 0);
				 when A_ESCAL_H(23)  => REG_DOUT   <= ESCAL(23)(31 downto 16);
				 when A_ESCAL_L(23)  => REG_DOUT   <= ESCAL(23)(15 downto 0);
				 when A_ESCAL_H(24)  => REG_DOUT   <= ESCAL(24)(31 downto 16);
				 when A_ESCAL_L(24)  => REG_DOUT   <= ESCAL(24)(15 downto 0);
				 when A_ESCAL_H(25)  => REG_DOUT   <= ESCAL(25)(31 downto 16);
				 when A_ESCAL_L(25)  => REG_DOUT   <= ESCAL(25)(15 downto 0);
				 when A_ESCAL_H(26)  => REG_DOUT   <= ESCAL(26)(31 downto 16);
				 when A_ESCAL_L(26)  => REG_DOUT   <= ESCAL(26)(15 downto 0);
				 when A_ESCAL_H(27)  => REG_DOUT   <= ESCAL(27)(31 downto 16);
				 when A_ESCAL_L(27)  => REG_DOUT   <= ESCAL(27)(15 downto 0);
				 when A_ESCAL_H(28)  => REG_DOUT   <= ESCAL(28)(31 downto 16);
				 when A_ESCAL_L(28)  => REG_DOUT   <= ESCAL(28)(15 downto 0);
				 when A_ESCAL_H(29)  => REG_DOUT   <= ESCAL(29)(31 downto 16);
				 when A_ESCAL_L(29)  => REG_DOUT   <= ESCAL(29)(15 downto 0);
				 when A_ESCAL_H(30)  => REG_DOUT   <= ESCAL(30)(31 downto 16);
				 when A_ESCAL_L(30)  => REG_DOUT   <= ESCAL(30)(15 downto 0);
				 when A_ESCAL_H(31)  => REG_DOUT   <= ESCAL(31)(31 downto 16);
				 when A_ESCAL_L(31)  => REG_DOUT   <= ESCAL(31)(15 downto 0);
             when others        => REG_DOUT   <= (others => '0');
           end case;
         end if;
       end if;
     end process;
    
   
END rtl;

