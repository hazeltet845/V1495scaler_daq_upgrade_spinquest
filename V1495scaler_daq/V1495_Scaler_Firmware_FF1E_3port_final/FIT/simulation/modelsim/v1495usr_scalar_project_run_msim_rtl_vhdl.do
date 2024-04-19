transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/Users/lorenzon-lab-admin/Desktop/Ethan_Quartus/v1495_firmwares/V1495_Scaler_Firmware/V1495_Scaler_Firmware/src/pll.vhd}
vcom -93 -work work {C:/Users/lorenzon-lab-admin/Desktop/Ethan_Quartus/v1495_firmwares/V1495_Scaler_Firmware/V1495_Scaler_Firmware/src/edge_detector.vhd}
vcom -93 -work work {C:/Users/lorenzon-lab-admin/Desktop/Ethan_Quartus/v1495_firmwares/V1495_Scaler_Firmware/V1495_Scaler_Firmware/src/scal_vme_switch.vhd}
vcom -93 -work work {C:/Users/lorenzon-lab-admin/Desktop/Ethan_Quartus/v1495_firmwares/V1495_Scaler_Firmware/V1495_Scaler_Firmware/src/v1495_default_code/v1495scalar_pkg.vhd}
vcom -93 -work work {C:/Users/lorenzon-lab-admin/Desktop/Ethan_Quartus/v1495_firmwares/V1495_Scaler_Firmware/V1495_Scaler_Firmware/src/spill_state.vhd}
vcom -93 -work work {C:/Users/lorenzon-lab-admin/Desktop/Ethan_Quartus/v1495_firmwares/V1495_Scaler_Firmware/V1495_Scaler_Firmware/src/v1495_default_code/tristate_if_rtl.vhd}
vcom -93 -work work {C:/Users/lorenzon-lab-admin/Desktop/Ethan_Quartus/v1495_firmwares/V1495_Scaler_Firmware/V1495_Scaler_Firmware/src/v1495_default_code/v1495usr_scalar_project.vhd}
vcom -93 -work work {C:/Users/lorenzon-lab-admin/Desktop/Ethan_Quartus/v1495_firmwares/V1495_Scaler_Firmware/V1495_Scaler_Firmware/src/scalar32_mult_ch.vhd}
vcom -93 -work work {C:/Users/lorenzon-lab-admin/Desktop/Ethan_Quartus/v1495_firmwares/V1495_Scaler_Firmware/V1495_Scaler_Firmware/src/scalar_single_ch.vhd}
vcom -93 -work work {C:/Users/lorenzon-lab-admin/Desktop/Ethan_Quartus/v1495_firmwares/V1495_Scaler_Firmware/V1495_Scaler_Firmware/src/v1495_default_code/v1495_reference.vhd}
vcom -93 -work work {C:/Users/lorenzon-lab-admin/Desktop/Ethan_Quartus/v1495_firmwares/V1495_Scaler_Firmware/V1495_Scaler_Firmware/src/Pulse_stretcher.vhd}

vcom -93 -work work {C:/Users/lorenzon-lab-admin/Desktop/Ethan_Quartus/v1495_firmwares/V1495_Scaler_Firmware/V1495_Scaler_Firmware/FIT/../test_bench/v1495_reference_tb.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L cyclone -L rtl_work -L work -voptargs="+acc" v1495_reference_tb

add wave *
view structure
view signals
run -all
