


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sum0 is
    Port ( x : in STD_LOGIC_VECTOR (63 downto 0);
           r : out STD_LOGIC_VECTOR (63 downto 0));
end sum0;

architecture Behavioral of sum0 is

begin

    r <= (x(27 downto 0) & x(63 downto 28)) xor (x(33 downto 0) & x(63 downto 34)) xor (x(38 downto 0) & x(63 downto 39));

end Behavioral;
