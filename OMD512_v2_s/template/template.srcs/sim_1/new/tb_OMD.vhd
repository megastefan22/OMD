----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/02/2019 07:30:19 PM
-- Design Name: 
-- Module Name: tb_OMD - Behavioral
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

entity tb_OMD is
--  Port ( );
end tb_OMD;

architecture Behavioral of tb_OMD is

component OMD is
    Port ( CLK          : in  STD_LOGIC;
           RST          : in  STD_LOGIC;
            
           STR          : in  STD_LOGIC;
           RDY          : out STD_LOGIC);
end component;

constant    clk_period      :   time:=8ns;

signal      clk             :   STD_LOGIC:='0';
signal      rst             :   STD_LOGIC:='0';

signal      str             :   STD_LOGIC:='0';
signal      rdy             :   STD_LOGIC;

begin

clk_proc:process
begin
clk <= '1';
wait for clk_period/2;
clk <= '0';
wait for clk_period/2;
end process;


UUT: OMD
    Port map (CLK               =>  clk,
              RST               =>  rst,
              
              STR               =>  str,
              RDY               =>  rdy);
              
stim_proc: process
begin
rst <= '1';
wait for clk_period * 8;
rst <= '0';
wait for clk_period * 3;

str     <= '1';

wait until rdy = '1';
wait;

end process;
              
end Behavioral;
