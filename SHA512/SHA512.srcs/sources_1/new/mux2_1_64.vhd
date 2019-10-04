


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mux2_1_64 is
    Port ( data1_in : in STD_LOGIC_VECTOR (63 downto 0);
           data2_in : in STD_LOGIC_VECTOR (63 downto 0);
           sel : in STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR (63 downto 0));
end mux2_1_64;

architecture Behavioral of mux2_1_64 is

begin

    data_out <= data1_in when sel='0' else
                data2_in;

end Behavioral;
