----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/26/2016 09:28:01 AM
-- Design Name: 
-- Module Name: sigma1 - Behavioral
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

entity sigma1 is
    Port ( x : in STD_LOGIC_VECTOR (63 downto 0);
           r : out STD_LOGIC_VECTOR (63 downto 0));
end sigma1;

architecture Behavioral of sigma1 is

begin

    r <= (x(18 downto 0) & x(63 downto 19)) xor (x(60 downto 0) & x(63 downto 61)) xor ("000000" & x(63 downto 6)); 

end Behavioral;
