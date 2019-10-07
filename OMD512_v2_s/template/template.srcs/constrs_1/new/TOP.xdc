###################################################################################
########################### ISQ01 IDS-HW-1G CONSTRAINTS ###########################
###################################################################################

set_property CFGBVS GND [current_design]
set_property CONFIG_VOLTAGE 1.8 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]

#set_property BITSTREAM.CONFIG.CONFIGRATE 82 [current_design]
#set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
#set_property BITSTREAM.CONFIG.SPI_FALL_EDGE YES [current_design]
#set_property BITSTREAM.CONFIG.SPI_32BIT_ADDR YES [current_design]
#set_property BITSTREAM.CONFIG.USR_ACCESS TIMESTAMP [current_design]

##set_property BITSREAM.ENCRYPTION.KEYLIFE 64 [current_design]
##set_property BITSREAM.ENCRYPTION.ENCRYPT YES [current_design]
##set_property BITSREAM.ENCRYPTION.ENCRYPTKEYSELECT BBRAM [current_design]
##set_property BITSREAM.ENCRYPTION.STARTIV0 A0A1A2A3A4A5A6A7A8A9AAAB [current_design]
##set_property BITSREAM.ENCRYPTION.KEY0 000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F [current_design]

###################################################################################
############################# System clock constraints ############################
###################################################################################

set_property PACKAGE_PIN G31 [get_ports clk]
set_property IOSTANDARD LVCMOS18 [get_ports clk]

set_property PACKAGE_PIN L19 [get_ports rst]
set_property IOSTANDARD LVCMOS12 [get_ports rst]

###################################################################################
############################ LED interface constraints ############################
###################################################################################

set_property PACKAGE_PIN AT32 [get_ports start]
set_property IOSTANDARD LVCMOS12 [get_ports start]

set_property PACKAGE_PIN AV34 [get_ports data_in]
set_property IOSTANDARD LVCMOS12 [get_ports data_in]

set_property PACKAGE_PIN AY30 [get_ports ready]
set_property IOSTANDARD LVCMOS12 [get_ports ready]

set_property PACKAGE_PIN BB32 [get_ports data_out]
set_property IOSTANDARD LVCMOS12 [get_ports data_out]

###################################################################################
################################ TIMING constraints ###############################
###################################################################################

create_clock -period 16.000 [get_ports clk]
set_input_jitter clk 0.050

###################################################################################
########################### ISQ01 IDS-HW-1G CONSTRAINTS ###########################
###################################################################################