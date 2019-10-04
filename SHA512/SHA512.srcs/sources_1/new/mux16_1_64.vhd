----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/26/2016 11:48:53 AM
-- Design Name: 
-- Module Name: mux16_1_64 - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mux16_1_64 is
    Port ( data1_in : in STD_LOGIC_VECTOR (63 downto 0);
           data2_in : in STD_LOGIC_VECTOR (63 downto 0);
           data3_in : in STD_LOGIC_VECTOR (63 downto 0);
           data4_in : in STD_LOGIC_VECTOR (63 downto 0);
           data5_in : in STD_LOGIC_VECTOR (63 downto 0);
           data6_in : in STD_LOGIC_VECTOR (63 downto 0);
           data7_in : in STD_LOGIC_VECTOR (63 downto 0);
           data8_in : in STD_LOGIC_VECTOR (63 downto 0);
           data9_in : in STD_LOGIC_VECTOR (63 downto 0);
           data10_in : in STD_LOGIC_VECTOR (63 downto 0);
           data11_in : in STD_LOGIC_VECTOR (63 downto 0);
           data12_in : in STD_LOGIC_VECTOR (63 downto 0);
           data13_in : in STD_LOGIC_VECTOR (63 downto 0);
           data14_in : in STD_LOGIC_VECTOR (63 downto 0);
           data15_in : in STD_LOGIC_VECTOR (63 downto 0);
           data16_in : in STD_LOGIC_VECTOR (63 downto 0);
           sel : in STD_LOGIC_VECTOR (3 downto 0);
           data_out : out STD_LOGIC_VECTOR (63 downto 0));
end mux16_1_64;

architecture Behavioral of mux16_1_64 is

begin

    data_out <= data1_in when sel=x"0" else
                data2_in when sel=x"1" else
                data3_in when sel=x"2" else
                data4_in when sel=x"3" else
                data5_in when sel=x"4" else
                data6_in when sel=x"5" else
                data7_in when sel=x"6" else
                data8_in when sel=x"7" else
                data9_in when sel=x"8" else
                data10_in when sel=x"9" else
                data11_in when sel=x"a" else
                data12_in when sel=x"b" else
                data13_in when sel=x"c" else
                data14_in when sel=x"d" else
                data15_in when sel=x"e" else
                data16_in;

end Behavioral;
