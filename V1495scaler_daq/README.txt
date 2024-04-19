"CRL" -> This folder contains all the CRL code for a new V1495 scaler readout. When used, the crl code should be copied and compiled inside /usr/local/coda/2.6.1/extensions/e906 directory.

"scaler_driver" ->  This folder contains the drivers required for uploading firmware to the FPGA (v1495.c) and functions needed for scaler readout (v1495scaler.c). The drivers must be compiled here and their object files must be referenced in the MVME 5500 boot file (/home/e1039daq/tftpboot/roc6_6100_sc.boot). 

"V1495_Scaler_Firmware_FF1E_3port_final" -> Contains the Quartus II project with all the VHDL code for the scaler firmware. The VHDL code is found in the "src" folder.

"Other_debugging_firmwares" -> This contains some firmware files for the Fermilab accelerator emulator 

"v1495usr_scaler_FF1E_daq.rbf" -> This is the firmware that must be uploaded to the V1495. The firmware revision "0xFF1E" should be seen from the revision register of the V1495. This can be accessed by initializing the V1495(v1495Init(base_addr)) then using a function from the drivers (v1495ScalerStatus()) in the MVME screen session. 

"V1495_scaler_daq.txt" -> This file contains useful strings for the MVME 5500 boot configuration and uploading firmware.  

"SpinQuest_v1495_Scaler_Firmware_Design.pdf" -> This file contains an explanation of the firmware design and instructions on how to setup the Scaler DAQ. 
