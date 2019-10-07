----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/13/2019 01:55:30 PM
-- Design Name: 
-- Module Name: tb_encrypt - Behavioral
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

entity tb_encrypt is
--  Port ( );
end tb_encrypt;

architecture Behavioral of tb_encrypt is

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

component compute_L_and_TAG_A is
    Port ( CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           
           STR : in  STD_LOGIC;
           TAU : in  STD_LOGIC_VECTOR(1023 downto 0); --key||tag_length
           
           WR_EN_RAM_L      : out STD_LOGIC; 
           WR_ADDR_RAM_L    : out STD_LOGIC_VECTOR(3 downto 0);
           WR_DATA_RAM_L    : out STD_LOGIC_VECTOR(511 downto 0);
           TAG_A_OUT        : out STD_LOGIC_VECTOR(511 downto 0);
           TAG_A_VLD        : out STD_LOGIC;
           RDY              : out STD_LOGIC);
end component;


signal     clk              : STD_LOGIC:='0';
signal     rst              : STD_LOGIC:='0';
           --signals to PUT_DATA module 
signal     start            : STD_LOGIC:='0';
signal     ptxt_data        : STD_LOGIC_VECTOR (511 downto 0):= (others => '0');
signal     ptxt_data_valid  : STD_LOGIC:='0';
signal     ptxt_rdy         : STD_LOGIC;
signal     ptxt_ctrl        : STD_LOGIC_VECTOR (15 downto 0):= (others => '0');
--signal     nonce_in         : STD_LOGIC_VECTOR (255 downto 0):= (others => '0');

signal     frame_length     : STD_LOGIC_VECTOR (15 downto 0):= (others => '0');
           
signal     wr_en_ram_delta  : STD_LOGIC := '0';
signal     wr_addr_ram_delta: STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
signal     wr_data_ram_delta: STD_LOGIC_VECTOR(511 downto 0) := (others => '0');
signal     taga             : STD_LOGIC_VECTOR (511 downto 0) := (others => '0');
signal     key              : STD_LOGIC_VECTOR (511 downto 0) := (others => '0');
           --signals to GET_DATA module
signal     ready            : STD_LOGIC;
signal     ctxt_data        : STD_LOGIC_VECTOR (511 downto 0);
signal     ctxt_data_valid  : STD_LOGIC;
signal     ctxt_ctrl        : STD_LOGIC_VECTOR (15 downto 0);
--signal     nonce_out        : STD_LOGIC_VECTOR (255 downto 0):= (others => '0');
signal     tag              : STD_LOGIC_VECTOR (511 downto 0):= (others => '0');

signal     start_compute_L  : STD_LOGIC:='0';
signal     tau              : STD_LOGIC_VECTOR(1023 downto 0):= (others => '0');

signal     wr_en_ram_l      : STD_LOGIC:= '0';
signal     wr_addr_ram_l    : STD_LOGIC_VECTOR(3 downto 0);
signal     wr_data_ram_l    : STD_LOGIC_VECTOR(511 downto 0);
signal     ready_compute_l  : STD_LOGIC;

constant   clk_period       : time:=8ns;

begin

process 
begin
clk <= '1';
wait for clk_period/2;
clk <= '0';
wait for clk_period/2;
end process;

UUT: encrypt 
    Port map
          (CLK            =>  clk,
           RST              =>  rst,
           --signals to PUT_DATA module
           START            =>  start, 
           PTXT_DATA        =>  ptxt_data,
           PTXT_DATA_VALID  =>  ptxt_data_valid,
           PTXT_RDY         =>  ptxt_rdy,
           PTXT_CTRL        =>  ptxt_ctrl,
           --NONCE_IN         =>  nonce_in,
           FRAME_LENGTH     => frame_length,
                      
           WR_EN_RAM_L      => wr_en_ram_l,
           WR_ADDR_RAM_L    => wr_addr_ram_l,
           WR_DATA_RAM_L    => wr_data_ram_l,
           TAG_A             => taga,
           KEY              =>  key,
           --signals to GET_DATA module
           READY            =>  ready,
           CTXT_DATA        =>  ctxt_data,
           CTXT_DATA_VALID  =>  ctxt_data_valid,
           CTXT_CTRL        =>  ctxt_ctrl,
           --NONCE_OUT        =>  nonce_out,
           TAG              =>  tag);

TAU             <= 	X"c1c1c1c1_c1c1c1c1_c1c1c1c1_c1c1c1c1"&
                               X"c1c1c1c1_c1c1c1c1_c1c1c1c1_c1c1c1c1"&
                               X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
                               X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
                               X"00000000_00000000_00000000_00000000"&
                               X"00000000_00000000_00000000_00000000"&
                               X"00000000_00000000_00000000_00000000"&
                               X"00000000_00000000_00000000_00000100";

UUT2: compute_L_and_TAG_A 
               Port MAP(CLK            =>  clk,
                        RST              =>  rst,
                      
                        STR             => start_compute_L,
                        TAU             => tau,
                      
                      WR_EN_RAM_L       => wr_en_ram_l,
                      WR_ADDR_RAM_L    => wr_addr_ram_l,
                      WR_DATA_RAM_L    => wr_data_ram_l,
                      TAG_A_OUT        => taga,
                      TAG_A_VLD        => open,
                      RDY              => ready_compute_l);

process
begin
rst <= '1';
wait for clk_period * 8;
rst <= '0';
wait for clk_period * 3;



start_compute_L     <= '1';
wait for clk_period;
start_compute_L     <= '0';
wait for clk_period;
wait until ready_compute_l = '1';
wait for clk_period*3;

---------------------------------------------------single block
--frame_length        <=  X"0040";
--PTXT_DATA           <=  X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
--                        X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
--                        X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
--                        X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f";
--key                 <=  X"c1c1c1c1_c1c1c1c1_c1c1c1c1_c1c1c1c1"&
--                        X"c1c1c1c1_c1c1c1c1_c1c1c1c1_c1c1c1c1"&
--                        X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
--                        X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f";
--PTXT_DATA_VALID     <= '1';

--    START               <= '1';

--PTXT_CTRL           <= X"CC00";     -- bloc 1
--NONCE_IN            <= X"F0F1F2F3_F0F1F2F3_F0F1F2F3_F0F1F2F3"&
--                       X"F0F1F2F3_F0F1F2F3_F0F1F2F3_F0F1F2F3";
--wait for clk_period;
--PTXT_DATA_VALID     <= '0';

--    START               <= '0';

--wait until PTXT_RDY  = '1';
--wait for clk_period*4;




-------------------------------------------------multiple blocks
--                      packet 1
frame_length        <=  X"0200";
PTXT_DATA           <=  X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
                        X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
                        X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
                        X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f";
key                 <=  X"c1c1c1c1_c1c1c1c1_c1c1c1c1_c1c1c1c1"&
                        X"c1c1c1c1_c1c1c1c1_c1c1c1c1_c1c1c1c1"&
                        X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
                        X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f";
                        
--TAGA                <=  X"7449_0e45_2a3d_c8d3"&
--                        X"1d42_6871_8f52_ee94"&
--                        X"5f58_3d16_6347_201a"&
--                        X"6d3d_6910_dbd9_3838"&
--                        X"d7b1_4c80_d494_149b"&
--                        X"a9c1_0183_db71_04ba"&
--                        X"2784_ba36_cebd_79e5"&
--                        X"5300_7ef5_020b_e52c";

PTXT_DATA_VALID     <= '1';

    START               <= '1';

PTXT_CTRL           <= X"AA00";     -- bloc 1
--NONCE_IN            <= X"F0F1F2F3_F0F1F2F3_F0F1F2F3_F0F1F2F3"&
--                       X"F0F1F2F3_F0F1F2F3_F0F1F2F3_F0F1F2F3";
wait for clk_period;
PTXT_DATA_VALID     <= '0';

    START               <= '0';

wait until PTXT_RDY  = '1';
wait for clk_period*4;
PTXT_DATA           <=  X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
                        X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
                        X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
                        X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f";
PTXT_DATA_VALID     <= '1';
PTXT_CTRL           <= X"AA00";     -- bloc 2
wait for clk_period;
PTXT_DATA_VALID     <= '0';
wait until PTXT_RDY  = '1';
wait for clk_period*4;

PTXT_DATA           <=  X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
                        X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
                        X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
                        X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f";
PTXT_DATA_VALID     <= '1';
PTXT_CTRL           <= X"AA00";     -- bloc 3
wait for clk_period;
PTXT_DATA_VALID     <= '0';
wait until PTXT_RDY  = '1';
wait for clk_period*4;

PTXT_DATA           <=  X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
                        X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
                        X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
                        X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f";
PTXT_DATA_VALID     <= '1';
PTXT_CTRL           <= X"AA00";      -- bloc 4
wait for clk_period;
PTXT_DATA_VALID     <= '0';
wait until PTXT_RDY  = '1';
wait for clk_period*4;

PTXT_DATA           <=  X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
                        X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
                        X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
                        X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f";
PTXT_DATA_VALID     <= '1';
PTXT_CTRL           <= X"AA00";     -- bloc 5
wait for clk_period;
PTXT_DATA_VALID     <= '0';
wait until PTXT_RDY  = '1';
wait for clk_period*4;

PTXT_DATA           <=  X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
                        X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
                        X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
                        X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f";
PTXT_DATA_VALID     <= '1';
PTXT_CTRL           <= X"AA00";     -- bloc 6
wait for clk_period;
PTXT_DATA_VALID     <= '0';
wait until PTXT_RDY  = '1';
wait for clk_period*4;

PTXT_DATA           <=  X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
                        X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
                        X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
                        X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f";
PTXT_DATA_VALID     <= '1';
PTXT_CTRL           <= X"AA00";     -- bloc 7
wait for clk_period;
PTXT_DATA_VALID     <= '0';
wait until PTXT_RDY  = '1';
wait for clk_period*4;

PTXT_DATA           <=  X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
                        X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
                        X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
                        X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f";
PTXT_DATA_VALID     <= '1';
PTXT_CTRL           <= X"5500";      -- bloc 8
wait for clk_period;
PTXT_DATA_VALID     <= '0';
wait until PTXT_RDY  = '1';
wait for clk_period*4;



----------------------------------------- packetul 2

frame_length        <=  X"0200";
PTXT_DATA           <=  X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
                        X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
                        X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
                        X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f";
key                 <=  X"c1c1c1c1_c1c1c1c1_c1c1c1c1_c1c1c1c1"&
                        X"c1c1c1c1_c1c1c1c1_c1c1c1c1_c1c1c1c1"&
                        X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
                        X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f";
PTXT_DATA_VALID     <= '1';

    START               <= '1';

PTXT_CTRL           <= X"AA00";     -- bloc 1
--NONCE_IN            <= X"F0F1F2F3_F0F1F2F3_F0F1F2F3_F0F1F2F3"&
--                       X"F0F1F2F3_F0F1F2F3_F0F1F2F3_F0F1F2F3";
wait for clk_period;
PTXT_DATA_VALID     <= '0';

    START               <= '0';

wait until PTXT_RDY  = '1';
wait for clk_period*4;
PTXT_DATA           <=  X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
                        X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
                        X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
                        X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f";
PTXT_DATA_VALID     <= '1';
PTXT_CTRL           <= X"AA00";     -- bloc 2
wait for clk_period;
PTXT_DATA_VALID     <= '0';
wait until PTXT_RDY  = '1';
wait for clk_period*4;

PTXT_DATA           <=  X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
                        X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
                        X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
                        X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f";
PTXT_DATA_VALID     <= '1';
PTXT_CTRL           <= X"AA00";     -- bloc 3
wait for clk_period;
PTXT_DATA_VALID     <= '0';
wait until PTXT_RDY  = '1';
wait for clk_period*4;

PTXT_DATA           <=  X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
                        X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
                        X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
                        X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f";
PTXT_DATA_VALID     <= '1';
PTXT_CTRL           <= X"AA00";      -- bloc 4
wait for clk_period;
PTXT_DATA_VALID     <= '0';
wait until PTXT_RDY  = '1';
wait for clk_period*4;

PTXT_DATA           <=  X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
                        X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
                        X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
                        X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f";
PTXT_DATA_VALID     <= '1';
PTXT_CTRL           <= X"AA00";     -- bloc 5
wait for clk_period;
PTXT_DATA_VALID     <= '0';
wait until PTXT_RDY  = '1';
wait for clk_period*4;

PTXT_DATA           <=  X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
                        X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
                        X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
                        X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f";
PTXT_DATA_VALID     <= '1';
PTXT_CTRL           <= X"AA00";     -- bloc 6
wait for clk_period;
PTXT_DATA_VALID     <= '0';
wait until PTXT_RDY  = '1';
wait for clk_period*4;

PTXT_DATA           <=  X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
                        X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
                        X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
                        X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f";
PTXT_DATA_VALID     <= '1';
PTXT_CTRL           <= X"AA00";     -- bloc 7
wait for clk_period;
PTXT_DATA_VALID     <= '0';
wait until PTXT_RDY  = '1';
wait for clk_period*4;

PTXT_DATA           <=  X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
                        X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
                        X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f"&
                        X"4f4f4f4f_4f4f4f4f_4f4f4f4f_4f4f4f4f";
PTXT_DATA_VALID     <= '1';
PTXT_CTRL           <= X"5500";      -- bloc 8
wait for clk_period;
PTXT_DATA_VALID     <= '0';
wait until PTXT_RDY  = '1';
wait for clk_period*4;


wait;


end process;

end Behavioral;
