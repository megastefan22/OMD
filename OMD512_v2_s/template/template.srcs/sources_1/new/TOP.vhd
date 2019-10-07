----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/09/2019 06:12:00 PM
-- Design Name: 
-- Module Name: TOP - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TOP is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           start : in STD_LOGIC;
           data_in : in STD_LOGIC;
           ready : out STD_LOGIC;
           data_out : out STD_LOGIC);
end TOP;

architecture Behavioral of TOP is

component encrypt is
    Port ( CLK              : in STD_LOGIC;
           RST              : in STD_LOGIC;
           --signals to PUT_DATA module
           START            : in STD_LOGIC; 
           PTXT_DATA        : in STD_LOGIC_VECTOR (511 downto 0);
           PTXT_DATA_VALID  : in STD_LOGIC;
           PTXT_RDY         : out STD_LOGIC;
           PTXT_CTRL        : in STD_LOGIC_VECTOR (15 downto 0);
           --NONCE_IN         : in STD_LOGIC_VECTOR (255 downto 0);
           FRAME_LENGTH     : in STD_LOGIC_VECTOR (15 downto 0);
           
           WR_EN_RAM_L      : in STD_LOGIC; 
           WR_ADDR_RAM_L    : in STD_LOGIC_VECTOR(3 downto 0);
           WR_DATA_RAM_L    : in STD_LOGIC_VECTOR(511 downto 0);
           TAG_A            : in STD_LOGIC_VECTOR (511 downto 0);
           KEY              : in STD_LOGIC_VECTOR (511 downto 0);
           --signals to GET_DATA module
           READY            : out STD_LOGIC;
           CTXT_DATA        : out STD_LOGIC_VECTOR (511 downto 0);
           CTXT_DATA_VALID  : out STD_LOGIC;
           CTXT_CTRL        : out STD_LOGIC_VECTOR (15 downto 0);
           --NONCE_OUT        : out STD_LOGIC_VECTOR (255 downto 0);
           TAG              : out STD_LOGIC_VECTOR (511 downto 0));
end component;


           --signals to PUT_DATA module

signal     s_PTXT_DATA        :  STD_LOGIC_VECTOR (511 downto 0);
signal     s_PTXT_DATA_VALID  :  STD_LOGIC;
signal     s_PTXT_RDY         :  STD_LOGIC;
signal     s_PTXT_CTRL        :  STD_LOGIC_VECTOR (15 downto 0);

signal     s_FRAME_LENGTH     :  STD_LOGIC_VECTOR (15 downto 0);
           
signal     s_WR_EN_RAM_L      :  STD_LOGIC; 
signal     s_WR_ADDR_RAM_L    :  STD_LOGIC_VECTOR(3 downto 0);
signal     s_WR_DATA_RAM_L    :  STD_LOGIC_VECTOR(511 downto 0);
signal     s_TAG_A            :  STD_LOGIC_VECTOR (511 downto 0);
signal     s_KEY              :  STD_LOGIC_VECTOR (511 downto 0);
           --signals to GET_DATA module

signal     s_CTXT_DATA        :  STD_LOGIC_VECTOR (511 downto 0);
signal     s_CTXT_DATA_VALID  :  STD_LOGIC;
signal     s_CTXT_CTRL        :  STD_LOGIC_VECTOR (15 downto 0);
signal     s_TAG              :  STD_LOGIC_VECTOR (511 downto 0);
signal      state               : integer range 0 to 63;

signal temp : std_logic;
    
begin

process(clk) 
begin
if(clk'event and clk='1')then
    if(rst = '1') then
        s_PTXT_DATA <= (others => '0');
        s_PTXT_DATA_VALID   <= '0'; 
        s_PTXT_CTRL         <= X"0000";   
        s_FRAME_LENGTH      <= (others => '0');
        s_TAG_A             <= (others => '0');
        s_KEY               <= (others => '0');
        s_WR_EN_RAM_L       <= '0';
        s_WR_ADDR_RAM_L     <= (others => '0');
        s_WR_data_RAM_L     <= (others => '0');
    else
        s_PTXT_DATA <= s_PTXT_DATA + data_in;
        s_PTXT_DATA_VALID <= data_in;
        s_PTXT_CTRL(15  downto 8) <= X"AA";
        s_PTXT_CTRL(7 downto 0) <=s_PTXT_CTRL(7 downto 0) + data_in;
        s_FRAME_LENGTH <= s_FRAME_LENGTH + data_in;
        s_TAG_A <= s_TAG_A + data_in;
        s_KEY   <= s_KEY + data_in;
        s_WR_EN_RAM_L       <= data_in;
        s_WR_ADDR_RAM_L     <= s_WR_ADDR_RAM_L + data_in;
        s_WR_data_RAM_L     <= s_WR_data_RAM_L + data_in; 
    end if;
end if;
end process;

encrypt_inst:encrypt 
    Port Map( CLK              => CLK,
           RST                 => RST,
           --signals to PUT_DATA module
           START               => START, 
           PTXT_DATA           => s_PTXT_DATA,
           PTXT_DATA_VALID     => s_PTXT_DATA_VALID,
           PTXT_RDY            => open, 
           PTXT_CTRL           => s_PTXT_CTRL,

           FRAME_LENGTH        => s_FRAME_LENGTH,
           
           WR_EN_RAM_L         => s_WR_EN_RAM_L, 
           WR_ADDR_RAM_L       => s_WR_ADDR_RAM_L,
           WR_DATA_RAM_L       => s_WR_DATA_RAM_L,
           TAG_A               => s_TAG_A,
           KEY                 => s_KEY,
           --signals to GET_DATA module
           READY               => READY,
           CTXT_DATA           => s_CTXT_DATA,
           CTXT_DATA_VALID     => s_CTXT_DATA_VALID,
           CTXT_CTRL           => s_CTXT_CTRL,

           TAG                 => s_TAG);

temp <= '1' when (s_CTXT_DATA xor s_TAG) > x"A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0" else '0';

    data_out <= s_CTXT_DATA_VALID xor temp xor s_CTXT_CTRL(15) xor s_CTXT_CTRL(14) xor s_CTXT_CTRL(13) xor s_CTXT_CTRL(12) xor s_CTXT_CTRL(11) xor s_CTXT_CTRL(10) xor
     s_CTXT_CTRL(9) xor s_CTXT_CTRL(8) xor s_CTXT_CTRL(7) xor s_CTXT_CTRL(6) xor s_CTXT_CTRL(5) xor s_CTXT_CTRL(4) xor  s_CTXT_CTRL(3) xor  s_CTXT_CTRL(2) xor  s_CTXT_CTRL(1) xor  s_CTXT_CTRL(0);

end Behavioral;
