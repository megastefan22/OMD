


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--library UNISIM;
--use UNISIM.VComponents.all;

entity message_schedule is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           start : in STD_LOGIC;
           ready : out STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR (1023 downto 0);
           rd_addr : in STD_LOGIC_VECTOR (6 downto 0);
           rd_data : out STD_LOGIC_VECTOR (63 downto 0));
end message_schedule;

architecture Behavioral of message_schedule is

component mux16_1_64 is
    Port ( data1_in : in STD_LOGIC_VECTOR (63 downto 0);
           data2_in : in STD_LOGIC_VECTOR (63 downto 0);
           data3_in : in STD_LOGIC_VECTOR (63 downto 0);
           data4_in : in STD_LOGIC_VECTOR (63 downto 0);
           data5_in : in STD_LOGIC_VECTOR (63 downto 0);
           data6_in : in STD_LOGIC_VECTOR (63 downto 0);
           data7_in : in STD_LOGIC_VECTOR (63 downto 0);
           data8_in : in STD_LOGIC_VECTOR (63 downto 0);
           data9_in : in STD_LOGIC_VECTOR (63 downto 0);
           data10_in : in STD_LOGIC_VECTOR (63 downto 0);
           data11_in : in STD_LOGIC_VECTOR (63 downto 0);
           data12_in : in STD_LOGIC_VECTOR (63 downto 0);
           data13_in : in STD_LOGIC_VECTOR (63 downto 0);
           data14_in : in STD_LOGIC_VECTOR (63 downto 0);
           data15_in : in STD_LOGIC_VECTOR (63 downto 0);
           data16_in : in STD_LOGIC_VECTOR (63 downto 0);
           sel : in STD_LOGIC_VECTOR (3 downto 0);
           data_out : out STD_LOGIC_VECTOR (63 downto 0));
end component;

component ram128x64 is
    Port ( wr_clk : in  STD_LOGIC;
           we : in  STD_LOGIC;
           wr_addr : in  STD_LOGIC_VECTOR (6 downto 0);
           wr_data : in  STD_LOGIC_VECTOR (63 downto 0);
		   rd_clk : in  STD_LOGIC;
		   rd_addr : in  STD_LOGIC_VECTOR (6 downto 0);
           rd_data : out  STD_LOGIC_VECTOR (63 downto 0));
end component;

component reg_en_64 is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           en : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR (63 downto 0);
           data_out : out STD_LOGIC_VECTOR (63 downto 0));
end component;

component sigma0 is
    Port ( x : in STD_LOGIC_VECTOR (63 downto 0);
           r : out STD_LOGIC_VECTOR (63 downto 0));
end component;

component sigma1 is
    Port ( x : in STD_LOGIC_VECTOR (63 downto 0);
           r : out STD_LOGIC_VECTOR (63 downto 0));
end component;

component control_message_schedule is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           start : in STD_LOGIC;
           ready : out STD_LOGIC;
           data1_in : in STD_LOGIC_VECTOR (63 downto 0);
           data2_in : in STD_LOGIC_VECTOR (63 downto 0);
           wr_en : out STD_LOGIC;
           wr_addr : out STD_LOGIC_VECTOR (6 downto 0);
           wr_data : out STD_LOGIC_VECTOR (63 downto 0);
           rd_addr : out STD_LOGIC_VECTOR (6 downto 0);
           reg1_en : out STD_LOGIC;
           reg2_en : out STD_LOGIC;
           reg3_en : out STD_LOGIC;
           reg4_en : out STD_LOGIC);
end component;

    signal mux_data : std_logic_vector(63 downto 0);
    
    signal wr_en : std_logic;  
    signal wr_addr : std_logic_vector(6 downto 0);
    signal wr_data : std_logic_vector(63 downto 0);

    signal rd_addr_temp : std_logic_vector(6 downto 0);
    signal rd_data_temp : std_logic_vector(63 downto 0);

    signal reg1_en : std_logic;
    signal reg2_en : std_logic;
    signal reg3_en : std_logic;
    signal reg4_en : std_logic;
    
    signal registered_read_w1 : std_logic_vector(63 downto 0);
    signal registered_read_w2 : std_logic_vector(63 downto 0);
    signal registered_read_w3 : std_logic_vector(63 downto 0);
    signal registered_read_w4 : std_logic_vector(63 downto 0);

    signal sigma0_w3 : std_logic_vector(63 downto 0);
    signal sigma1_w1 : std_logic_vector(63 downto 0);
    
    signal W_temp : std_logic_vector(63 downto 0); 

begin

    mux_data_in : mux16_1_64
    port map(
             data1_in                                   => data_in(1023 downto 960),
             data2_in                                   => data_in(959 downto 896),
             data3_in                                   => data_in(895 downto 832),
             data4_in                                   => data_in(831 downto 768),
             data5_in                                   => data_in(767 downto 704),
             data6_in                                   => data_in(703 downto 640),
             data7_in                                   => data_in(639 downto 576),
             data8_in                                   => data_in(575 downto 512),
             data9_in                                   => data_in(511 downto 448),
             data10_in                                  => data_in(447 downto 384),
             data11_in                                  => data_in(383 downto 320),
             data12_in                                  => data_in(319 downto 256),
             data13_in                                  => data_in(255 downto 192),
             data14_in                                  => data_in(191 downto 128), 
             data15_in                                  => data_in(127 downto 64),
             data16_in                                  => data_in(63 downto 0),
             sel                                        => wr_addr(3 downto 0),
             data_out                                   => mux_data);

    ram1_w : ram128x64
    port map(
             wr_clk                                     => clk,
             we                                         => wr_en,
             wr_addr                                    => wr_addr,
             wr_data                                    => wr_data,
		     rd_clk                                     => clk,
		     rd_addr                                    => rd_addr_temp,
             rd_data                                    => rd_data_temp);

    ram2_w : ram128x64
    port map(
             wr_clk                                     => clk,
             we                                         => wr_en,
             wr_addr                                    => wr_addr,
             wr_data                                    => wr_data,
		     rd_clk                                     => clk,
		     rd_addr                                    => rd_addr,
             rd_data                                    => rd_data);

    register_read_w1 : reg_en_64
    port map(
             clk                                        => clk,
             reset                                      => reset,
             en                                         => reg1_en,
             data_in                                    => rd_data_temp,
             data_out                                   => registered_read_w1);

    register_read_w2 : reg_en_64
    port map(
             clk                                        => clk,
             reset                                      => reset,
             en                                         => reg2_en,
             data_in                                    => rd_data_temp,
             data_out                                   => registered_read_w2);

    register_read_w3 : reg_en_64
    port map(
             clk                                        => clk,
             reset                                      => reset,
             en                                         => reg3_en,
             data_in                                    => rd_data_temp,
             data_out                                   => registered_read_w3);

    register_read_w4 : reg_en_64
    port map(
             clk                                        => clk,
             reset                                      => reset,
             en                                         => reg4_en,
             data_in                                    => rd_data_temp,
             data_out                                   => registered_read_w4);

    compute_sigma0 : sigma0
    port map(
             x                                          => registered_read_w3,
             r                                          => sigma0_w3); 

    compute_sigma1 : sigma1
    port map(
             x                                          => registered_read_w1,
             r                                          => sigma1_w1);

    W_temp <= sigma1_w1 + registered_read_w2 + sigma0_w3 + registered_read_w4;

    message_schedule_control : control_message_schedule
    port map(
             clk                                        => clk,
             reset                                      => reset,
             start                                      => start,
             ready                                      => ready,
             data1_in                                   => mux_data,
             data2_in                                   => W_temp,
             wr_en                                      => wr_en,
             wr_addr                                    => wr_addr,
             wr_data                                    => wr_data,
             rd_addr                                    => rd_addr_temp,
             reg1_en                                    => reg1_en,
             reg2_en                                    => reg2_en,
             reg3_en                                    => reg3_en,
             reg4_en                                    => reg4_en);


end Behavioral;
