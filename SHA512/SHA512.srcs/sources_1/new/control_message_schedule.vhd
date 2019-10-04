----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/26/2016 12:02:04 PM
-- Design Name: 
-- Module Name: control_message_schedule - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--library UNISIM;
--use UNISIM.VComponents.all;

entity control_message_schedule is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           start : in STD_LOGIC;
           ready : out STD_LOGIC;
           data1_in : in STD_LOGIC_VECTOR (63 downto 0);
           data2_in : in STD_LOGIC_VECTOR (63 downto 0);
           wr_en : out STD_LOGIC;
           wr_addr : out STD_LOGIC_VECTOR (6 downto 0);
           wr_data : out STD_LOGIC_VECTOR (63 downto 0);
           rd_addr : out STD_LOGIC_VECTOR (6 downto 0);
           reg1_en : out STD_LOGIC;
           reg2_en : out STD_LOGIC;
           reg3_en : out STD_LOGIC;
           reg4_en : out STD_LOGIC);
end control_message_schedule;

architecture Behavioral of control_message_schedule is

    signal wr_addr_temp : std_logic_vector(6 downto 0);
    signal rd_addr_temp : std_logic_vector(6 downto 0);

    signal state : integer range 0 to 31;

begin

    process(clk)
    begin
    if(clk'event and clk='1') then
        if(reset='1') then
            wr_data <= (others => '0');
            wr_addr_temp <= (others => '0');
            rd_addr_temp <= (others => '0');
            wr_en <= '0';
            reg1_en <= '0';
            reg2_en <= '0';
            reg3_en <= '0';
            reg4_en <= '0';
            state <= 0;
        else
            case state is
                when 0 =>
                    if(start='1') then
                        state <= 1;
                    end if;
                -- write message to ram
                when 1 =>
                    wr_addr_temp <= (others => '0');
                    state <= 2;
                when 2 =>
                    state <= 3;
                when 3 =>
                    wr_en <= '1';
                    wr_data <= data1_in;
                    state <= 4;
                when 4 =>
                    wr_en <= '0';
                    if(wr_addr_temp="0001111") then
                        state <= 5;
                    else
                        wr_addr_temp <= wr_addr_temp + '1';
                        state <= 2;
                    end if;
                -- compute W(addr)
                when 5 =>
                    wr_addr_temp <= wr_addr_temp + '1';
                    state <= 6;
                when 6 =>
                    rd_addr_temp <= wr_addr_temp - "0000010"; -- W(addr-2)
                    state <= 7;
                when 7 =>
                    state <= 8;
                when 8 =>
                    reg1_en <= '1';
                    state <= 9;
                when 9 =>
                    reg1_en <= '0';
                    rd_addr_temp <= wr_addr_temp - "0000111"; -- W(addr-7)
                    state <= 10;
                when 10 =>
                    state <= 11;
                when 11 =>
                    reg2_en <= '1';
                    state <= 12;
                when 12 =>
                    reg2_en <= '0';
                    rd_addr_temp <= wr_addr_temp - "0001111"; -- W(addr-15)
                    state <= 13;
                when 13 =>
                    state <= 14;
                when 14 =>
                    reg3_en <= '1';
                    state <= 15;
                when 15 =>
                    reg3_en <= '0';
                    rd_addr_temp <= wr_addr_temp - "0010000"; -- W(addr-16)
                    state <= 16;
                when 16 =>
                    state <= 17;
                when 17 =>
                    reg4_en <= '1';
                    state <= 18;
                when 18 =>
                    reg4_en <= '0';
                    state <= 19;
                -- write computed W(addr)
                when 19 =>
                    wr_en <= '1';
                    wr_data <= data2_in;
                    state <= 20;
                when 20 =>
                    if(wr_addr_temp="1001111") then
                        state <= 21;
                    else
                        state <= 5;
                    end if;
                -- ready
                when 21 =>
                    ready <= '1';
                    state <= 22;
                when 22 =>
                    ready <= '0';
                    state <= 0;
                when others => null;
            end case;
        end if;
    end if;
    end process;

    wr_addr <= wr_addr_temp;
    rd_addr <= rd_addr_temp;

end Behavioral;
