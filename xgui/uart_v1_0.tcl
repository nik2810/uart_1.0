# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "base_freq" -parent ${Page_0}
  ipgui::add_param $IPINST -name "uart_speed" -parent ${Page_0}
  ipgui::add_param $IPINST -name "word_width" -parent ${Page_0}
  ipgui::add_param $IPINST -name "use_tx" -parent ${Page_0}
  ipgui::add_param $IPINST -name "use_debug" -parent ${Page_0}


}

proc update_PARAM_VALUE.base_freq { PARAM_VALUE.base_freq } {
	# Procedure called to update base_freq when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.base_freq { PARAM_VALUE.base_freq } {
	# Procedure called to validate base_freq
	return true
}

proc update_PARAM_VALUE.uart_speed { PARAM_VALUE.uart_speed } {
	# Procedure called to update uart_speed when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.uart_speed { PARAM_VALUE.uart_speed } {
	# Procedure called to validate uart_speed
	return true
}

proc update_PARAM_VALUE.use_debug { PARAM_VALUE.use_debug } {
	# Procedure called to update use_debug when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.use_debug { PARAM_VALUE.use_debug } {
	# Procedure called to validate use_debug
	return true
}

proc update_PARAM_VALUE.use_tx { PARAM_VALUE.use_tx } {
	# Procedure called to update use_tx when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.use_tx { PARAM_VALUE.use_tx } {
	# Procedure called to validate use_tx
	return true
}

proc update_PARAM_VALUE.word_width { PARAM_VALUE.word_width } {
	# Procedure called to update word_width when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.word_width { PARAM_VALUE.word_width } {
	# Procedure called to validate word_width
	return true
}


proc update_MODELPARAM_VALUE.base_freq { MODELPARAM_VALUE.base_freq PARAM_VALUE.base_freq } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.base_freq}] ${MODELPARAM_VALUE.base_freq}
}

proc update_MODELPARAM_VALUE.uart_speed { MODELPARAM_VALUE.uart_speed PARAM_VALUE.uart_speed } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.uart_speed}] ${MODELPARAM_VALUE.uart_speed}
}

proc update_MODELPARAM_VALUE.word_width { MODELPARAM_VALUE.word_width PARAM_VALUE.word_width } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.word_width}] ${MODELPARAM_VALUE.word_width}
}

proc update_MODELPARAM_VALUE.use_tx { MODELPARAM_VALUE.use_tx PARAM_VALUE.use_tx } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.use_tx}] ${MODELPARAM_VALUE.use_tx}
}

proc update_MODELPARAM_VALUE.use_debug { MODELPARAM_VALUE.use_debug PARAM_VALUE.use_debug } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.use_debug}] ${MODELPARAM_VALUE.use_debug}
}

