----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/13/2019 01:27:01 PM
-- Design Name: 
-- Module Name: encrypt - Behavioral
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

entity encrypt is
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
end encrypt;


architecture Behavioral of encrypt is

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

component omd_controller is
    Port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           START : in STD_LOGIC;
           PTXT_DATA_VALID : in STD_LOGIC;
           PTXT_CTRL : in STD_LOGIC_VECTOR (15 downto 0);
           PTXT_RDY : out STD_LOGIC;
           CTXT_DATA_VALID : out STD_LOGIC;
           CTXT_CTRL : out STD_LOGIC_VECTOR (15 downto 0);
           READY        :   out STD_LOGIC;
           START_BLAKE : out STD_LOGIC;
           busy_blake   : in STD_LOGIC;
           READY_BLAKE : in STD_LOGIC;
           sel_mux_blake        : out STD_LOGIC_VECTOR(1 downto 0);
           reg_en_msg           : out STD_LOGIC;
           rd_addr_ram_delta        : out STD_LOGIC_VECTOR(7 downto 0);
           reg_en_ctxt              : out STD_LOGIC;
           reg_en_delta_NONCE_00    : out STD_LOGIC;
           start_compute_delta_NONCE: out STD_LOGIC;
           reg_en_tage              : out STD_LOGIC);
end component;

component mux4_1_1024 is
    Port (  data1_in : in  STD_LOGIC_VECTOR (1023 downto 0);
            data2_in : in  STD_LOGIC_VECTOR (1023 downto 0);
            data3_in : in  STD_LOGIC_VECTOR (1023 downto 0);
            data4_in : in  STD_LOGIC_VECTOR (1023 downto 0);
            sel      : in  STD_LOGIC_VECTOR (   1 downto 0);
            data_out : out STD_LOGIC_VECTOR (1023 downto 0));
end component;

component mux4_1_512 is
    Port ( data1_in : in STD_LOGIC_VECTOR (511 downto 0);
           data2_in : in STD_LOGIC_VECTOR (511 downto 0);
           data3_in : in STD_LOGIC_VECTOR (511 downto 0);
           data4_in : in STD_LOGIC_VECTOR (511 downto 0);
           sel : in STD_LOGIC_VECTOR(1 downto 0);
           data_out : out STD_LOGIC_VECTOR (511 downto 0));
end component;

component mux2_1_512 is
    Port ( data1_in : in STD_LOGIC_VECTOR (511 downto 0);
           data2_in : in STD_LOGIC_VECTOR (511 downto 0);
           sel : in STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR (511 downto 0));
end component;

component mux2_1_4 is
    Port ( data1_in : in STD_LOGIC_VECTOR (3 downto 0);
           data2_in : in STD_LOGIC_VECTOR (3 downto 0);
           sel : in STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR (3 downto 0));
end component;

component ram256x512 is
    Port ( clk : in  STD_LOGIC;
           wr_en : in  STD_LOGIC;
           wr_addr : in  STD_LOGIC_VECTOR (7 downto 0);
           wr_data : in  STD_LOGIC_VECTOR (511 downto 0);
           rd_addr : in  STD_LOGIC_VECTOR (7 downto 0);
           rd_data : out  STD_LOGIC_VECTOR (511 downto 0));
end component;

component reg_en_1024 is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           en : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR (1023 downto 0);
           data_out : out STD_LOGIC_VECTOR (1023 downto 0));
end component;

component reg_en_512 is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           en : in STD_LOGIC;
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

component ntz_i is
    Port ( data_in_LUT : in STD_LOGIC_VECTOR (7 downto 0);
           data_out_LUT : out STD_LOGIC_VECTOR (7 downto 0));
end component;

signal state                : integer range 0 to 1;
signal state_delta                : integer range 0 to 63;


signal msg_blake            : STD_LOGIC_VECTOR(1023 downto 0);
signal blake512_data_out    : STD_LOGIC_VECTOR(511 downto 0);
signal tau                  : STD_LOGIC_VECTOR(1023 downto 0);
signal msg_registered       : STD_LOGIC_VECTOR(1023 downto 0);
signal msg_N00              : STD_LOGIC_VECTOR(1023 downto 0);
signal reg_msg_data_in      : STD_LOGIC_VECTOR(1023 downto 0);
signal iv_blake             : STD_LOGIC_VECTOR(511 downto 0);
signal mux_iv_blake_data_in: STD_LOGIC_VECTOR(511 downto 0);
signal rd_addr_ram_delta    : STD_LOGIC_VECTOR(7 downto 0);
signal rd_data_ram_delta    : STD_LOGIC_VECTOR(511 downto 0);
signal reg_ctxt_data_in     : STD_LOGIC_VECTOR(511 downto 0);
signal tage_registered      : STD_LOGIC_VECTOR(511 downto 0);
signal delta_NONCE          : STD_LOGIC_VECTOR(511 downto 0);
signal reg_delta_NONCE_00      : STD_LOGIC_VECTOR(511 downto 0);
signal rd_addr_ram_L        : STD_LOGIC_VECTOR(  3 downto 0);
signal mux_rd_addr_ram_L    : STD_LOGIC_VECTOR(  3 downto 0);
signal rd_data_ram_L        : STD_LOGIC_VECTOR(511 downto 0);
signal LSTAR_X2        : STD_LOGIC_VECTOR(511 downto 0);
signal LSTAR_X3        : STD_LOGIC_VECTOR(511 downto 0);
signal delta_L2        : STD_LOGIC_VECTOR(511 downto 0);
signal delta_L3        : STD_LOGIC_VECTOR(511 downto 0);
signal sel_mux_wr_data_ram_delta        : STD_LOGIC_VECTOR(1 downto 0);


signal reg_delta_NONCE             : STD_LOGIC_VECTOR(511 downto 0);

signal mux_data_delta_NONCE : STD_LOGIC_VECTOR(511 downto 0);
signal IV_N00 : STD_LOGIC_VECTOR(511 downto 0);

signal wr_en_ram_delta               :  STD_LOGIC;
signal wr_addr_ram_delta           : STD_LOGIC_VECTOR(7 downto 0);
signal ntz_i_output           : STD_LOGIC_VECTOR(7 downto 0);
signal wr_data_ram_delta            : STD_LOGIC_VECTOR(511 downto 0);
signal delta_NONCE_counter          : STD_LOGIC_VECTOR(9 downto 0);


signal sel_mux_delta_NONCE         : STD_LOGIC;
signal reg_en_delta_NONCE_00   : STD_LOGIC;
signal reg_en_delta_NONCE      : STD_LOGIC;
signal start_blake          : STD_LOGIC;
signal busy_blake           : STD_LOGIC;
signal ready_blake          : STD_LOGIC;
signal sel_mux_blake        : STD_LOGIC_VECTOR(1 downto 0);
signal reg_en_msg           : STD_LOGIC;
signal reg_en_ctxt          : STD_LOGIC;
signal reg_en_tage          : STD_LOGIC;
signal start_compute_delta_NONCE: STD_LOGIC;
signal sel_mux_rd_addr_ram_L: STD_LOGIC;

signal nonce                : STD_LOGIC_VECTOR(255 downto 0):=   X"2d2d2d2d_2d2d2d2d_2d2d2d2d_2d2d2d2d"&      
                                                                 X"c1c1c1c1_c1c1c1c1_c1c1c1c1_c1c1c1c1";
                                                                  
constant nonce_padding      : STD_LOGIC_VECTOR(255 downto 0):=   X"80000000_00000000_00000000_00000000"&      
                                                                 X"00000000_00000000_00000000_00000000";                                                                   


constant tag_length           : STD_LOGIC_VECTOR(511 downto 0):= X"00000000_00000000_00000000_00000000"&      --lungimea tagului(i.e. 256 biti pt implementarea de referinta)
                                                                 X"00000000_00000000_00000000_00000000"&      --vezi observatie pseudocod
                                                                 X"00000000_00000000_00000000_00000000"&
                                                                 X"00000000_00000000_00000000_00000100";
                                                                 
constant zero_512_bits           : STD_LOGIC_VECTOR(511 downto 0):= X"00000000_00000000_00000000_00000000"&     
                                                                 X"00000000_00000000_00000000_00000000"&      
                                                                 X"00000000_00000000_00000000_00000000"&
                                                                 X"00000000_00000000_00000000_00000000";                                                                 

constant    double_alpha_mask    : STD_LOGIC_VECTOR(511 downto 0) := x"00000000_00000000_00000000_00000000"&--0^503||100100101
                                                                     x"00000000_00000000_00000000_00000000"&
                                                                     x"00000000_00000000_00000000_00000000"&
                                                                     x"00000000_00000000_00000000_00000125";

begin



blake512_inst: blake512
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
            
omd_controller_inst: omd_controller 
Port Map(  CLK              => CLK,
           RST              => RST,
           START            => START,
           PTXT_DATA_VALID  => PTXT_DATA_VALID,
           PTXT_CTRL        => PTXT_CTRL,
           PTXT_RDY         => PTXT_RDY,
           CTXT_DATA_VALID  => CTXT_DATA_VALID,
           CTXT_CTRL        => CTXT_CTRL,
           READY            => READY,
           START_BLAKE      => start_blake,
           busy_blake       => busy_blake,
           READY_BLAKE      => ready_blake,
           sel_mux_blake    => sel_mux_blake,
           reg_en_msg       => reg_en_msg,
           rd_addr_ram_delta=> rd_addr_ram_delta,
           reg_en_ctxt      => reg_en_ctxt,
           reg_en_delta_NONCE_00      => reg_en_delta_NONCE_00,
           start_compute_delta_NONCE  => start_compute_delta_NONCE,
           reg_en_tage      => reg_en_tage);
         
tau <= KEY & tag_length;
msg_N00 <=  KEY & zero_512_bits;




mux_delta_NONCE: mux2_1_512
Port Map (  data1_in        => reg_delta_NONCE_00,
            data2_in        => reg_delta_NONCE,
            sel             => sel_mux_delta_NONCE,
            data_out        => mux_data_delta_NONCE);


delta_NONCE         <=  mux_data_delta_NONCE xor rd_data_ram_L; 


ntz_i_LUT: ntz_i 
Port Map(       data_in_LUT     => delta_NONCE_counter(7 downto 0),
                data_out_LUT    => ntz_i_output);

    rd_addr_ram_L <= ntz_i_output(3 downto 0) + '1'; 

muxx_rd_addr_ram_L: mux2_1_4
    Port Map (  data1_in        => rd_addr_ram_L,
                data2_in        => x"0",
                sel             => sel_mux_rd_addr_ram_L,
                data_out        => mux_rd_addr_ram_L);


LSTAR_X2           <=  (rd_data_ram_L(510 downto 0) & '0') when (rd_data_ram_L(511) = '0') else
                                    (rd_data_ram_L(510 downto 0) & '0') xor double_alpha_mask;

LSTAR_X3           <= LSTAR_X2 xor rd_data_ram_L;

delta_L2            <= LSTAR_X2 xor reg_delta_NONCE;
delta_L3            <= LSTAR_X3 xor reg_delta_NONCE;

generate_delta_NONCE:process (CLK)
begin 
if(clk'event and clk='1') then
    if(rst = '1') then
        wr_addr_ram_delta <= (others => '0');
        --wr_data_ram_delta <= (others => '0');
        wr_en_ram_delta   <= '0';
        delta_NONCE_counter <= "0000000001";
        sel_mux_wr_data_ram_delta <= "00";
        sel_mux_delta_NONCE <= '0';
        sel_mux_rd_addr_ram_L <= '0';
        reg_en_delta_NONCE  <= '0';
        state_delta       <= 0;
    else
        case state_delta is
        when 0 =>
            sel_mux_rd_addr_ram_L <= '0';
            if(start_compute_delta_NONCE = '1') then
                sel_mux_delta_NONCE <= '0';
                state_delta <= 1;
            end if;
        when 1 =>
            reg_en_delta_NONCE <= '1';
            state_delta<= 2;
        when 2 =>
            reg_en_delta_NONCE <= '0';       
            wr_en_ram_delta         <= '1';
            wr_addr_ram_delta      <= (others => '0');
            sel_mux_delta_NONCE     <= '1';
            state_delta               <= 3;
        when 3 =>  
            delta_NONCE_counter  <= delta_NONCE_counter + '1';
            wr_en_ram_delta         <= '0';
            state_delta               <= 4;
        when 4 =>      
            state_delta               <= 5;
        when 5 =>    
            reg_en_delta_NONCE      <= '1';
            state_delta               <= 6;
        when 6 =>
            wr_en_ram_delta        <= '1';
            wr_addr_ram_delta       <= wr_addr_ram_delta + '1';
            reg_en_delta_NONCE      <= '0';
            state_delta               <= 7;
        when 7 =>
            wr_en_ram_delta         <= '0';
            --write in ram
            state_delta               <= 8;
        when 8 =>
           if(delta_NONCE_counter = (FRAME_LENGTH(15 DOWNTO 6))) then
               delta_NONCE_counter <= "0000000001";
               sel_mux_rd_addr_ram_L <= '1';    
               state_delta            <= 9;
           else
               delta_NONCE_counter  <= delta_NONCE_counter + '1';
               state_delta            <= 4;
           end if;
        when 9 =>
           state_delta <= 10;
        when 10 =>    
           if(FRAME_LENGTH(5 downto 0) = "000000") then --no padding
               sel_mux_wr_data_ram_delta <= "01";
               state_delta <= 11;
           else --with padding
               sel_mux_wr_data_ram_delta <= "10";
               state_delta <= 11;
           end if;
        when 11 =>
            wr_en_ram_delta        <= '1';
            wr_addr_ram_delta       <= wr_addr_ram_delta + '1';
            state_delta               <= 12;
        when 12 =>
            wr_en_ram_delta         <= '0';
            state_delta <= 0;                                    
        when others => null;   
        end case;
    end if;     
end if;
end process;

ram_L:ram16x512 
Port Map    (   clk         =>  clk,
                wr_en       =>  WR_EN_RAM_L,
                wr_addr     =>  WR_ADDR_RAM_L,
                wr_data     =>  WR_DATA_RAM_L,
                rd_addr     =>  mux_rd_addr_ram_L,
                rd_data     =>  rd_data_ram_L); 
        
mux_msg_blake: mux4_1_1024 
   Port Map(    data1_in        =>  tau,
                data2_in        =>  msg_registered,
                data3_in        =>  msg_N00,
                data4_in        =>  (others => '0'),         
                sel             =>  sel_mux_blake,
                data_out        =>  msg_blake);
                
mux_iv_blake_data_in <= blake512_data_out xor rd_data_ram_delta;

IV_N00          <= nonce & nonce_padding;

mux_IV512_blake: mux4_1_512
   Port Map (   data1_in        => rd_data_ram_delta,
                data2_in        => mux_iv_blake_data_in,
                data3_in        => IV_N00,
                data4_in        => (others => '0'),
                sel             => sel_mux_blake,
                data_out        => iv_blake);

ram_delta:ram256x512 
   Port Map (   clk             =>  clk,
                wr_en           =>  WR_EN_RAM_DELTA,
                wr_addr         =>  WR_ADDR_RAM_DELTA,
                wr_data         =>  WR_DATA_RAM_DELTA,
                rd_addr         =>  rd_addr_ram_delta,
                rd_data         =>  rd_data_ram_delta);

mux_wr_data_ram_delta :  mux4_1_512
   Port Map (   data1_in        => reg_delta_NONCE,
                data2_in        => delta_L2,
                data3_in        => delta_L3,
                data4_in        => (others => '0'),
                sel             => sel_mux_wr_data_ram_delta,
                data_out        => WR_DATA_RAM_DELTA);


reg_msg_data_in     <=  KEY & PTXT_DATA;

register_msg: reg_en_1024 
   Port Map (   clk             =>  clk,
                reset           =>  rst,
                en              =>  reg_en_msg,
                data_in         =>  reg_msg_data_in,
                data_out        =>  msg_registered);


register_ctxt: reg_en_512
   Port Map (   clk             =>  clk,
                reset           =>  rst,
                en              =>  reg_en_ctxt,
                data_in         =>  reg_ctxt_data_in,
                data_out        =>  CTXT_DATA);

register_delta_NONCE_00: reg_en_512
    Port Map (  clk             =>  clk,
                reset           =>  rst,
                en              =>  reg_en_delta_NONCE_00,
                data_in         =>  blake512_data_out,
                data_out        =>  reg_delta_NONCE_00); 
register_delta_NONCE: reg_en_512
    Port Map (  clk             =>  clk,
                reset           =>  rst,
                en              =>  reg_en_delta_NONCE,
                data_in         =>  delta_NONCE,
                data_out        =>  reg_delta_NONCE); 

register_tage: reg_en_512
   Port Map (   clk             =>  clk,
                reset           =>  rst,
                en              =>  reg_en_tage,
                data_in         =>  blake512_data_out,
                data_out        =>  tage_registered);

    reg_ctxt_data_in <= blake512_data_out xor PTXT_DATA;
    
    TAG              <= tage_registered xor TAG_A;

end Behavioral;
