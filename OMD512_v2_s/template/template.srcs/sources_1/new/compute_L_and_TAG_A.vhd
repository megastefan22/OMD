----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/26/2019 03:44:40 PM
-- Design Name: 
-- Module Name: compute_L_and_TAG_A - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity compute_L_and_TAG_A is
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
end compute_L_and_TAG_A;

architecture Behavioral of compute_L_and_TAG_A is

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

component mux2_1_512 is
    Port ( data1_in : in STD_LOGIC_VECTOR (511 downto 0);
           data2_in : in STD_LOGIC_VECTOR (511 downto 0);
           sel : in STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR (511 downto 0));
end component;

component mux2_1_1024 is
    Port ( data1_in : in STD_LOGIC_VECTOR (1023 downto 0);
           data2_in : in STD_LOGIC_VECTOR (1023 downto 0);
           sel : in STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR (1023 downto 0));
end component;


component reg_en_512 is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           en : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR (511 downto 0);
           data_out : out STD_LOGIC_VECTOR (511 downto 0));
end component;

component reg_en_tag_a is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           en : in STD_LOGIC;
           init : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR (511 downto 0);
           data_out : out STD_LOGIC_VECTOR (511 downto 0));
end component;

component ram16x512 is
    Port ( clk : in  STD_LOGIC;
           wr_en : in  STD_LOGIC;
           wr_addr : in  STD_LOGIC_VECTOR (3 downto 0);
           wr_data : in  STD_LOGIC_VECTOR (511 downto 0);
           rd_addr : in  STD_LOGIC_VECTOR (3 downto 0);
           rd_data : out  STD_LOGIC_VECTOR (511 downto 0));
end component;

component ram16x1024 is
    Port ( clk : in  STD_LOGIC;
           wr_en : in  STD_LOGIC;
           wr_addr : in  STD_LOGIC_VECTOR (3 downto 0);
           wr_data : in  STD_LOGIC_VECTOR (1023 downto 0);
           rd_addr : in  STD_LOGIC_VECTOR (3 downto 0);
           rd_data : out  STD_LOGIC_VECTOR (1023 downto 0));
end component;

component ntz_i is
    Port ( data_in_LUT : in STD_LOGIC_VECTOR (7 downto 0);
           data_out_LUT : out STD_LOGIC_VECTOR (7 downto 0));
end component;

constant    double_alpha_mask    : STD_LOGIC_VECTOR(511 downto 0) := x"00000000_00000000_00000000_00000000"&--0^503||100100101
                                                                     x"00000000_00000000_00000000_00000000"&
                                                                     x"00000000_00000000_00000000_00000000"&
                                                                     x"00000000_00000000_00000000_00000125";
                                                                     
constant    delta_n_00           : STD_LOGIC_VECTOR(511 downto 0) := x"00000000_00000000_00000000_00000000"&--0^512
                                                                     x"00000000_00000000_00000000_00000000"&
                                                                     x"00000000_00000000_00000000_00000000"&
                                                                     x"00000000_00000000_00000000_00000000";

signal count_L              : STD_LOGIC_VECTOR(2 downto 0);

signal msg_blake            : STD_LOGIC_VECTOR(1023 downto 0);
signal iv_blake             : STD_LOGIC_VECTOR( 511 downto 0):=(others => '0');
signal blake512_L_STAR_out  : STD_LOGIC_VECTOR( 511 downto 0);
signal wr_addr_ram_l_temp   : STD_LOGIC_VECTOR(   3 downto 0):=(others => '0');
signal wr_data_ram_l_temp   : STD_LOGIC_VECTOR( 511 downto 0):=(others => '0');
signal L_STAR_x2            : STD_LOGIC_VECTOR( 511 downto 0);
signal L_STAR_x4            : STD_LOGIC_VECTOR( 511 downto 0);
signal L_0                  : STD_LOGIC_VECTOR( 511 downto 0);
signal reg_GF_x2            : STD_LOGIC_VECTOR( 511 downto 0);
signal GF_x2                : STD_LOGIC_VECTOR( 511 downto 0);
signal mux_data_LSTAR_Li    : STD_LOGIC_VECTOR( 511 downto 0);
signal mux_data_delta_N     : STD_LOGIC_VECTOR( 511 downto 0);
signal mux_data_iv_blake    : STD_LOGIC_VECTOR( 511 downto 0);
signal mux_data_msg_blake   : STD_LOGIC_VECTOR(1023 downto 0);
signal delta_N              : STD_LOGIC_VECTOR( 511 downto 0);
signal reg_delta_N          : STD_LOGIC_VECTOR( 511 downto 0);
signal reg_tag_a            : STD_LOGIC_VECTOR( 511 downto 0);
signal tag_a                : STD_LOGIC_VECTOR( 511 downto 0);
signal wr_addr_local_ram_L  : STD_LOGIC_VECTOR(   3 downto 0);
signal wr_addr_local_ram_delta_N  : STD_LOGIC_VECTOR(   3 downto 0);
signal wr_addr_local_ram_AAD  : STD_LOGIC_VECTOR(   3 downto 0);
signal wr_data_local_ram_L  : STD_LOGIC_VECTOR( 511 downto 0);
signal wr_data_local_ram_delta_N  : STD_LOGIC_VECTOR( 511 downto 0);
signal wr_data_local_ram_AAD  : STD_LOGIC_VECTOR( 1023 downto 0);
signal rd_addr_local_ram_L  : STD_LOGIC_VECTOR(   3 downto 0);
signal rd_addr_local_ram_delta_N  : STD_LOGIC_VECTOR(   3 downto 0);
signal rd_addr_local_ram_AAD  : STD_LOGIC_VECTOR(   3 downto 0);
signal rd_data_local_ram_L  : STD_LOGIC_VECTOR( 511 downto 0);
signal rd_data_local_ram_delta_N  : STD_LOGIC_VECTOR( 511 downto 0);
signal rd_data_local_ram_AAD  : STD_LOGIC_VECTOR( 1023 downto 0);
signal L_temp               : STD_LOGIC_VECTOR( 511 downto 0):=(others => '0');
signal ntz_i_input          : STD_LOGIC_VECTOR(   7 downto 0);
signal ntz_i_output         : STD_LOGIC_VECTOR(   7 downto 0);
signal delta_N_counter      : STD_LOGIC_VECTOR(   7 downto 0);


signal start_blake          : STD_LOGIC;
signal busy_blake           : STD_LOGIC;
signal ready_blake          : STD_LOGIC;
signal state                : integer range 0 to 63;
signal reg_en_GF_x2         : STD_LOGIC;
signal sel_mux_LSTAR_Li     : STD_LOGIC;
signal sel_mux_delta_N      : STD_LOGIC:='0';
signal sel_mux_blake        : STD_LOGIC:='0';
signal reg_en_delta_N       : STD_LOGIC;
signal reg_init_tag_a       : STD_LOGIC:= '0';
signal reg_en_tag_aad         : STD_LOGIC;
signal wr_en_local_ram_L    : STD_LOGIC; 
signal wr_en_local_ram_delta_N    : STD_LOGIC; 
signal wr_en_local_ram_AAD    : STD_LOGIC; 
signal wr_en_ram_l_temp     : STD_LOGIC; 

begin

WR_ADDR_RAM_L           <= wr_addr_ram_l_temp;
WR_DATA_RAM_L           <= wr_data_ram_l_temp;
WR_EN_RAM_L             <= wr_en_ram_l_temp;

wr_addr_local_ram_L     <= wr_addr_ram_l_temp;
wr_data_local_ram_L     <= wr_data_ram_l_temp;
wr_en_local_ram_L       <= wr_en_ram_l_temp;

GF_x2           <=  (mux_data_LSTAR_Li(510 downto 0) & '0') when (mux_data_LSTAR_Li(511) = '0') else
                    (mux_data_LSTAR_Li(510 downto 0) & '0') xor double_alpha_mask;

delta_N         <=  mux_data_delta_N xor rd_data_local_ram_L;                     
--L_STAR_x4     <= (          L_STAR_x2(510 downto 0) & '0') when           (L_STAR_x2(511) = '0') else
--                           (L_STAR_x2(510 downto 0) & '0') xor double_alpha_mask;
--L_0           <= L_STAR_x4;                         
                           
                 
--F_K(H,M) = F'(H, K || M)
--L_star <- F_K(0^512, <t>_m);
blake512_L_STAR: blake512
Port Map(   clk             => CLK,
            rst             => RST,
            msg             => mux_data_msg_blake,--TAU,-- key||<t>_m, m=512 biti
            salt256         => (others => '0'),
            count           => (others => '0'),
            start           => start_blake,
            IV512           => mux_data_iv_blake,--(others => '0'),--0^n = 0^512,
            busy            => busy_blake,
            ready           => ready_blake,
            blake512        => blake512_L_STAR_out);
            
mux_LSTAR_Li: mux2_1_512
Port Map (  data1_in        => blake512_L_STAR_out,
            data2_in        => reg_GF_x2,
            sel             => sel_mux_LSTAR_Li,
            data_out        => mux_data_LSTAR_Li);   

mux_delta_N: mux2_1_512
Port Map (  data1_in        => delta_n_00,
            data2_in        => reg_delta_N,
            sel             => sel_mux_delta_N,
            data_out        => mux_data_delta_N);
            
mux_iv_blake: mux2_1_512
Port Map (  data1_in        => (others => '0'),
            data2_in        => iv_blake,
            sel             => sel_mux_blake,
            data_out        => mux_data_iv_blake); 
            
iv_blake                    <=    rd_data_local_ram_delta_N xor rd_data_local_ram_AAD(1023 downto 512);     
 
msg_blake                   <= TAU(1023 downto 512) & rd_data_local_ram_AAD(511 downto 0);     --TAU(1023 downto 512) = key              
mux_msg_blake: mux2_1_1024
Port Map (  data1_in        => TAU,
            data2_in        => msg_blake,
            sel             => sel_mux_blake,
            data_out        => mux_data_msg_blake);   


                                    
register_GF_x2: reg_en_512
Port Map (  clk             =>  clk,
            reset           =>  rst,
            en              =>  reg_en_GF_x2,
            data_in         =>  GF_x2,
            data_out        =>  reg_GF_x2); 
            
register_delta_N: reg_en_512
Port Map (  clk             =>  clk,
            reset           =>  rst,
            en              =>  reg_en_delta_N,
            data_in         =>  delta_N,
            data_out        =>  reg_delta_N);     
               
register_tag_a: reg_en_tag_a
Port Map (  clk             =>  clk,
            reset           =>  rst,
            en              =>  reg_en_tag_aad,
            init            =>  reg_init_tag_a,
            data_in         =>  tag_a,--blake512_L_STAR_out,--tag_a,
            data_out        =>  reg_tag_a);        
            
tag_a       <= reg_tag_a xor  blake512_L_STAR_out;
TAG_A_OUT   <= reg_tag_a;
                        
local_ram_L:ram16x512 
Port Map    (   clk         =>  clk,
                wr_en       =>  wr_en_local_ram_L,
                wr_addr     =>  wr_addr_local_ram_L,
                wr_data     =>  wr_data_local_ram_L,
                rd_addr     =>  rd_addr_local_ram_L,
                rd_data     =>  rd_data_local_ram_L);

    wr_data_local_ram_delta_N <= reg_delta_N;

local_ram_delta_N:ram16x512 
Port Map    (   clk         =>  clk,
                wr_en       =>  wr_en_local_ram_delta_N,
                wr_addr     =>  wr_addr_local_ram_delta_N,
                wr_data     =>  wr_data_local_ram_delta_N,
                rd_addr     =>  rd_addr_local_ram_AAD,--rd_addr_local_ram_delta_N,
                rd_data     =>  rd_data_local_ram_delta_N);
                
local_ram_AAD:ram16x1024 
Port Map    (   clk         =>  clk,
                wr_en       =>  wr_en_local_ram_AAD,
                wr_addr     =>  wr_addr_local_ram_AAD,
                wr_data     =>  wr_data_local_ram_AAD,
                rd_addr     =>  rd_addr_local_ram_AAD,
                rd_data     =>  rd_data_local_ram_AAD);
                
ntz_i_LUT: ntz_i 
Port Map(       data_in_LUT     => delta_N_counter,
                data_out_LUT    => ntz_i_output);

    rd_addr_local_ram_L <= ntz_i_output(3 downto 0) + '1';

write_L_to_ram: process(CLK)  
begin
if(CLK'event and CLK = '1') then
    if(RST = '1') then
        wr_en_ram_l_temp    <= '0';
        wr_addr_ram_l_temp  <= (others => '0'); 
        wr_data_ram_l_temp  <= (others => '0');
        start_blake         <= '0';
        sel_mux_LSTAR_Li    <= '0';
        sel_mux_delta_N     <= '0';
        reg_en_GF_x2        <= '0';
        RDY                 <= '0'; 
        TAG_A_VLD           <= '0';
        count_L             <= (others => '0');
        reg_en_delta_N      <= '0';
        wr_addr_local_ram_delta_N     <= (others => '0');
        wr_en_local_ram_delta_N <= '0';
        rd_addr_local_ram_delta_N   <= (others => '0');
        rd_addr_local_ram_AAD   <= (others => '0');
        wr_en_local_ram_AAD   <= '0';
        wr_addr_local_ram_AAD   <= (others => '0');
        wr_data_local_ram_AAD   <= (others => '0');
        delta_N_counter     <= X"01";               --incepe numaratoarea de la i = 1;
        ntz_i_input         <= (others => '0');
        L_temp              <= (others => '0');
        reg_init_tag_a      <= '0';
        reg_en_tag_aad      <= '0';
        sel_mux_blake       <= '0';
        state               <= 0;
    else
        case state is
        when 0 =>
            sel_mux_blake    <= '0';
            if (STR = '1') then
                TAG_A_VLD   <= '0';
                start_blake <= '1';
                state       <= 1;
            end if;
        when 1 =>
            start_blake <= '0';
            state <= 2;
        when 2 =>
            if(ready_blake = '1') then
               wr_en_ram_l_temp     <= '1';
               wr_addr_ram_l_temp   <= (others => '0');
               wr_data_ram_l_temp   <= blake512_L_STAR_out;     -- write L_STAR
               sel_mux_LSTAR_Li     <= '0';
               state                <=  3; 
            end if;
        when 3 =>
            wr_en_ram_l_temp    <= '0';
            reg_en_GF_x2        <= '1';
            state               <=  4;
        when 4 =>
            reg_en_GF_x2        <= '0';
            sel_mux_LSTAR_Li    <= '1';
            state               <=  5;
        when 5 =>
            reg_en_GF_x2        <= '1';
            state               <=  6;
        when 6 =>
            reg_en_GF_x2        <= '0';
            state               <=  7;
        when 7 =>
            state               <=  8;    
        when 8 =>
            wr_en_ram_l_temp    <= '1';
            wr_addr_ram_l_temp  <= wr_addr_ram_l_temp + '1';
            wr_data_ram_l_temp  <= reg_GF_x2;                           --L0,L1,...
            state               <= 9;
        when 9 =>
            wr_en_ram_l_temp    <= '0';
            if(count_L = "111") then
                count_L         <= "000";    
                state           <= 40;
            else
                count_L         <= count_L + '1';
                state           <= 5;
            end if;
        when 40 => 
            sel_mux_delta_N     <= '0';
            state               <= 41; 
        when 41 =>          
            reg_en_delta_N      <= '1';
            state               <= 42;
        when 42 =>
            reg_en_delta_N      <= '0';
            wr_en_local_ram_delta_N         <= '1';
            wr_addr_local_ram_delta_N       <= (others => '0');
            sel_mux_delta_N     <= '1';
            state               <= 11;
        when 11 =>  
            delta_N_counter  <= delta_N_counter + '1';
            wr_en_local_ram_delta_N         <= '0';
            state               <= 12;
        when 12 =>      
            state               <= 13;
        when 13 =>    
            --  L_temp              <= rd_data_local_ram_L;
            reg_en_delta_N      <= '1';
            state               <= 14;
        when 14 =>
            wr_en_local_ram_delta_N         <= '1';
            wr_addr_local_ram_delta_N       <= wr_addr_local_ram_delta_N + '1';
            reg_en_delta_N      <= '0';
            state               <= 15;
        when 15 =>
            wr_en_local_ram_delta_N         <= '0';
            --write in ram
            state               <= 16;
        when 16 =>
           if(delta_N_counter = X"08") then
               delta_N_counter  <= (others => '0');    
               state            <= 17;
           else
               delta_N_counter  <= delta_N_counter + '1';
               state            <= 12;
           end if;
        when 17 =>
            -----------------
            rd_addr_local_ram_AAD <= (others => '0');
            sel_mux_blake        <= '1';
            reg_init_tag_a       <= '1';
            state                <= 18;
        when 18 =>
            --wait for ram latency
            reg_init_tag_a       <= '0';
            state                <= 19;
        when 19 =>
            start_blake <= '1';
            state                 <= 20;
        when 20 =>
            start_blake <= '0';
            state                 <= 21;
        when 21 =>
            if(ready_blake = '1') then
               reg_en_tag_aad       <= '1';
               state                <=  22; 
            end if;
        when 22 => 
            reg_en_tag_aad       <= '0';
            if(rd_addr_local_ram_AAD = x"7") then
                state <= 23;
            else
                rd_addr_local_ram_AAD <= rd_addr_local_ram_AAD + '1';
                state <= 18;
            end if;
        when 23 =>
            RDY                 <= '1';
            TAG_A_VLD           <= '1';
            state               <=  24;
        when 24 =>
            RDY                 <= '0';
            state               <=  0;
        when others => null;
        end case;
    end if;
end if;
end process;

end Behavioral;
