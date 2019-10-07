----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/12/2016 09:37:28 AM
-- Design Name: 
-- Module Name: mux4_1_1024 - Behavioral
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

entity mux4_1_1024 is
    Port ( data1_in : in  STD_LOGIC_VECTOR (1023 downto 0);
           data2_in : in  STD_LOGIC_VECTOR (1023 downto 0);
           data3_in : in  STD_LOGIC_VECTOR (1023 downto 0);
           data4_in : in  STD_LOGIC_VECTOR (1023 downto 0);
           sel      : in  STD_LOGIC_VECTOR (   1 downto 0);
           data_out : out STD_LOGIC_VECTOR (1023 downto 0));
end mux4_1_1024;

architecture Behavioral of mux4_1_1024 is

begin

    data_out <= data1_in when sel="00" else
                data2_in when sel="01" else
                data3_in when sel="10" else
                data4_in ;

end Behavioral;
