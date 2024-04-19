LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_misc.all;  -- Use OR_REDUCE function

USE work.v1495scaler_pkg.all;

ENTITY v1495_reference_tb IS

END v1495_reference_tb ;



ARCHITECTURE struct OF v1495_reference_tb IS

   -- Architecture declarations

   -- Internal signal declarations
      SIGNAL nLBRES      :      std_logic := '1';                     -- Async Reset (active low)
      SIGNAL LCLK        :      std_logic := '0';                   -- Local Bus Clock
      SIGNAL REG_WREN    :      std_logic := '0';                    -- Write pulse (active high)
      SIGNAL REG_RDEN    :      std_logic := '0';                     -- Read  pulse (active high)
      SIGNAL REG_ADDR    :      std_logic_vector (15 DOWNTO 0):= X"FFFF"; -- Register address
      SIGNAL REG_DIN     :      std_logic_vector (15 DOWNTO 0):= X"0000"; -- Data from CAEN Local Bus
      SIGNAL REG_DOUT    :      std_logic_vector (15 DOWNTO 0):= X"0000"; -- Data TO   CAEN Local Bus
      SIGNAL USR_ACCESS  :      std_logic := '0';                     -- Current register access is
      SIGNAL A_DIN       :      std_logic_vector (31 DOWNTO 0):= X"00000000"; -- In A (32 x LVDS/ECL)
      SIGNAL B_DIN       :      std_logic_vector (31 DOWNTO 0):= X"00000000"; -- In B (32 x LVDS/ECL)
      SIGNAL C_DOUT      :      std_logic_vector (31 DOWNTO 0):= X"00000000"; -- Out C (32 x LVDS)
      SIGNAL G_LEV       :      std_logic := '0';                  -- Output Level Select (NIM/TTL)
      SIGNAL G_DIR       :      std_logic := '0';                    -- Output Enable
      SIGNAL G_DOUT      :      std_logic_vector (1 DOWNTO 0) := B"00";  -- Out G - LEMO (2 x NIM/TTL)
      SIGNAL G_DIN       :      std_logic_vector (1 DOWNTO 0) := B"00";  -- In G - LEMO (2 x NIM/TTL)
      SIGNAL D_IDCODE    :      std_logic_vector ( 2 DOWNTO 0):= B"000"; -- D slot mezzanine Identifier
      SIGNAL D_LEV       :      std_logic := '0';                      -- D slot Port Signal Standard Select
      SIGNAL D_DIR       :      std_logic := '0';                     -- D slot Port Direction
      SIGNAL D_DIN       :      std_logic_vector (31 DOWNTO 0):= X"00000000"; -- D slot Data In  Bus
      SIGNAL D_DOUT      :      std_logic_vector (31 DOWNTO 0):= X"00000000"; -- D slot Data Out Bus
      SIGNAL E_IDCODE    :      std_logic_vector ( 2 DOWNTO 0):= B"000";  -- E slot mezzanine Identifier
      SIGNAL E_LEV       :      std_logic := '0';                    -- E slot Port Signal Standard Select
      SIGNAL E_DIR       :      std_logic := '0';                      -- E slot Port Direction
      SIGNAL E_DIN       :      std_logic_vector (31 DOWNTO 0):= X"00000000"; -- E slot Data In  Bus
      SIGNAL E_DOUT      :      std_logic_vector (31 DOWNTO 0):= X"00000000"; -- E slot Data Out Bus
      SIGNAL F_IDCODE    :      std_logic_vector ( 2 DOWNTO 0):= B"000"; -- F slot mezzanine Identifier
      SIGNAL F_LEV       :      std_logic := '0';                      -- F slot Port Signal Standard Select
      SIGNAL F_DIR       :      std_logic := '0';                     -- F slot Port Direction
      SIGNAL F_DIN       :      std_logic_vector (31 DOWNTO 0):= X"00000000"; -- F slot Data In  Bus
      SIGNAL F_DOUT      :      std_logic_vector (31 DOWNTO 0):= X"00000000"; -- F slot Data Out Bus
      SIGNAL PDL_WR      :      std_logic := '0';                     -- Write Enable
      SIGNAL PDL_SEL     :      std_logic := '0';                      -- PDL Selection (0=>PDL0, 1=>PDL1)
      SIGNAL PDL_READ    :      std_logic_vector ( 7 DOWNTO 0) := (others => '0'); -- Read Data
      SIGNAL PDL_WRITE   :      std_logic_vector ( 7 DOWNTO 0):= (others => '0'); -- Write Data
      SIGNAL PDL_DIR     :      std_logic := '0';                     -- Direction (0=>Write, 1=>Read)
      SIGNAL PDL0_OUT    :      std_logic := '0';                      -- Signal from PDL0 Output
      SIGNAL PDL1_OUT    :      std_logic := '0';                      -- Signal from PDL1 Output
      SIGNAL DLO0_OUT    :      std_logic := '0';                      -- Signal from DLO0 Output
      SIGNAL DLO1_OUT    :      std_logic := '0';                      -- Signal from DLO1 Output
      SIGNAL PDL0_IN     :      std_logic := '0';                      -- Signal TO   PDL0 Input
      SIGNAL PDL1_IN     :      std_logic := '0';                      -- Signal TO   PDL1 Input
      SIGNAL DLO0_GATE   :      std_logic := '0';                      -- DLO0 Gate (active high)
      SIGNAL DLO1_GATE   :      std_logic := '0';                      -- DLO1 Gate (active high)
      SIGNAL SPARE_OUT   :      std_logic_vector (11 DOWNTO 0):= (others => '0'); -- SPARE Data Out
      SIGNAL SPARE_IN    :      std_logic_vector (11 DOWNTO 0):= (others => '0'); -- SPARE Data In
      SIGNAL SPARE_DIR   :      std_logic_vector (11 DOWNTO 0):= (others => '0'); -- SPARE Direction (0 => OUT, 1 => IN)
      SIGNAL RED_PULSE   :      std_logic := '0';                      -- RED   Led Pulse (active high)
      SIGNAL GREEN_PULSE :      std_logic := '0';              


   -- Component Declarations
   COMPONENT v1495_reference
   PORT (
      nLBRES      : IN     std_logic ;                     -- Async Reset (active low)
      LCLK        : IN     std_logic ;                     -- Local Bus Clock
      --*************************************************
      -- REGISTER INTERFACE
      --*************************************************
      REG_WREN    : IN     std_logic ;                     -- Write pulse (active high)
      REG_RDEN    : IN     std_logic ;                     -- Read  pulse (active high)
      REG_ADDR    : IN     std_logic_vector (15 DOWNTO 0); -- Register address
      REG_DIN     : IN     std_logic_vector (15 DOWNTO 0); -- Data from CAEN Local Bus
      REG_DOUT    : OUT    std_logic_vector (15 DOWNTO 0); -- Data TO   CAEN Local Bus
      USR_ACCESS  : IN     std_logic ;                     -- Current register access is
      -- at user address space(Active high)
      --*************************************************
      -- V1495 Front Panel Ports (PORT A,B,C,G)
      --*************************************************
      A_DIN       : IN     std_logic_vector (31 DOWNTO 0); -- In A (32 x LVDS/ECL)
      B_DIN       : IN     std_logic_vector (31 DOWNTO 0); -- In B (32 x LVDS/ECL)
      C_DOUT      : OUT    std_logic_vector (31 DOWNTO 0); -- Out C (32 x LVDS)
      G_LEV       : OUT    std_logic ;                     -- Output Level Select (NIM/TTL)
      G_DIR       : OUT    std_logic ;                     -- Output Enable
      G_DOUT      : OUT    std_logic_vector (1 DOWNTO 0);  -- Out G - LEMO (2 x NIM/TTL)
      G_DIN       : IN     std_logic_vector (1 DOWNTO 0);  -- In G - LEMO (2 x NIM/TTL)
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
      D_IDCODE    : IN     std_logic_vector ( 2 DOWNTO 0); -- D slot mezzanine Identifier
      D_LEV       : OUT    std_logic ;                     -- D slot Port Signal Standard Select
      D_DIR       : OUT    std_logic ;                     -- D slot Port Direction
      D_DIN       : IN     std_logic_vector (31 DOWNTO 0); -- D slot Data In  Bus
      D_DOUT      : OUT    std_logic_vector (31 DOWNTO 0); -- D slot Data Out Bus
      -- In/Out E (I/O Expansion)
      E_IDCODE    : IN     std_logic_vector ( 2 DOWNTO 0); -- E slot mezzanine Identifier
      E_LEV       : OUT    std_logic ;                     -- E slot Port Signal Standard Select
      E_DIR       : OUT    std_logic ;                     -- E slot Port Direction
      E_DIN       : IN     std_logic_vector (31 DOWNTO 0); -- E slot Data In  Bus
      E_DOUT      : OUT    std_logic_vector (31 DOWNTO 0); -- E slot Data Out Bus
      -- In/Out F (I/O Expansion)
      F_IDCODE    : IN     std_logic_vector ( 2 DOWNTO 0); -- F slot mezzanine Identifier
      F_LEV       : OUT    std_logic ;                     -- F slot Port Signal Standard Select
      F_DIR       : OUT    std_logic ;                     -- F slot Port Direction
      F_DIN       : IN     std_logic_vector (31 DOWNTO 0); -- F slot Data In  Bus
      F_DOUT      : OUT    std_logic_vector (31 DOWNTO 0); -- F slot Data Out Bus
      --*************************************************
      -- DELAY LINES
      --*************************************************
      -- PDL = Programmable Delay Lines  (Step = 0.25ns / FSR = 64ns)
      -- DLO = Delay Line Oscillator     (Half Period ~ 10 ns)
      -- 3D3428 PDL (PROGRAMMABLE DELAY LINE) CONFIGURATION
      PDL_WR      : OUT    std_logic ;                     -- Write Enable
      PDL_SEL     : OUT    std_logic ;                     -- PDL Selection (0=>PDL0, 1=>PDL1)
      PDL_READ    : IN     std_logic_vector ( 7 DOWNTO 0); -- Read Data
      PDL_WRITE   : OUT    std_logic_vector ( 7 DOWNTO 0); -- Write Data
      PDL_DIR     : OUT    std_logic ;                     -- Direction (0=>Write, 1=>Read)
      -- DELAY I/O
      PDL0_OUT    : IN     std_logic ;                     -- Signal from PDL0 Output
      PDL1_OUT    : IN     std_logic ;                     -- Signal from PDL1 Output
      DLO0_OUT    : IN     std_logic ;                     -- Signal from DLO0 Output
      DLO1_OUT    : IN     std_logic ;                     -- Signal from DLO1 Output
      PDL0_IN     : OUT    std_logic ;                     -- Signal TO   PDL0 Input
      PDL1_IN     : OUT    std_logic ;                     -- Signal TO   PDL1 Input
      DLO0_GATE   : OUT    std_logic ;                     -- DLO0 Gate (active high)
      DLO1_GATE   : OUT    std_logic ;                     -- DLO1 Gate (active high)
      --*************************************************
      -- SPARE PORTS
      --*************************************************
      SPARE_OUT   : OUT    std_logic_vector (11 DOWNTO 0); -- SPARE Data Out
      SPARE_IN    : IN     std_logic_vector (11 DOWNTO 0); -- SPARE Data In
      SPARE_DIR   : OUT    std_logic_vector (11 DOWNTO 0); -- SPARE Direction (0 => OUT, 1 => IN)
      --*************************************************
      -- LED
      --*************************************************
      RED_PULSE   : OUT    std_logic ;                     -- RED   Led Pulse (active high)
      GREEN_PULSE : OUT    std_logic                       -- GREEN Led Pulse (active high)
   );
   END COMPONENT;
	
   begin 
   I0 : v1495_reference
      PORT MAP (
         nLBRES      => nLBRES,
         LCLK        => LCLK,
         REG_WREN    => REG_WREN,
         REG_RDEN    => REG_RDEN,
         REG_ADDR    => REG_ADDR,
         REG_DIN     => REG_DIN,
         REG_DOUT    => REG_DOUT,
         USR_ACCESS  => USR_ACCESS,
         A_DIN       => A_DIN,
         B_DIN       => B_DIN,
         C_DOUT      => C_DOUT,
         G_LEV       => G_LEV,
         G_DIR       => G_DIR,
         G_DOUT      => G_DOUT,
         G_DIN       => G_DIN,
         D_IDCODE    => D_IDCODE,
         D_LEV       => D_LEV,
         D_DIR       => D_DIR,
         D_DIN       => D_DIN,
         D_DOUT      => D_DOUT,
         E_IDCODE    => E_IDCODE,
         E_LEV       => E_LEV,
         E_DIR       => E_DIR,
         E_DIN       => E_DIN,
         E_DOUT      => E_DOUT,
         F_IDCODE    => F_IDCODE,
         F_LEV       => F_LEV,
         F_DIR       => F_DIR,
         F_DIN       => F_DIN,
         F_DOUT      => F_DOUT,
         PDL_WR      => PDL_WR,
         PDL_SEL     => PDL_SEL,
         PDL_READ    => PDL_READ,
         PDL_WRITE   => PDL_WRITE,
         PDL_DIR     => PDL_DIR,
         PDL0_OUT    => PDL0_OUT,
         PDL1_OUT    => PDL1_OUT,
         DLO0_OUT    => DLO0_OUT,
         DLO1_OUT    => DLO1_OUT,
         PDL0_IN     => PDL0_IN,
         PDL1_IN     => PDL1_IN,
         DLO0_GATE   => DLO0_GATE,
         DLO1_GATE   => DLO1_GATE,
         SPARE_OUT   => SPARE_OUT,
         SPARE_IN    => SPARE_IN,
         SPARE_DIR   => SPARE_DIR,
         RED_PULSE   => RED_PULSE,
         GREEN_PULSE => GREEN_PULSE
			);
			
			
		--BEGIN TESTING
		LCLK <= not LCLK after 12.5 ns;
		
		A_DIN <= not A_DIN after 20 ns; 
		
  process
  begin
  
	 wait for 100 ns;
	 
	 REG_ADDR <= X"100A"; --SCAL_CONTROL
	 REG_DIN <= X"FFFF";
	 REG_WREN <= '1';
	 USR_ACCESS <= '1';
	 
	 wait for 25 ns;
	 
	 REG_ADDR <= X"1004"; --SCALER_EN_VME
	 REG_DIN <= X"FFFF";
	 REG_WREN <= '1';
	 USR_ACCESS <= '1';
	 
	 wait for 25 ns;
	 
	 REG_WREN <= '0';
	 USR_ACCESS <= '0';
	 
	 wait for 200 ns; 
	 
	 REG_ADDR <= X"1008"; --SCALER_RES
	 REG_DIN <= X"FFFF";
	 REG_WREN <= '1';
	 USR_ACCESS <= '1';
	 
	 wait for 25 ns;
	 
	 
	 REG_WREN <= '0';
	 USR_ACCESS <= '0';
	 
	 wait for 300 ns;
	 
	 REG_ADDR <= X"1004"; --SCALER_EN_VME
	 REG_DIN <= X"0000";
	 REG_WREN <= '1';
	 USR_ACCESS <= '1';
	 
	 wait for 50 ns;
	 
	 REG_ADDR <= X"100A"; --SWITCH
	 REG_DIN <= X"0000";
	 REG_WREN <= '1';
	 USR_ACCESS <= '1';
	 
	 wait for 25 ns;
	 
	 G_DIN(0) <= '1';
	 wait for 50ns;
	 G_DIN(0) <= '0';
	 
	 wait for 600 ns;
	 
	 G_DIN(1) <= '1';
	 wait for 50ns;
	 G_DIN(1) <= '0'; 
	 
	 wait for 100ns;
	 
	 
	 
	 
	 
	 assert false report "Test: OK" severity failure;

  end process;
		
			
END struct;