----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/28/2019 04:00:20 PM
-- Design Name: 
-- Module Name: tb_compute_L - Behavioral
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

entity tb_compute_L_and_TAG_A is
--  Port ( );
end tb_compute_L_and_TAG_A;

architecture Behavioral of tb_compute_L_and_TAG_A is

component compute_L_and_TAG_A is
    Port ( CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           
           STR : in  STD_LOGIC;
           TAU : in  STD_LOGIC_VECTOR(1023 downto 0); --key||tag_length
           
           WR_EN_RAM_L      : out STD_LOGIC; 
           WR_ADDR_RAM_L    : out STD_LOGIC_VECTOR(3 downto 0);
           WR_DATA_RAM_L    : out STD_LOGIC_VECTOR(511 downto 0);
           TAG_A_OUT        : out STD_LOGIC_VECTOR(511 downto 0);
           RDY              : out STD_LOGIC);
end component;

constant    clk_period      :   time:=8ns;

signal      clk             :   STD_LOGIC:='0';
signal      rst             :   STD_LOGIC:='0';

signal      str             :   STD_LOGIC:='0';
signal      tau             :   STD_LOGIC_VECTOR(1023 downto 0):= (others => '0');

signal      wr_en_ram_l     :   STD_LOGIC;
signal      wr_addr_ram_l   :   STD_LOGIC_VECTOR(  3 downto 0);
signal      wr_data_ram_l   :   STD_LOGIC_VECTOR(511 downto 0);
signal      rdy             :   STD_LOGIC;

begin

clk_proc:process
begin
clk <= '1';
wait for clk_period/2;
clk <= '0';
wait for clk_period/2;
end process;

UUT: compute_L_and_TAG_A
    Port map (CLK               =>  clk,
              RST               =>  rst,
              
              STR               =>  str,
              TAU               =>  tau,
              
              WR_EN_RAM_L       =>  wr_en_ram_l,
              WR_ADDR_RAM_L     =>  wr_addr_ram_l,
              WR_DATA_RAM_L     =>  wr_data_ram_l,
              RDY               =>  rdy);
              
stim_proc:process
begin
rst <= '1';
wait for clk_period * 8;
rst <= '0';
wait for clk_period * 3;

TAU             <= 	X"c1c1c1c1_c1c1c1c1_c1c1c1c1_c1c1c1c1"&
                    X"c1c1c1c1_c1c1c1c1_c1c1c1c1_c1c1c1c1"&
                    X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
                    X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
                    X"00000000_00000000_00000000_00000000"&
                    X"00000000_00000000_00000000_00000000"&
                    X"00000000_00000000_00000000_00000000"&
                    X"00000000_00000000_00000000_00000100";                   
STR             <= '1';

wait until rdy = '1';
wait;

end process;
              
end Behavioral;
