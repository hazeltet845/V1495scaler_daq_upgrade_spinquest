## Generated SDC file "v1495usr_scaler.sdc"

## Copyright (C) 1991-2010 Altera Corporation
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, Altera MegaCore Function License 
## Agreement, or other applicable license agreement, including, 
## without limitation, that your use is for the sole purpose of 
## programming logic devices manufactured by Altera and sold by 
## Altera or its authorized distributors.  Please refer to the 
## applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 10.0 Build 218 06/27/2010 SJ Web Edition"

## DATE    "Thu Jul 28 19:09:26 2022"

##
## DEVICE  "EP1C20F400C6"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {LCLK} -period 25.000 -waveform { 0.000 12.500 } [get_ports {LCLK}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {pll_200:PLL_IO|altpll:altpll_component|_clk0} -source [get_pins {PLL_IO|altpll_component|pll|inclk[0]}] -duty_cycle 50.000 -multiply_by 5 -master_clock {LCLK} [get_pins {PLL_IO|altpll_component|pll|clk[0]}] 
create_generated_clock -name {I3} -source [get_ports {LCLK}] -master_clock {LCLK} [get_registers {*I3*}] 
create_generated_clock -name {I2} -source [get_ports {LCLK}] -master_clock {LCLK} [get_registers {v1495_reference:I0|v1495_int:INT|clk_divider:I2|temp}] 


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************



#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

