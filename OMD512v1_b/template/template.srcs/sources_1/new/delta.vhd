----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/26/2019 10:27:27 AM
-- Design Name: 
-- Module Name: delta - Behavioral
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

entity delta is
    Port ( CLK                  : in  STD_LOGIC;
           RST                  : in  STD_LOGIC;
           START                : in  STD_LOGIC;
           NONCE                : in  STD_LOGIC_VECTOR (255 downto 0);
           READY                : out STD_LOGIC;
           WR_EN_RAM_DELTA      : out STD_LOGIC; 
           WR_ADDR_RAM_DELTA    : out STD_LOGIC_VECTOR(7 downto 0);
           WR_DATA_RAM_DELTA    : out STD_LOGIC_VECTOR(511 downto 0));
end delta;

architecture Behavioral of delta is

component blake512 is
    Port ( clk              : in STD_LOGIC;
           rst              : in STD_LOGIC;
           msg              : in STD_LOGIC_VECTOR(1023 downto 0);
           salt256          : in STD_LOGIC_VECTOR(255 downto 0);
           count            : in STD_LOGIC_VECTOR(127 downto 0);
           start            : in STD_LOGIC;
           IV512            : in STD_LOGIC_VECTOR(511 downto 0);
           busy             : out STD_LOGIC;
           ready            : out STD_LOGIC;
           blake512         : out STD_LOGIC_VECTOR(511 downto 0)
           );
end component;

signal msg_blake            : STD_LOGIC_VECTOR(1023 downto 0);
signal iv_blake             : STD_LOGIC_VECTOR(511 downto 0);
signal blake512_data_out    : STD_LOGIC_VECTOR(511 downto 0);


signal start_blake          : STD_LOGIC;
signal busy_blake           : STD_LOGIC;
signal ready_blake          : STD_LOGIC;

begin

blake512_delta00: blake512
Port Map(   clk             => CLK,
            rst             => RST,
            msg             => msg_blake,
            salt256         => (others => '0'),
            count           => (others => '0'),
            start           => start_blake,
            IV512           => iv_blake,
            busy            => busy_blake,
            ready           => ready_blake,
            blake512        => blake512_data_out);

end Behavioral;
