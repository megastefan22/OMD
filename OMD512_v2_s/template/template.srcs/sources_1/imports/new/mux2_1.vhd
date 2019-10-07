----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/02/2018 02:43:23 PM
-- Design Name: 
-- Module Name: mux2_1 - Behavioral
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

entity mux2_1 is
    Port (
            data_in1        :   in STD_LOGIC_VECTOR (63 downto 0);
            data_in2        :   in STD_LOGIC_VECTOR (63 downto 0);
            sel             :   in STD_LOGIC;
            data_out        :   out STD_LOGIC_VECTOR(63 downto 0)
    );
end mux2_1;

architecture Behavioral of mux2_1 is

begin

    data_out <= data_in2 when sel = '1' else
                data_in1;

end Behavioral;
