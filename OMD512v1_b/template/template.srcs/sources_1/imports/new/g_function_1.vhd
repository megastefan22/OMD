----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/01/2018 04:30:23 PM
-- Design Name: 
-- Module Name: g_function - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity g_function is
Port (
        in_a        : in std_logic_vector(63 downto 0);
        in_b        : in std_logic_vector(63 downto 0);
        in_c        : in std_logic_vector(63 downto 0);
        in_d        : in std_logic_vector(63 downto 0);
        const       : in std_logic_vector(127 downto 0);
        mess        : in std_logic_vector(127 downto 0);
        out_a       : out std_logic_vector(63 downto 0);
        out_b       : out std_logic_vector(63 downto 0);
        out_c       : out std_logic_vector(63 downto 0);
        out_d       : out std_logic_vector(63 downto 0)
 );
end g_function;

architecture Behavioral of g_function is

signal a_temp,b_temp,c_temp,d_temp          : std_logic_vector(63 downto 0);
signal aa_temp,bb_temp,cc_temp,dd_temp      : std_logic_vector(63 downto 0);
signal xor1,xor2,xor3,xor4,xor5,xor6        : std_logic_vector(63 downto 0);

begin

------a <- a + b + (mr(2i)  cr(2i+1))
xor1        <= mess(127 downto 64) xor const(63 downto 0);
a_temp      <= in_a + in_b + xor1;

------d <- (d  a)o32
xor2        <= in_d xor a_temp;
d_temp      <= xor2(31 downto 0) & xor2(63 downto 32);

------c <- c + d
c_temp      <= in_c + d_temp;

------b <- (b  c)o25
xor3        <= in_b xor c_temp;
b_temp      <= xor3(24 downto 0) & xor3(63 downto 25);

------a <- a + b + (mr(2i+1)  cr(2i))
xor4        <= mess(63 downto 0) xor const(127 downto 64);
aa_temp     <= a_temp + b_temp + xor4;

------d <- (d  a)o16
xor5        <= d_temp xor aa_temp;
dd_temp     <= xor5(15 downto 0) & xor5(63 downto 16);

------c <- c + d
cc_temp     <= c_temp + dd_temp;

------b <- (b  c)o11
xor6        <= b_temp xor cc_temp;
bb_temp     <= xor6(10 downto 0) & xor6(63 downto 11);

------ OUT`S
out_a       <= aa_temp;
out_b       <= bb_temp;
out_c       <= cc_temp;
out_d       <= dd_temp;

end Behavioral;