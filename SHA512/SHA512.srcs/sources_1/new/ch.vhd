


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ch is
    Port ( x : in STD_LOGIC_VECTOR (63 downto 0);
           y : in STD_LOGIC_VECTOR (63 downto 0);
           z : in STD_LOGIC_VECTOR (63 downto 0);
           r : out STD_LOGIC_VECTOR (63 downto 0));
end ch;

architecture Behavioral of ch is

begin

    r <= (x and y) xor ((not x) and z);

end Behavioral;
