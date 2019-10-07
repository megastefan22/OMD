----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/30/2018 01:04:36 PM
-- Design Name: 
-- Module Name: reg_64_v0 - Behavioral
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

entity reg_64_v12 is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           en : in STD_LOGIC;
           init : in STD_LOGIC;
           count : in STD_LOGIC_VECTOR (63 downto 0);
           const : in STD_LOGIC_VECTOR (63 downto 0);
           data_in : in STD_LOGIC_VECTOR (63 downto 0);
           data_out : out STD_LOGIC_VECTOR (63 downto 0));
end reg_64_v12;

architecture Behavioral of reg_64_v12 is

begin

process (clk)
    begin
        if(clk'event and clk = '1') then
            if(rst = '1') then
                data_out <= (others => '0');
            else
                if(init = '1') then
                    data_out <= count xor const;
                else
                    if(en = '1') then
                        data_out <= data_in;
                    end if;
                end if;
            end if;
        end if;
    end process;

end Behavioral;
