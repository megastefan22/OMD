----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/30/2018 01:02:11 PM
-- Design Name: 
-- Module Name: blake512 Behavioral
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
use IEEE.std_logic_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

use IEEE.numeric_std.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity blake512 is
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
end blake512;

architecture Behavioral of blake512 is


type c_const is array (0 to 15) of std_logic_vector(63 downto 0);
--signal C : c_const :=      ((x"243F6A8885A308D3"), (x"13198A2E03707344"),
--                            (x"A4093822299F31D0"), (x"082EFA98EC4E6C89"),
--                            (x"452821E638D01377"), (x"BE5466CF34E90C6C"),
--                            (x"C0AC29B7C97C50DD"), (x"3F84D5B5B5470917"),
--                            (x"9216D5D98979FB1B"), (x"D1310BA698DFB5AC"),
--                            (x"2FFD72DBD01ADFB7"), (x"B8E1AFED6A267E96"),
--                            (x"BA7C9045F12C7F99"), (x"24A19947B3916CF7"),
--                            (x"0801F2E2858EFC16"), (x"636920D871574E69"));

signal C : c_const :=      ((x"AE5F9156E7B6D99B"), (x"CF6C85D39D1A1E15"),
                            (x"2F73477D6A4563CA"), (x"6D1826CAFD82E1ED"),
                            (x"8B43D4570A51B936"), (x"E360B596DC380C3F"),
                            (x"1C456002CE13E9F8"), (x"6F19633143A0AF0E"),
                            (x"D94EBEB1AB313933"), (x"0CC4A61194F81760"),
                            (x"261DC1F2B8A998C8"), (x"5815A7BE0543C11C"),
                            (x"70B7ED67FC9B5C42"), (x"A1513C69681AD6D4"),
                            (x"44F9363580E83D02"), (x"720DCDFD9DBA5B44"));


--type InitialVector is array (0 to 7) of std_logic_vector(63 downto 0);
--signal IV : InitialVector :=        ((x"6A09E667F3BCC908"), (x"BB67AE8584CAA73B"),
--                                     (x"3C6EF372FE94F82B"), (x"A54FF53A5F1D36F1"),
--                                     (x"510E527FADE682D1"), (x"9B05688C2B3E6C1F"),
--                                     (x"1F83D9ABFB41BD6B"), (x"5BE0CD19137E2179")); 
                            


component reg_64_v00 is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           en : in STD_LOGIC;
           init : in STD_LOGIC;
           date_IV : in STD_LOGIC_VECTOR (63 downto 0);
           data_in : in STD_LOGIC_VECTOR (63 downto 0);
           data_out : out STD_LOGIC_VECTOR (63 downto 0));
end component;

component reg_64_v01 is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           en : in STD_LOGIC;
           init : in STD_LOGIC;
           date_IV : in STD_LOGIC_VECTOR (63 downto 0);
           data_in : in STD_LOGIC_VECTOR (63 downto 0);
           data_out : out STD_LOGIC_VECTOR (63 downto 0));
end component;

component reg_64_v02 is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           en : in STD_LOGIC;
           init : in STD_LOGIC;
           date_IV : in STD_LOGIC_VECTOR (63 downto 0);
           data_in : in STD_LOGIC_VECTOR (63 downto 0);
           data_out : out STD_LOGIC_VECTOR (63 downto 0));
end component;

component reg_64_v03 is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           en : in STD_LOGIC;
           init : in STD_LOGIC;
           date_IV : in STD_LOGIC_VECTOR (63 downto 0);
           data_in : in STD_LOGIC_VECTOR (63 downto 0);
           data_out : out STD_LOGIC_VECTOR (63 downto 0));
end component;

component reg_64_v04 is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           en : in STD_LOGIC;
           init : in STD_LOGIC;
           date_IV : in STD_LOGIC_VECTOR (63 downto 0);
           data_in : in STD_LOGIC_VECTOR (63 downto 0);
           data_out : out STD_LOGIC_VECTOR (63 downto 0));
end component;

component reg_64_v05 is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           en : in STD_LOGIC;
           init : in STD_LOGIC;
           date_IV : in STD_LOGIC_VECTOR (63 downto 0);
           data_in : in STD_LOGIC_VECTOR (63 downto 0);
           data_out : out STD_LOGIC_VECTOR (63 downto 0));
end component;

component reg_64_v06 is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           en : in STD_LOGIC;
           init : in STD_LOGIC;
           date_IV : in STD_LOGIC_VECTOR (63 downto 0);
           data_in : in STD_LOGIC_VECTOR (63 downto 0);
           data_out : out STD_LOGIC_VECTOR (63 downto 0));
end component;

component reg_64_v07 is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           en : in STD_LOGIC;
           init : in STD_LOGIC;
           date_IV : in STD_LOGIC_VECTOR (63 downto 0);
           data_in : in STD_LOGIC_VECTOR (63 downto 0);
           data_out : out STD_LOGIC_VECTOR (63 downto 0));
end component;

component reg_64_v08 is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           en : in STD_LOGIC;
           init : in STD_LOGIC;
           salt : in STD_LOGIC_VECTOR (63 downto 0);
           const : in STD_LOGIC_VECTOR (63 downto 0);
           data_in : in STD_LOGIC_VECTOR (63 downto 0);
           data_out : out STD_LOGIC_VECTOR (63 downto 0));
end component;

component reg_64_v09 is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           en : in STD_LOGIC;
           init : in STD_LOGIC;
           salt : in STD_LOGIC_VECTOR (63 downto 0);
           const : in STD_LOGIC_VECTOR (63 downto 0);
           data_in : in STD_LOGIC_VECTOR (63 downto 0);
           data_out : out STD_LOGIC_VECTOR (63 downto 0));
end component;

component reg_64_v10 is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           en : in STD_LOGIC;
           init : in STD_LOGIC;
           salt : in STD_LOGIC_VECTOR (63 downto 0);
           const : in STD_LOGIC_VECTOR (63 downto 0);
           data_in : in STD_LOGIC_VECTOR (63 downto 0);
           data_out : out STD_LOGIC_VECTOR (63 downto 0));
end component;

component reg_64_v11 is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           en : in STD_LOGIC;
           init : in STD_LOGIC;
           salt : in STD_LOGIC_VECTOR (63 downto 0);
           const : in STD_LOGIC_VECTOR (63 downto 0);
           data_in : in STD_LOGIC_VECTOR (63 downto 0);
           data_out : out STD_LOGIC_VECTOR (63 downto 0));
end component;

component reg_64_v12 is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           en : in STD_LOGIC;
           init : in STD_LOGIC;
           count : in STD_LOGIC_VECTOR (63 downto 0);
           const : in STD_LOGIC_VECTOR (63 downto 0);
           data_in : in STD_LOGIC_VECTOR (63 downto 0);
           data_out : out STD_LOGIC_VECTOR (63 downto 0));
end component;

component reg_64_v13 is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           en : in STD_LOGIC;
           init : in STD_LOGIC;
           count : in STD_LOGIC_VECTOR (63 downto 0);
           const : in STD_LOGIC_VECTOR (63 downto 0);
           data_in : in STD_LOGIC_VECTOR (63 downto 0);
           data_out : out STD_LOGIC_VECTOR (63 downto 0));
end component;

component reg_64_v14 is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           en : in STD_LOGIC;
           init : in STD_LOGIC;
           count : in STD_LOGIC_VECTOR (63 downto 0);
           const : in STD_LOGIC_VECTOR (63 downto 0);
           data_in : in STD_LOGIC_VECTOR (63 downto 0);
           data_out : out STD_LOGIC_VECTOR (63 downto 0));
end component;

component reg_64_v15 is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           en : in STD_LOGIC;
           init : in STD_LOGIC;
           count : in STD_LOGIC_VECTOR (63 downto 0);
           const : in STD_LOGIC_VECTOR (63 downto 0);
           data_in : in STD_LOGIC_VECTOR (63 downto 0);
           data_out : out STD_LOGIC_VECTOR (63 downto 0));
end component;

component perm is
Port (
        address_r : in std_logic_vector(3 downto 0);
        address_i : in std_logic_vector(3 downto 0);
        date_out  : out integer range 0 to 15
 );
end component;


component g_function 
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
end component;

component round_f_controller 
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
end component;


component mux2_1 
    Port (
            data_in1        :   in STD_LOGIC_VECTOR (63 downto 0);
            data_in2        :   in STD_LOGIC_VECTOR (63 downto 0);
            sel             :   in STD_LOGIC;
            data_out        :   out STD_LOGIC_VECTOR(63 downto 0)
    );
end component;

--initialization signals
 constant Word_Width          : integer :=  64;


-- constants registers signals
--signal en_reg               : STD_LOGIC;
--signal init_reg             : STD_LOGIC;
signal h00                   : STD_LOGIC_VECTOR (63 downto 0);
signal v00                   : STD_LOGIC_VECTOR (63 downto 0);
signal h01                   : STD_LOGIC_VECTOR (63 downto 0);
signal v01                   : STD_LOGIC_VECTOR (63 downto 0);
signal h02                   : STD_LOGIC_VECTOR (63 downto 0);
signal v02                   : STD_LOGIC_VECTOR (63 downto 0);
signal h03                   : STD_LOGIC_VECTOR (63 downto 0);
signal v03                   : STD_LOGIC_VECTOR (63 downto 0);
signal h04                   : STD_LOGIC_VECTOR (63 downto 0);
signal v04                   : STD_LOGIC_VECTOR (63 downto 0);
signal h05                   : STD_LOGIC_VECTOR (63 downto 0);
signal v05                   : STD_LOGIC_VECTOR (63 downto 0);
signal h06                   : STD_LOGIC_VECTOR (63 downto 0);
signal v06                   : STD_LOGIC_VECTOR (63 downto 0);
signal h07                   : STD_LOGIC_VECTOR (63 downto 0);
signal v07                   : STD_LOGIC_VECTOR (63 downto 0);
signal salt0                : STD_LOGIC_VECTOR (63 downto 0);
signal v08_temp              : STD_LOGIC_VECTOR (63 downto 0);
signal v08                   : STD_LOGIC_VECTOR (63 downto 0);
signal salt1                : STD_LOGIC_VECTOR (63 downto 0);
signal v09_temp              : STD_LOGIC_VECTOR (63 downto 0);
signal v09                   : STD_LOGIC_VECTOR (63 downto 0);
signal salt2                : STD_LOGIC_VECTOR (63 downto 0);
signal v10_temp             : STD_LOGIC_VECTOR (63 downto 0);
signal v10                  : STD_LOGIC_VECTOR (63 downto 0);
signal salt3                : STD_LOGIC_VECTOR (63 downto 0);
signal v11_temp             : STD_LOGIC_VECTOR (63 downto 0);
signal v11                  : STD_LOGIC_VECTOR (63 downto 0);
signal count0               : STD_LOGIC_VECTOR (63 downto 0);
signal v12_temp             : STD_LOGIC_VECTOR (63 downto 0);
signal v12                  : STD_LOGIC_VECTOR (63 downto 0);
signal v13_temp             : STD_LOGIC_VECTOR (63 downto 0);
signal v13                  : STD_LOGIC_VECTOR (63 downto 0);
signal count1               : STD_LOGIC_VECTOR (63 downto 0);
signal v14_temp             : STD_LOGIC_VECTOR (63 downto 0);
signal v14                  : STD_LOGIC_VECTOR (63 downto 0);
signal v15_temp             : STD_LOGIC_VECTOR (63 downto 0);
signal v15                  : STD_LOGIC_VECTOR (63 downto 0);

signal v00_prim             : STD_LOGIC_VECTOR (63 downto 0);
signal v04_prim             : STD_LOGIC_VECTOR (63 downto 0);
signal v08_prim             : STD_LOGIC_VECTOR (63 downto 0);
signal v12_prim             : STD_LOGIC_VECTOR (63 downto 0);

signal v01_prim             : STD_LOGIC_VECTOR (63 downto 0);
signal v05_prim             : STD_LOGIC_VECTOR (63 downto 0);
signal v09_prim             : STD_LOGIC_VECTOR (63 downto 0);
signal v13_prim             : STD_LOGIC_VECTOR (63 downto 0);

signal v02_prim             : STD_LOGIC_VECTOR (63 downto 0);
signal v06_prim             : STD_LOGIC_VECTOR (63 downto 0);
signal v10_prim             : STD_LOGIC_VECTOR (63 downto 0);
signal v14_prim             : STD_LOGIC_VECTOR (63 downto 0);

signal v03_prim             : STD_LOGIC_VECTOR (63 downto 0);
signal v07_prim             : STD_LOGIC_VECTOR (63 downto 0);
signal v11_prim             : STD_LOGIC_VECTOR (63 downto 0);
signal v15_prim             : STD_LOGIC_VECTOR (63 downto 0);

signal msg_2i_g00               : STD_LOGIC_VECTOR (127 downto 0);


signal const_2i_g00          : STD_LOGIC_VECTOR (127 downto 0);


signal msg_2i_g01               : STD_LOGIC_VECTOR (127 downto 0);

signal const_2i_g01          : STD_LOGIC_VECTOR (127 downto 0);


signal msg_2i_g02               : STD_LOGIC_VECTOR (127 downto 0);

signal const_2i_g02          : STD_LOGIC_VECTOR (127 downto 0);


signal msg_2i_g03               : STD_LOGIC_VECTOR (127 downto 0);

signal const_2i_g03          : STD_LOGIC_VECTOR (127 downto 0);


signal msg_2i_g04               : STD_LOGIC_VECTOR (127 downto 0);

signal const_2i_g04          : STD_LOGIC_VECTOR (127 downto 0);


signal msg_2i_g05               : STD_LOGIC_VECTOR (127 downto 0);

signal const_2i_g05          : STD_LOGIC_VECTOR (127 downto 0);


signal msg_2i_g06               : STD_LOGIC_VECTOR (127 downto 0);

signal const_2i_g06          : STD_LOGIC_VECTOR (127 downto 0);


signal msg_2i_g07               : STD_LOGIC_VECTOR (127 downto 0);

signal const_2i_g07          : STD_LOGIC_VECTOR (127 downto 0);



--permutation signals
signal s_address1_r       :integer range 0 to 15;
signal s_address1_i       :integer range 0 to 15;

signal inv_s_perm_2i      :integer range 0 to 15;

signal s_address_r       :integer range 0 to 15;
signal s_address_i       :integer range 0 to 15;

signal inv_s_perm_2i_1   :integer range 0 to 15;

signal round                    : std_logic_vector (3 downto 0);

signal s_perm_2i_r0_i0           :integer range 0 to 15;
signal s_perm_2i_1_r0_i0        :integer range 0 to 15;
signal s_perm_2i_r0_i1           :integer range 0 to 15;
signal s_perm_2i_1_r0_i1        :integer range 0 to 15;
signal s_perm_2i_r0_i2          :integer range 0 to 15;
signal s_perm_2i_1_r0_i2        :integer range 0 to 15;
signal s_perm_2i_r0_i3          :integer range 0 to 15;
signal s_perm_2i_1_r0_i3        :integer range 0 to 15;
signal s_perm_2i_r0_i4          :integer range 0 to 15;
signal s_perm_2i_1_r0_i4        :integer range 0 to 15;
signal s_perm_2i_r0_i5          :integer range 0 to 15;
signal s_perm_2i_1_r0_i5        :integer range 0 to 15;
signal s_perm_2i_r0_i6          :integer range 0 to 15;
signal s_perm_2i_1_r0_i6        :integer range 0 to 15;
signal s_perm_2i_r0_i7          :integer range 0 to 15;
signal s_perm_2i_1_r0_i7        :integer range 0 to 15;


signal en_reg                   : STD_LOGIC;
signal init_reg                 : STD_LOGIC;
signal ready_temp               : STD_LOGIC;

signal h00_prim                 : STD_LOGIC_VECTOR(63 downto 0);
signal h01_prim                 : STD_LOGIC_VECTOR(63 downto 0);
signal h02_prim                 : STD_LOGIC_VECTOR(63 downto 0);
signal h03_prim                 : STD_LOGIC_VECTOR(63 downto 0);
signal h04_prim                 : STD_LOGIC_VECTOR(63 downto 0);
signal h05_prim                 : STD_LOGIC_VECTOR(63 downto 0);
signal h06_prim                 : STD_LOGIC_VECTOR(63 downto 0);
signal h07_prim                 : STD_LOGIC_VECTOR(63 downto 0);

signal h00_in                 : STD_LOGIC_VECTOR(63 downto 0);
signal h01_in                 : STD_LOGIC_VECTOR(63 downto 0);
signal h02_in                 : STD_LOGIC_VECTOR(63 downto 0);
signal h03_in                 : STD_LOGIC_VECTOR(63 downto 0);
signal h04_in                 : STD_LOGIC_VECTOR(63 downto 0);
signal h05_in                 : STD_LOGIC_VECTOR(63 downto 0);
signal h06_in                 : STD_LOGIC_VECTOR(63 downto 0);
signal h07_in                 : STD_LOGIC_VECTOR(63 downto 0);

signal blake512_aux           : STD_LOGIC_VECTOR (511 downto 0);
--

begin


salt0 <= salt256(Word_Width*4-1 downto Word_Width*3);
salt1 <= salt256(Word_Width*3-1 downto Word_Width*2);
salt2 <= salt256(Word_Width*2-1 downto Word_Width);
salt3 <= salt256(Word_Width-1 downto 0);

count0 <= count(Word_Width*2-1 downto Word_Width);
count1 <= count(Word_Width-1 downto 0);

register_64_v00 : reg_64_v00 
    Port Map ( clk          => clk,
               rst          => rst,
               en           => en_reg,
               init         => init_reg,
               date_IV      => IV512(8*Word_Width-1 downto 7*Word_Width),
               data_in      => h00_in,
               data_out     => v00);

register_64_v01 : reg_64_v01 
    Port Map ( clk          => clk,
               rst          => rst,
               en           => en_reg,
               init         => init_reg,
               date_IV      => IV512(7*Word_Width-1 downto 6*Word_Width),
               data_in      => h01_in,
               data_out     => v01);

register_64_v02 : reg_64_v02 
    Port Map ( clk          => clk,
               rst          => rst,
               en           => en_reg,
               init         => init_reg,
               date_IV      => IV512(6*Word_Width-1 downto 5*Word_Width),
               data_in      => h02_in,
               data_out     => v02);

register_64_v03 : reg_64_v03 
    Port Map ( clk          => clk,
               rst          => rst,
               en           => en_reg,
               init         => init_reg,
               date_IV      => IV512(5*Word_Width-1 downto 4*Word_Width),
               data_in      => h03_in,
               data_out     => v03);

register_64_v04 : reg_64_v04 
    Port Map ( clk          => clk,
               rst          => rst,
               en           => en_reg,
               init         => init_reg,
               date_IV      => IV512(4*Word_Width-1 downto 3*Word_Width),
               data_in      => h04_in,
               data_out     => v04);

register_64_v05 : reg_64_v05 
    Port Map ( clk          => clk,
               rst          => rst,
               en           => en_reg,
               init         => init_reg,
               date_IV      => IV512(3*Word_Width-1 downto 2*Word_Width),
               data_in      => h05_in,
               data_out     => v05);

register_64_v06 : reg_64_v06 
    Port Map ( clk          => clk,
               rst          => rst,
               en           => en_reg,
               init         => init_reg,
               date_IV      => IV512(2*Word_Width-1 downto Word_Width),
               data_in      => h06_in,
               data_out     => v06);

register_64_v07 : reg_64_v07 
    Port Map ( clk          => clk,
               rst          => rst,
               en           => en_reg,
               init         => init_reg,
               date_IV      => IV512(Word_Width-1 downto 0),
               data_in      => h07_in,
               data_out     => v07);

register_64_v08 : reg_64_v08 
    Port Map ( clk          => clk,
               rst          => rst,
               en           => en_reg,
               init         => init_reg,
               salt         => salt0,
               const        => C(0),
               data_in      => v08_temp,
               data_out     => v08);

register_64_v09 : reg_64_v09 
    Port Map ( clk          => clk,
               rst          => rst,
               en           => en_reg,
               init         => init_reg,
               salt         => salt1,
               const        => C(1),
               data_in      => v09_temp,
               data_out     => v09);

register_64_v10 : reg_64_v10 
    Port Map ( clk          => clk,
               rst          => rst,
               en           => en_reg,
               init         => init_reg,
               salt         => salt2,
               const        => C(2),
               data_in      => v10_temp,
               data_out     => v10);

register_64_v11 : reg_64_v11
    Port Map ( clk          => clk,
               rst          => rst,
               en           => en_reg,
               init         => init_reg,
               salt         => salt3,
               const        => C(3),
               data_in      => v11_temp,
               data_out     => v11);

register_64_v12 : reg_64_v12 
    Port Map ( clk          => clk,
               rst          => rst,
               en           => en_reg,
               init         => init_reg,
               count        => count0,
               const        => C(4),
               data_in      => v12_temp,
               data_out     => v12);

register_64_v13 : reg_64_v13 
    Port Map ( clk          => clk,
               rst          => rst,
               en           => en_reg,
               init         => init_reg,
               count        => count0,
               const        => C(5),
               data_in      => v13_temp,
               data_out     => v13);

register_64_v14 : reg_64_v14 
    Port Map ( clk          => clk,
               rst          => rst,
               en           => en_reg,
               init         => init_reg,
               count        => count1,
               const        => C(6),
               data_in      => v14_temp,
               data_out     => v14);

register_64_v15 : reg_64_v15 
    Port Map ( clk          => clk,
               rst          => rst,
               en           => en_reg,
               init         => init_reg,
               count        => count1,
               const        => C(7),
               data_in      => v15_temp,
               data_out     => v15);

perm_2i_r0_i0      : perm
Port Map(
       address_r            =>  round,
       address_i            =>  x"0",--s_address_i,
       date_out             =>  s_perm_2i_r0_i0
);
               
perm_2i_1_r0_i0       : perm
Port Map(
       address_r            =>  round,
       address_i            =>  x"1",--s_address1_i,
       date_out             =>  s_perm_2i_1_r0_i0
);

perm_2i_r0_i1      : perm
Port Map(
       address_r            =>  round,
       address_i            =>  x"2",
       date_out             =>  s_perm_2i_r0_i1
);
               
perm_2i_1_r0_i1       : perm
Port Map(
       address_r            =>  round,
       address_i            =>  x"3",
       date_out             =>  s_perm_2i_1_r0_i1
);

perm_2i_r0_i2      : perm
Port Map(
       address_r            =>  round,
       address_i            =>  x"4",
       date_out             =>  s_perm_2i_r0_i2
);
               
perm_2i_1_r0_i2       : perm
Port Map(
       address_r            =>  round,
       address_i            =>  x"5",
       date_out             =>  s_perm_2i_1_r0_i2
);

perm_2i_r0_i3      : perm
Port Map(
       address_r            =>  round,
       address_i            =>  x"6",
       date_out             =>  s_perm_2i_r0_i3
);
               
perm_2i_1_r0_i3       : perm
Port Map(
       address_r            =>  round,
       address_i            =>  x"7",
       date_out             =>  s_perm_2i_1_r0_i3
);

perm_2i_r0_i4      : perm
Port Map(
       address_r            =>  round,
       address_i            =>  x"8",
       date_out             =>  s_perm_2i_r0_i4 
);
               
perm_2i_1_r0_i4       : perm
Port Map(
       address_r            =>  round,
       address_i            =>  x"9",
       date_out             =>  s_perm_2i_1_r0_i4 
);

perm_2i_r0_i5      : perm
Port Map(
       address_r            =>  round,
       address_i            =>  x"a",
       date_out             =>  s_perm_2i_r0_i5 
);
               
perm_2i_1_r0_i5       : perm
Port Map(
       address_r            =>  round,
       address_i            =>  x"b",
       date_out             =>  s_perm_2i_1_r0_i5 
);

perm_2i_r0_i6      : perm
Port Map(
       address_r            =>  round,
       address_i            =>  x"c",
       date_out             =>  s_perm_2i_r0_i6 
);
               
perm_2i_1_r0_i6       : perm
Port Map(
       address_r            =>  round,
       address_i            =>  x"d",
       date_out             =>  s_perm_2i_1_r0_i6 
);

perm_2i_r0_i7      : perm
Port Map(
       address_r            =>  round,
       address_i            =>  x"e",
       date_out             =>  s_perm_2i_r0_i7 
);
               
perm_2i_1_r0_i7       : perm
Port Map(
       address_r            =>  round,
       address_i            =>  x"f",
       date_out             =>  s_perm_2i_1_r0_i7 
);




msg_2i_g00 <= msg(1023-Word_width*s_perm_2i_r0_i0 downto 960-Word_width*s_perm_2i_r0_i0) & msg(1023-Word_width*s_perm_2i_1_r0_i0 downto 960-Word_width*s_perm_2i_1_r0_i0);
const_2i_g00 <= C(s_perm_2i_r0_i0) & C(s_perm_2i_1_r0_i0);

g00_function: g_function
Port Map(
           in_a            =>   v00,
           in_b            =>   v04,
           in_c            =>   v08,
           in_d            =>   v12,
           const           =>   const_2i_g00,
           mess            =>   msg_2i_g00,
           out_a           =>   v00_prim,
           out_b           =>   v04_prim,
           out_c           =>   v08_prim,
           out_d           =>   v12_prim
);




msg_2i_g01 <= msg(1023-Word_width*s_perm_2i_r0_i1 downto 960-Word_width*s_perm_2i_r0_i1) & msg(1023-Word_width*s_perm_2i_1_r0_i1 downto 960-Word_width*s_perm_2i_1_r0_i1);
const_2i_g01 <= C(s_perm_2i_r0_i1) & C(s_perm_2i_1_r0_i1);

g01_function: g_function
Port Map(
           in_a            =>   v01,
           in_b            =>   v05,
           in_c            =>   v09,
           in_d            =>   v13,
           const           =>   const_2i_g01,
           mess            =>   msg_2i_g01,
           out_a           =>   v01_prim,
           out_b           =>   v05_prim,
           out_c           =>   v09_prim,
           out_d           =>   v13_prim
);




msg_2i_g02 <= msg(1023-Word_width*s_perm_2i_r0_i2 downto 960-Word_width*s_perm_2i_r0_i2) & msg(1023-Word_width*s_perm_2i_1_r0_i2 downto 960-Word_width*s_perm_2i_1_r0_i2);
const_2i_g02 <= C(s_perm_2i_r0_i2) & C(s_perm_2i_1_r0_i2);

g02_function: g_function
Port Map(
           in_a            =>   v02,
           in_b            =>   v06,
           in_c            =>   v10,
           in_d            =>   v14,
           const           =>   const_2i_g02,
           mess            =>   msg_2i_g02,
           out_a           =>   v02_prim,
           out_b           =>   v06_prim,
           out_c           =>   v10_prim,
           out_d           =>   v14_prim
);




msg_2i_g03 <= msg(1023-Word_width*s_perm_2i_r0_i3 downto 960-Word_width*s_perm_2i_r0_i3) & msg(1023-Word_width*s_perm_2i_1_r0_i3 downto 960-Word_width*s_perm_2i_1_r0_i3);
const_2i_g03 <= C(s_perm_2i_r0_i3) & C(s_perm_2i_1_r0_i3);

g03_function: g_function
Port Map(
           in_a            =>   v03,
           in_b            =>   v07,
           in_c            =>   v11,
           in_d            =>   v15,
           const           =>   const_2i_g03,
           mess            =>   msg_2i_g03,
           out_a           =>   v03_prim,
           out_b           =>   v07_prim,
           out_c           =>   v11_prim,
           out_d           =>   v15_prim
);




msg_2i_g04 <= msg(1023-Word_width*s_perm_2i_r0_i4 downto 960-Word_width*s_perm_2i_r0_i4) & msg(1023-Word_width*s_perm_2i_1_r0_i4 downto 960-Word_width*s_perm_2i_1_r0_i4);
const_2i_g04 <= C(s_perm_2i_r0_i4) & C(s_perm_2i_1_r0_i4);

g04_function: g_function
Port Map(
           in_a            =>   v00_prim,
           in_b            =>   v05_prim,
           in_c            =>   v10_prim,
           in_d            =>   v15_prim,
           const           =>   const_2i_g04,
           mess            =>   msg_2i_g04,
           out_a           =>   h00,
           out_b           =>   h05,
           out_c           =>   v10_temp,
           out_d           =>   v15_temp
);




msg_2i_g05 <= msg(1023-Word_width*s_perm_2i_r0_i5 downto 960-Word_width*s_perm_2i_r0_i5) & msg(1023-Word_width*s_perm_2i_1_r0_i5 downto 960-Word_width*s_perm_2i_1_r0_i5);
const_2i_g05 <= C(s_perm_2i_r0_i5) & C(s_perm_2i_1_r0_i5);

g05_function: g_function
Port Map(
           in_a            =>   v01_prim,
           in_b            =>   v06_prim,
           in_c            =>   v11_prim,
           in_d            =>   v12_prim,
           const           =>   const_2i_g05,
           mess            =>   msg_2i_g05,
           out_a           =>   h01,
           out_b           =>   h06,
           out_c           =>   v11_temp,
           out_d           =>   v12_temp
);




msg_2i_g06 <= msg(1023-Word_width*s_perm_2i_r0_i6 downto 960-Word_width*s_perm_2i_r0_i6) & msg(1023-Word_width*s_perm_2i_1_r0_i6 downto 960-Word_width*s_perm_2i_1_r0_i6);
const_2i_g06 <= C(s_perm_2i_r0_i6) & C(s_perm_2i_1_r0_i6);

g06_function: g_function
Port Map(
           in_a            =>   v02_prim,
           in_b            =>   v07_prim,
           in_c            =>   v08_prim,
           in_d            =>   v13_prim,
           const           =>   const_2i_g06,
           mess            =>   msg_2i_g06,
           out_a           =>   h02,
           out_b           =>   h07,
           out_c           =>   v08_temp,
           out_d           =>   v13_temp
);




msg_2i_g07 <= msg(1023-Word_width*s_perm_2i_r0_i7 downto 960-Word_width*s_perm_2i_r0_i7) & msg(1023-Word_width*s_perm_2i_1_r0_i7 downto 960-Word_width*s_perm_2i_1_r0_i7);
const_2i_g07 <= C(s_perm_2i_r0_i7) & C(s_perm_2i_1_r0_i7);

g07_function: g_function
Port Map(
           in_a            =>   v03_prim,
           in_b            =>   v04_prim,
           in_c            =>   v09_prim,
           in_d            =>   v14_prim,
           const           =>   const_2i_g07,
           mess            =>   msg_2i_g07,
           out_a           =>   h03,
           out_b           =>   h04,
           out_c           =>   v09_temp,
           out_d           =>   v14_temp
);


controller: round_f_controller 
Port Map (
                clk                 => clk,
                rst                 => rst,
                start               => start,
                init                => init_reg,
                en                  => en_reg,
                busy                => busy,
                ready               => ready_temp,
                round               => round
        );

--ready <= ready_temp;

    h00_prim <= IV512(8*Word_Width-1 downto 7*Word_Width) xor salt0 xor h00 xor v08_temp;
    h01_prim <= IV512(7*Word_Width-1 downto 6*Word_Width) xor salt1 xor h01 xor v09_temp;
    h02_prim <= IV512(6*Word_Width-1 downto 5*Word_Width) xor salt2 xor h02 xor v10_temp;
    h03_prim <= IV512(5*Word_Width-1 downto 4*Word_Width) xor salt3 xor h03 xor v11_temp;
    h04_prim <= IV512(4*Word_Width-1 downto 3*Word_Width) xor salt0 xor h04 xor v12_temp;
    h05_prim <= IV512(3*Word_Width-1 downto 2*Word_Width) xor salt1 xor h05 xor v13_temp;
    h06_prim <= IV512(2*Word_Width-1 downto Word_Width) xor salt2 xor h06 xor v14_temp;
    h07_prim <= IV512(Word_Width-1 downto 0) xor salt3 xor h07 xor v15_temp;

hash64_00 :mux2_1 
    Port Map(
            data_in1        => h00,
            data_in2        => h00_prim,
            sel             => ready_temp,
            data_out        => h00_in
    );

hash64_01 :mux2_1 
    Port Map(
            data_in1        => h01,
            data_in2        => h01_prim,
            sel             => ready_temp,
            data_out        => h01_in
    );

hash64_02 :mux2_1 
    Port Map(
            data_in1        => h02,
            data_in2        => h02_prim,
            sel             => ready_temp,
            data_out        => h02_in
    );


hash64_03 :mux2_1 
    Port Map(
            data_in1        => h03,
            data_in2        => h03_prim,
            sel             => ready_temp,
            data_out        => h03_in
    );

hash64_04 :mux2_1 
    Port Map(
            data_in1        => h04,
            data_in2        => h04_prim,
            sel             => ready_temp,
            data_out        => h04_in
    );

hash64_05 :mux2_1 
    Port Map(
            data_in1        => h05,
            data_in2        => h05_prim,
            sel             => ready_temp,
            data_out        => h05_in
    );

hash64_06 :mux2_1 
    Port Map(
            data_in1        => h06,
            data_in2        => h06_prim,
            sel             => ready_temp,
            data_out        => h06_in
    );

hash64_07 :mux2_1 
    Port Map(
            data_in1        => h07,
            data_in2        => h07_prim,
            sel             => ready_temp,
            data_out        => h07_in
    );
    
   

blake512_aux<=h00_prim &
              h01_prim &
              h02_prim &
              h03_prim &
              h04_prim &
              h05_prim &
              h06_prim &
              h07_prim;
              
    process (clk)
    begin
        if (clk'event and clk = '1') then
            if(rst = '1') then
                blake512 <= (others => '0');
                ready <= '0';
            elsif(ready_temp = '1') then
                blake512 <= blake512_aux;
                ready <= ready_temp;
            else
                ready <= ready_temp;
            end if;
        else
        
        end if;
    end process;
 
end Behavioral;
