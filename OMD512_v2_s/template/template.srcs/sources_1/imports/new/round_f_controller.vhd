----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/01/2018 06:21:33 PM
-- Design Name: 
-- Module Name: controll_blake_512 - Behavioral
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
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity round_f_controller is
Port (
        clk                 : in std_logic;
        rst                 : in std_logic;
        start               : in std_logic;
        init                : out std_logic;
        en                  : out std_logic;
        busy                : out std_logic;
        ready               : out std_logic;
        round               : out std_logic_vector(3 downto 0)
 );
end round_f_controller;

architecture Behavioral of round_f_controller is

    signal  round_temp      : std_logic_vector(3 downto 0);
    signal  state           : integer range 0 to 19;

    begin
    
    
    process(clk)
    begin
    if(clk'event and clk='1')then
        if(rst='1')then
            round_temp<=(others=>'0');
            state<=0;
            busy<='0';
            ready<='0';
            init<='0';
            en<='0';
            
        else
            case state is
                when 0 =>
                    round_temp<=(others=>'0');
                    ready<='0';
                    if(start='1')then
                        busy<='1';
                        init<='1';
                        state<=1;
                    end if;
                when 1 =>
                    init<='0';
                    en<='1';
                    state<=2;
                when 2 =>
                    round_temp<=round_temp+'1';
                    state<=3;
                when 3 =>
                    round_temp<=round_temp+'1';
                    state<=4;
                when 4 =>
                    round_temp<=round_temp+'1';
                    state<=5;
                when 5 =>
                    round_temp<=round_temp+'1';
                    state<=6;
                when 6 =>
                    round_temp<=round_temp+'1';
                    state<=7;
                when 7 =>
                    round_temp<=round_temp+'1';
                    state<=8;
                when 8 =>
                    round_temp<=round_temp+'1';
                    state<=9;
                when 9 =>
                    round_temp<=round_temp+'1';
                    state<=10;
                when 10 =>
                    round_temp<=round_temp+'1';
                    state<=11;
                when 11 =>
                    round_temp<=round_temp+'1';
                    state<=12;
                when 12 =>
                    round_temp<=round_temp+'1';
                    state<=13;
                when 13 =>
                    round_temp<=round_temp+'1';
                    state<=14;
                when 14 =>
                    round_temp<=round_temp+'1';
                    state<=15;
                when 15 =>
                    round_temp<=round_temp+'1';
                    state<=16;
                when 16 =>
                    round_temp<=round_temp+'1';
                    ready<='1';
                    state<=17;
                when 17 =>
                    busy<='0';
                    en<='0';
                    ready<='0';
                    state<=0;
                when others => null;
            end case;
        end if;
    end if;
    end process;
    
    round <= round_temp;
    
end Behavioral;