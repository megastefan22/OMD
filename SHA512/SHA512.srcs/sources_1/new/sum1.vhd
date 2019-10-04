


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sum1 is
    Port ( x : in STD_LOGIC_VECTOR (63 downto 0);
           r : out STD_LOGIC_VECTOR (63 downto 0));
end sum1;

architecture Behavioral of sum1 is

begin

    r <= (x(13 downto 0) & x(63 downto 14)) xor (x(17 downto 0) & x(63 downto 18)) xor (x(40 downto 0) & x(63 downto 41));

end Behavioral;
