-- ****************************************************************************
-- Company:         CAEN SpA - Viareggio - Italy
-- Model:           V1495 -  Multipurpose Programmable Trigger Unit
-- FPGA Proj. Name: V1495USR_DEMO
-- Device:          ALTERA EP1C4F400C6
-- Author:          Luca Colombini
-- Date:            02-03-2006
-- ----------------------------------------------------------------------------
-- Module:          V1495USR_PKG
-- Description:     Package that implements global constants (ID Codes, 
--                  Register Addresses).
-- ****************************************************************************

-- ############################################################################
-- Revision History: Ethan Hazelton   05/24/2022
--        =>Removed and added registers needed for scaler logic
--        =>Added constants and array types neede for scaler logic
-- ############################################################################
LIBRARY ieee;
USE ieee.std_logic_1164.all;
PACKAGE v1495scaler_pkg IS


-- for scaler32_mult_ch-- Ethan Hazelton

type arr32 is array (natural range <>) of std_logic_vector(31 downto 0);
--------------------------------------

-------------Reset latch --------------------------------------------------------
--constant clk_cycles: integer := 25;

--Counter Registers--Ethan Hazelton----------------------------------------------
type A_count_arr is array (natural range <>) of std_logic_vector(15 downto 0);


constant A_ASCAL_H : A_count_arr(0 to 31) := 
									  (X"2000", --0 
									  	X"2004", --1 
										X"2008", --2
										X"200C", --3
										X"2010", --4
										X"2014", --5
										X"2018", --6
										X"201C", --7
										X"2020", --8
										X"2024", --9
										X"2028", --10
										X"202C", --11
										X"2030", --12
										X"2034", --13
										X"2038", --14
										X"203C", --15
									   X"2040", --16
									  	X"2044", --17
										X"2048", --18
										X"204C", --19
										X"2050", --20
										X"2054", --21
										X"2058", --22
										X"205C", --23
										X"2060", --24
										X"2064", --25
										X"2068", --26
										X"206C", --27
										X"2070", --28
										X"2074", --29
										X"2078", --30
										X"207C");--31
										
constant A_ASCAL_L : A_count_arr(0 to 31) := 
									  (X"2002", --0 
									  	X"2006", --1 
										X"200A", --2
										X"200E", --3
										X"2012", --4
										X"2016", --5
										X"201A", --6
										X"201E", --7
										X"2022", --8
										X"2026", --9
										X"202A", --10
										X"202E", --11
										X"2032", --12
										X"2036", --13
										X"203A", --14
										X"203E", --15
									   X"2042", --16
									  	X"2046", --17
										X"204A", --18
										X"204E", --19
										X"2052", --20
										X"2056", --21
										X"205A", --22
										X"205E", --23
										X"2062", --24
										X"2066", --25
										X"206A", --26
										X"206E", --27
										X"2072", --28
										X"2076", --29
										X"207A", --30
										X"207E");--31
										
constant A_BSCAL_H : A_count_arr(0 to 31) := 
									  (X"2080", --0 
									  	X"2084", --1 
										X"2088", --2
										X"208C", --3
										X"2090", --4
										X"2094", --5
										X"2098", --6
										X"209C", --7
										X"20A0", --8
										X"20A4", --9
										X"20A8", --10
										X"20AC", --11
										X"20B0", --12
										X"20B4", --13
										X"20B8", --14
										X"20BC", --15
									   X"20C0", --16
									  	X"20C4", --17
										X"20C8", --18
										X"20CC", --19
										X"20D0", --20
										X"20D4", --21
										X"20D8", --22
										X"20DC", --23
										X"20E0", --24
										X"20E4", --25
										X"20E8", --26
										X"20EC", --27
										X"20F0", --28
										X"20F4", --29
										X"20F8", --30
										X"20FC");--31
										
constant A_BSCAL_L : A_count_arr(0 to 31) := 
									  (X"2082", --0 
									  	X"2086", --1 
										X"208A", --2
										X"208E", --3
										X"2092", --4
										X"2096", --5
										X"209A", --6
										X"209E", --7
										X"20A2", --8
										X"20A6", --9
										X"20AA", --10
										X"20AE", --11
										X"20B2", --12
										X"20B6", --13
										X"20BA", --14
										X"20BE", --15
									   X"20C2", --16
									  	X"20C6", --17
										X"20CA", --18
										X"20CE", --19
										X"20D2", --20
										X"20D6", --21
										X"20DA", --22
										X"20DE", --23
										X"20E2", --24
										X"20E6", --25
										X"20EA", --26
										X"20EE", --27
										X"20F2", --28
										X"20F6", --29
										X"20FA", --30
										X"20FE");--31
										
constant A_DSCAL_H : A_count_arr(0 to 31) := 
									  (X"2100", --0 
									  	X"2104", --1 
										X"2108", --2
										X"210C", --3
										X"2110", --4
										X"2114", --5
										X"2118", --6
										X"211C", --7
										X"2120", --8
										X"2124", --9
										X"2128", --10
										X"212C", --11
										X"2130", --12
										X"2134", --13
										X"2138", --14
										X"213C", --15
									   X"2140", --16
									  	X"2144", --17
										X"2148", --18
										X"214C", --19
										X"2150", --20
										X"2154", --21
										X"2158", --22
										X"215C", --23
										X"2160", --24
										X"2164", --25
										X"2168", --26
										X"216C", --27
										X"2170", --28
										X"2174", --29
										X"2178", --30
										X"217C");--31
										
constant A_DSCAL_L : A_count_arr(0 to 31) := 
									  (X"2102", --0 
									  	X"2106", --1 
										X"210A", --2
										X"210E", --3
										X"2112", --4
										X"2116", --5
										X"211A", --6
										X"211E", --7
										X"2122", --8
										X"2126", --9
										X"212A", --10
										X"212E", --11
										X"2132", --12
										X"2136", --13
										X"213A", --14
										X"213E", --15
									   X"2142", --16
									  	X"2146", --17
										X"214A", --18
										X"214E", --19
										X"2152", --20
										X"2156", --21
										X"215A", --22
										X"215E", --23
										X"2162", --24
										X"2166", --25
										X"216A", --26
										X"216E", --27
										X"2172", --28
										X"2176", --29
										X"217A", --30
										X"217E");--31
									
constant A_ESCAL_H : A_count_arr(0 to 31) := 
									  (X"2180", --0 
									  	X"2184", --1 
										X"2188", --2
										X"218C", --3
										X"2190", --4
										X"2194", --5
										X"2198", --6
										X"219C", --7
										X"21A0", --8
										X"21A4", --9
										X"21A8", --10
										X"21AC", --11
										X"21B0", --12
										X"21B4", --13
										X"21B8", --14
										X"21BC", --15
									   X"21C0", --16
									  	X"21C4", --17
										X"21C8", --18
										X"21CC", --19
										X"21D0", --20
										X"21D4", --21
										X"21D8", --22
										X"21DC", --23
										X"21E0", --24
										X"21E4", --25
										X"21E8", --26
										X"21EC", --27
										X"21F0", --28
										X"21F4", --29
										X"21F8", --30
										X"21FC");--31
									
constant A_ESCAL_L : A_count_arr(0 to 31) := 
									  (X"2182", --0 
									  	X"2186", --1 
										X"218A", --2
										X"218E", --3
										X"2192", --4
										X"2196", --5
										X"219A", --6
										X"219E", --7
										X"21A2", --8
										X"21A6", --9
										X"21AA", --10
										X"21AE", --11
										X"21B2", --12
										X"21B6", --13
										X"21BA", --14
										X"21BE", --15
									   X"21C2", --16
									  	X"21C6", --17
										X"21CA", --18
										X"21CE", --19
										X"21D2", --20
										X"21D6", --21
										X"21DA", --22
										X"21DE", --23
										X"21E2", --24
										X"21E6", --25
										X"21EA", --26
										X"21EE", --27
										X"21F2", --28
										X"21F6", --29
										X"21FA", --30
										X"21FE");--31


-- Constants

-- DEMO Revision
constant REVISION : std_logic_vector(15 downto 0) := X"FF1E"; ---Revision Ethan Hazelton--

-- Expansion Mezzanine Type ID-Codes
constant A395A : std_logic_vector(2 downto 0) := "000"; -- 32CH IN LVDS/ECL INTERFACE
constant A395B : std_logic_vector(2 downto 0) := "001"; -- 32CH OUT LVDS INTERFACE
constant A395C : std_logic_vector(2 downto 0) := "010"; -- 32CH OUT ECL INTERFACE
constant A395D : std_logic_vector(2 downto 0) := "011"; -- 8CH I/O SELECT NIM/TTL INTER

-- Register Address Map
constant A_SCRATCH    		 : std_logic_vector(15 downto 0) := X"1000"; -- test register for fun
constant A_REVISION         : std_logic_vector(15 downto 0) := X"1002"; -- firmware revision register

--constant A_SCALER_EN_VME	 : std_logic_vector(15 downto 0) := X"1004"; -- R/W register that enables/diables scaler readout
constant A_SCALER_EN_SPILL  : std_logic_vector(15 downto 0) := X"1004"; -- R register that enables/disables scaler readout based on BOS/EOS
--constant A_SCALER_RES       : std_logic_vector(15 downto 0) := X"1008"; -- register that resets scaler readout

--constant A_SCAL_CONTROL     : std_logic_vector(15 downto 0) := X"100A";

constant A_D_IDCODE         : std_logic_vector(15 downto 0) := X"1006"; -- ID code needed to configure Mezzanine for D
constant A_E_IDCODE         : std_logic_vector(15 downto 0) := X"1008"; -- ID code needed to configure Mezzanine for E

constant A_AMASK_H          : std_logic_vector(15 downto 0) := X"100A"; -- enables/diables individual channels on input A
constant A_AMASK_L          : std_logic_vector(15 downto 0) := X"100C";

constant A_BMASK_H          : std_logic_vector(15 downto 0) := X"100E"; -- enables/diables individual channels on input B
constant A_BMASK_L          : std_logic_vector(15 downto 0) := X"1010";

constant A_DMASK_H          : std_logic_vector(15 downto 0) := X"1012"; -- enables/diables individual channels on input D
constant A_DMASK_L          : std_logic_vector(15 downto 0) := X"1014";

constant A_EMASK_H          : std_logic_vector(15 downto 0) := X"1016";   -- enables/diables individual channels on input E
constant A_EMASK_L          : std_logic_vector(15 downto 0) := X"1018";

constant A_INT_CONTROL      : std_logic_vector(15 downto 0) := X"101A";
constant A_INT_COUNT        : std_logic_vector(15 downto 0) := X"101C";







         
END v1495scaler_pkg;


