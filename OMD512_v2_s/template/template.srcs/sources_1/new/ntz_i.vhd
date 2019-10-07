----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/28/2019 06:38:44 PM
-- Design Name: 
-- Module Name: ntz_i - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ntz_i is
    Port ( data_in_LUT : in STD_LOGIC_VECTOR (7 downto 0);
           data_out_LUT : out STD_LOGIC_VECTOR (7 downto 0));
end ntz_i;

architecture Behavioral of ntz_i is

type LUT is array(0 to 255) of STD_LOGIC_VECTOR(7 downto 0);
    constant ntz_lut : LUT:=
     --y=0 ,    1 ,    2 ,    3 ,    4,     5,     6,     7,     8,     9,    10,    11,    12,    13,    14,    15,
    ( X"08", X"00", X"01", X"00", X"02", X"00", X"01", X"00", X"03", X"00", X"01", X"00", X"02", X"00", X"01", X"00",
      X"04", X"00", X"01", X"00", X"02", X"00", X"01", X"00", X"03", X"00", X"01", X"00", X"02", X"00", X"01", X"00",
      X"05", X"00", X"01", X"00", X"02", X"00", X"01", X"00", X"03", X"00", X"01", X"00", X"02", X"00", X"01", X"00",
      X"04", X"00", X"01", X"00", X"02", X"00", X"01", X"00", X"03", X"00", X"01", X"00", X"02", X"00", X"01", X"00",
      X"06", X"00", X"01", X"00", X"02", X"00", X"01", X"00", X"03", X"00", X"01", X"00", X"02", X"00", X"01", X"00",
      X"04", X"00", X"01", X"00", X"02", X"00", X"01", X"00", X"03", X"00", X"01", X"00", X"02", X"00", X"01", X"00",
      X"05", X"00", X"01", X"00", X"02", X"00", X"01", X"00", X"03", X"00", X"01", X"00", X"02", X"00", X"01", X"00",
      X"04", X"00", X"01", X"00", X"02", X"00", X"01", X"00", X"03", X"00", X"01", X"00", X"02", X"00", X"01", X"00",
      X"07", X"00", X"01", X"00", X"02", X"00", X"01", X"00", X"03", X"00", X"01", X"00", X"02", X"00", X"01", X"00",
      X"04", X"00", X"01", X"00", X"02", X"00", X"01", X"00", X"03", X"00", X"01", X"00", X"02", X"00", X"01", X"00",
      X"05", X"00", X"01", X"00", X"02", X"00", X"01", X"00", X"03", X"00", X"01", X"00", X"02", X"00", X"01", X"00",
      X"04", X"00", X"01", X"00", X"02", X"00", X"01", X"00", X"03", X"00", X"01", X"00", X"02", X"00", X"01", X"00",
      X"06", X"00", X"01", X"00", X"02", X"00", X"01", X"00", X"03", X"00", X"01", X"00", X"02", X"00", X"01", X"00",
      X"04", X"00", X"01", X"00", X"02", X"00", X"01", X"00", X"03", X"00", X"01", X"00", X"02", X"00", X"01", X"00",
      X"05", X"00", X"01", X"00", X"02", X"00", X"01", X"00", X"03", X"00", X"01", X"00", X"02", X"00", X"01", X"00",
      X"04", X"00", X"01", X"00", X"02", X"00", X"01", X"00", X"03", X"00", X"01", X"00", X"02", X"00", X"01", X"00");

begin

    data_out_LUT    <=  ntz_lut(conv_integer(unsigned(data_in_LUT)));

end Behavioral;
