


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity reg_en_64 is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           en : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR (63 downto 0);
           data_out : out STD_LOGIC_VECTOR (63 downto 0));
end reg_en_64;

architecture Behavioral of reg_en_64 is

begin

    process(clk)
    begin
    if(clk'event and clk='1') then
        if(reset='1') then
            data_out <= (others => '0');
        elsif(en='1') then
            data_out <= data_in;
        end if;
    end if;
    end process;

end Behavioral;
