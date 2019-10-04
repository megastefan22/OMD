----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:57:52 03/19/2013 
-- Design Name: 
-- Module Name:    ram128x64 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--library UNISIM;
--use UNISIM.VComponents.all;

entity ram128x64 is
    Port ( wr_clk : in  STD_LOGIC;
           we : in  STD_LOGIC;
           wr_addr : in  STD_LOGIC_VECTOR (6 downto 0);
           wr_data : in  STD_LOGIC_VECTOR (63 downto 0);
		   rd_clk : in  STD_LOGIC;
		   rd_addr : in  STD_LOGIC_VECTOR (6 downto 0);
           rd_data : out  STD_LOGIC_VECTOR (63 downto 0));
end ram128x64;

architecture Behavioral of ram128x64 is

	type ram_type is array(0 to 127) of std_logic_vector(63 downto 0);
	
	signal ram: ram_type;


begin

	process(wr_clk)
	begin
	if(wr_clk'event and wr_clk='1') then	
		if(we='1') then
			ram(conv_integer(unsigned(wr_addr))) <= wr_data;
		end if;
	end if;
	end process;

	process(rd_clk)
	begin
	if(rd_clk'event and rd_clk='1') then	
		rd_data <= ram(conv_integer(unsigned(rd_addr)));
	end if;
	end process;

end Behavioral;
