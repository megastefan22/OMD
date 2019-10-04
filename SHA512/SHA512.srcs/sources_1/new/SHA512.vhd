


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity sha512 is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           start : in STD_LOGIC;
           ready : out STD_LOGIC;
           first : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR (1023 downto 0);
           data_out : out STD_LOGIC_VECTOR (511 downto 0));
end sha512;

architecture Behavioral of sha512 is

component message_schedule is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           start : in STD_LOGIC;
           ready : out STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR (1023 downto 0);
           rd_addr : in STD_LOGIC_VECTOR (6 downto 0);
           rd_data : out STD_LOGIC_VECTOR (63 downto 0));
end component;

component sum0 is
    Port ( x : in STD_LOGIC_VECTOR (63 downto 0);
           r : out STD_LOGIC_VECTOR (63 downto 0));
end component;

component sum1 is
    Port ( x : in STD_LOGIC_VECTOR (63 downto 0);
           r : out STD_LOGIC_VECTOR (63 downto 0));
end component;

component ch is
    Port ( x : in STD_LOGIC_VECTOR (63 downto 0);
           y : in STD_LOGIC_VECTOR (63 downto 0);
           z : in STD_LOGIC_VECTOR (63 downto 0);
           r : out STD_LOGIC_VECTOR (63 downto 0));
end component;

component maj is
    Port ( x : in STD_LOGIC_VECTOR (63 downto 0);
           y : in STD_LOGIC_VECTOR (63 downto 0);
           z : in STD_LOGIC_VECTOR (63 downto 0);
           r : out STD_LOGIC_VECTOR (63 downto 0));
end component;

component constants is
    Port ( addr : in STD_LOGIC_VECTOR (6 downto 0);
           data_out : out STD_LOGIC_VECTOR (63 downto 0));
end component;

component reg_en_64 is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           en : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR (63 downto 0);
           data_out : out STD_LOGIC_VECTOR (63 downto 0));
end component;

component mux2_1_64 is
    Port ( data1_in : in STD_LOGIC_VECTOR (63 downto 0);
           data2_in : in STD_LOGIC_VECTOR (63 downto 0);
           sel : in STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR (63 downto 0));
end component;

component control_SHA512 is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           start : in STD_LOGIC;
           ready : out STD_LOGIC;
           start_compute_w_data : out STD_LOGIC;
           ready_compute_w_data : in STD_LOGIC;
           reg_en_data_temp : out STD_LOGIC;
           reg_en_data_out : out STD_LOGIC;
           sel_mux_data : out STD_LOGIC;
           step : out STD_LOGIC_VECTOR (6 downto 0));
end component;

    signal mux1_a_data : std_logic_vector(63 downto 0);
    signal mux1_b_data : std_logic_vector(63 downto 0);
    signal mux1_c_data : std_logic_vector(63 downto 0);
    signal mux1_d_data : std_logic_vector(63 downto 0);
    signal mux1_e_data : std_logic_vector(63 downto 0);
    signal mux1_f_data : std_logic_vector(63 downto 0);
    signal mux1_g_data : std_logic_vector(63 downto 0);
    signal mux1_h_data : std_logic_vector(63 downto 0);

    signal mux2_a_data : std_logic_vector(63 downto 0);
    signal mux2_b_data : std_logic_vector(63 downto 0);
    signal mux2_c_data : std_logic_vector(63 downto 0);
    signal mux2_d_data : std_logic_vector(63 downto 0);
    signal mux2_e_data : std_logic_vector(63 downto 0);
    signal mux2_f_data : std_logic_vector(63 downto 0);
    signal mux2_g_data : std_logic_vector(63 downto 0);
    signal mux2_h_data : std_logic_vector(63 downto 0);

    signal a_data : std_logic_vector(63 downto 0);
    signal b_data : std_logic_vector(63 downto 0);
    signal c_data : std_logic_vector(63 downto 0);
    signal d_data : std_logic_vector(63 downto 0);
    signal e_data : std_logic_vector(63 downto 0);
    signal f_data : std_logic_vector(63 downto 0);
    signal g_data : std_logic_vector(63 downto 0);
    signal h_data : std_logic_vector(63 downto 0);

    signal w_data : std_logic_vector(63 downto 0);
    signal k_data : std_logic_vector(63 downto 0);

    signal sum0_a : std_logic_vector(63 downto 0); 
    signal sum1_e : std_logic_vector(63 downto 0);
    signal ch_efg : std_logic_vector(63 downto 0);
    signal maj_abc : std_logic_vector(63 downto 0);

    signal t1 : std_logic_vector(63 downto 0);
    signal t2 : std_logic_vector(63 downto 0);

    signal H0_temp : std_logic_vector(63 downto 0);
    signal H1_temp : std_logic_vector(63 downto 0);
    signal H2_temp : std_logic_vector(63 downto 0);
    signal H3_temp : std_logic_vector(63 downto 0);
    signal H4_temp : std_logic_vector(63 downto 0);
    signal H5_temp : std_logic_vector(63 downto 0);
    signal H6_temp : std_logic_vector(63 downto 0);
    signal H7_temp : std_logic_vector(63 downto 0);

    signal registered_a : std_logic_vector(63 downto 0);
    signal registered_b : std_logic_vector(63 downto 0);
    signal registered_c : std_logic_vector(63 downto 0);
    signal registered_d : std_logic_vector(63 downto 0);
    signal registered_e : std_logic_vector(63 downto 0);
    signal registered_f : std_logic_vector(63 downto 0);
    signal registered_g : std_logic_vector(63 downto 0);
    signal registered_h : std_logic_vector(63 downto 0);

    signal registered_H0 : std_logic_vector(63 downto 0);
    signal registered_H1 : std_logic_vector(63 downto 0);
    signal registered_H2 : std_logic_vector(63 downto 0);
    signal registered_H3 : std_logic_vector(63 downto 0);
    signal registered_H4 : std_logic_vector(63 downto 0);
    signal registered_H5 : std_logic_vector(63 downto 0);
    signal registered_H6 : std_logic_vector(63 downto 0);
    signal registered_H7 : std_logic_vector(63 downto 0);

    signal start_compute_w_data : std_logic;
    signal ready_compute_w_data : std_logic;
    
    signal step : std_logic_vector(6 downto 0);
    
    signal reg_en_data_temp : std_logic;
    signal reg_en_data_out : std_logic;
    
    signal sel_mux_data : std_logic;

    constant initial_H0 : std_logic_vector(63 downto 0):=x"6a09e667f3bcc908";
    constant initial_H1 : std_logic_vector(63 downto 0):=x"bb67ae8584caa73b";
    constant initial_H2 : std_logic_vector(63 downto 0):=x"3c6ef372fe94f82b";
    constant initial_H3 : std_logic_vector(63 downto 0):=x"a54ff53a5f1d36f1";
    constant initial_H4 : std_logic_vector(63 downto 0):=x"510e527fade682d1";
    constant initial_H5 : std_logic_vector(63 downto 0):=x"9b05688c2b3e6c1f";
    constant initial_H6 : std_logic_vector(63 downto 0):=x"1f83d9abfb41bd6b";
    constant initial_H7 : std_logic_vector(63 downto 0):=x"5be0cd19137e2179";

begin

    first_mux_data_a :  mux2_1_64
    port map(
             data1_in                           => registered_H0,
             data2_in                           => initial_H0,
             sel                                => first,
             data_out                           => mux1_a_data);

    first_mux_data_b :  mux2_1_64
    port map(
             data1_in                           => registered_H1,
             data2_in                           => initial_H1,
             sel                                => first,
             data_out                           => mux1_b_data);

    first_mux_data_c :  mux2_1_64
    port map(
             data1_in                           => registered_H2,
             data2_in                           => initial_H2,
             sel                                => first,
             data_out                           => mux1_c_data);

    first_mux_data_d :  mux2_1_64
    port map(
             data1_in                           => registered_H3,
             data2_in                           => initial_H3,
             sel                                => first,
             data_out                           => mux1_d_data);

    first_mux_data_e :  mux2_1_64
    port map(
             data1_in                           => registered_H4,
             data2_in                           => initial_H4,
             sel                                => first,
             data_out                           => mux1_e_data);

    first_mux_data_f :  mux2_1_64
    port map(
             data1_in                           => registered_H5,
             data2_in                           => initial_H5,
             sel                                => first,
             data_out                           => mux1_f_data);

    first_mux_data_g :  mux2_1_64
    port map(
             data1_in                           => registered_H6,
             data2_in                           => initial_H6,
             sel                                => first,
             data_out                           => mux1_g_data);

    first_mux_data_h :  mux2_1_64
    port map(
             data1_in                           => registered_H7,
             data2_in                           => initial_H7,
             sel                                => first,
             data_out                           => mux1_h_data);
             
    second_mux_data_a :  mux2_1_64
    port map(
             data1_in                           => mux1_a_data,
             data2_in                           => a_data,
             sel                                => sel_mux_data,
             data_out                           => mux2_a_data);

    second_mux_data_b :  mux2_1_64
    port map(
             data1_in                           => mux1_b_data,
             data2_in                           => b_data,
             sel                                => sel_mux_data,
             data_out                           => mux2_b_data);

    second_mux_data_c :  mux2_1_64
    port map(
             data1_in                           => mux1_c_data,
             data2_in                           => c_data,
             sel                                => sel_mux_data,
             data_out                           => mux2_c_data);

    second_mux_data_d :  mux2_1_64
    port map(
             data1_in                           => mux1_d_data,
             data2_in                           => d_data,
             sel                                => sel_mux_data,
             data_out                           => mux2_d_data);

    second_mux_data_e :  mux2_1_64
    port map(
             data1_in                           => mux1_e_data,
             data2_in                           => e_data,
             sel                                => sel_mux_data,
             data_out                           => mux2_e_data);

    second_mux_data_f :  mux2_1_64
    port map(
             data1_in                           => mux1_f_data,
             data2_in                           => f_data,
             sel                                => sel_mux_data,
             data_out                           => mux2_f_data);

    second_mux_data_g :  mux2_1_64
    port map(
             data1_in                           => mux1_g_data,
             data2_in                           => g_data,
             sel                                => sel_mux_data,
             data_out                           => mux2_g_data);

    second_mux_data_h :  mux2_1_64
    port map(
             data1_in                           => mux1_h_data,
             data2_in                           => h_data,
             sel                                => sel_mux_data,
             data_out                           => mux2_h_data);

    register_a : reg_en_64
    port map(
             clk                                => clk,
             reset                              => reset,
             en                                 => reg_en_data_temp,
             data_in                            => mux2_a_data,
             data_out                           => registered_a);

    register_b : reg_en_64
    port map(
             clk                                => clk,
             reset                              => reset,
             en                                 => reg_en_data_temp,
             data_in                            => mux2_b_data,
             data_out                           => registered_b);

    register_c : reg_en_64
    port map(
             clk                                => clk,
             reset                              => reset,
             en                                 => reg_en_data_temp,
             data_in                            => mux2_c_data,
             data_out                           => registered_c);

    register_d : reg_en_64
    port map(
             clk                                => clk,
             reset                              => reset,
             en                                 => reg_en_data_temp,
             data_in                            => mux2_d_data,
             data_out                           => registered_d);

    register_e : reg_en_64
    port map(
             clk                                => clk,
             reset                              => reset,
             en                                 => reg_en_data_temp,
             data_in                            => mux2_e_data,
             data_out                           => registered_e);

    register_f : reg_en_64
    port map(
             clk                                => clk,
             reset                              => reset,
             en                                 => reg_en_data_temp,
             data_in                            => mux2_f_data,
             data_out                           => registered_f);

    register_g : reg_en_64
    port map(
             clk                                => clk,
             reset                              => reset,
             en                                 => reg_en_data_temp,
             data_in                            => mux2_g_data,
             data_out                           => registered_g);

    register_h : reg_en_64
    port map(
             clk                                => clk,
             reset                              => reset,
             en                                 => reg_en_data_temp,
             data_in                            => mux2_h_data,
             data_out                           => registered_h);

    compute_w_data : message_schedule
    port map(
             clk                                => clk,
             reset                              => reset,
             start                              => start_compute_w_data,
             ready                              => ready_compute_w_data,
             data_in                            => data_in,
             rd_addr                            => step,
             rd_data                            => w_data);
             
    compute_sum0 : sum0
    port map(
             x                                  => registered_a,
             r                                  => sum0_a);

    compute_sum1 : sum1
    port map(
             x                                  => registered_e,
             r                                  => sum1_e);

    compute_ch : ch
    port map(
             x                                  => registered_e,
             y                                  => registered_f,
             z                                  => registered_g,
             r                                  => ch_efg);

    compute_maj : maj
    port map(
             x                                  => registered_a,
             y                                  => registered_b,
             z                                  => registered_c,
             r                                  => maj_abc);

    rom_k_data : constants
    port map(
             addr                               => step,
             data_out                           => k_data);
              
    t1 <= registered_h + sum1_e + ch_efg + k_data + w_data;
    t2 <= sum0_a + maj_abc;
    
    a_data <= t1 + t2;
    b_data <= registered_a;
    c_data <= registered_b;
    d_data <= registered_c;
    e_data <= registered_d + t1;
    f_data <= registered_e;
    g_data <= registered_f;
    h_data <= registered_g;

    H0_temp <= registered_a + mux1_a_data;
    H1_temp <= registered_b + mux1_b_data;
    H2_temp <= registered_c + mux1_c_data;
    H3_temp <= registered_d + mux1_d_data;
    H4_temp <= registered_e + mux1_e_data;
    H5_temp <= registered_f + mux1_f_data;
    H6_temp <= registered_g + mux1_g_data;
    H7_temp <= registered_h + mux1_h_data;

    register_H0 : reg_en_64
    port map(
             clk                                => clk,
             reset                              => reset,
             en                                 => reg_en_data_out,
             data_in                            => H0_temp,
             data_out                           => registered_H0);

    register_H1 : reg_en_64
    port map(
             clk                                => clk,
             reset                              => reset,
             en                                 => reg_en_data_out,
             data_in                            => H1_temp,
             data_out                           => registered_H1);

    register_H2 : reg_en_64
    port map(
             clk                                => clk,
             reset                              => reset,
             en                                 => reg_en_data_out,
             data_in                            => H2_temp,
             data_out                           => registered_H2);

    register_H3 : reg_en_64
    port map(
             clk                                => clk,
             reset                              => reset,
             en                                 => reg_en_data_out,
             data_in                            => H3_temp,
             data_out                           => registered_H3);

    register_H4 : reg_en_64
    port map(
             clk                                => clk,
             reset                              => reset,
             en                                 => reg_en_data_out,
             data_in                            => H4_temp,
             data_out                           => registered_H4);

    register_H5 : reg_en_64
    port map(
             clk                                => clk,
             reset                              => reset,
             en                                 => reg_en_data_out,
             data_in                            => H5_temp,
             data_out                           => registered_H5);

    register_H6 : reg_en_64
    port map(
             clk                                => clk,
             reset                              => reset,
             en                                 => reg_en_data_out,
             data_in                            => H6_temp,
             data_out                           => registered_H6);

    register_H7 : reg_en_64
    port map(
             clk                                => clk,
             reset                              => reset,
             en                                 => reg_en_data_out,
             data_in                            => H7_temp,
             data_out                           => registered_H7);

    data_out <= registered_H0 & registered_H1 & registered_H2 & registered_H3 &
                registered_H4 & registered_H5 & registered_H6 & registered_H7;

    sha512_control : control_sha512
    port map(
             clk                                => clk,
             reset                              => reset,
             start                              => start,
             ready                              => ready,
             start_compute_w_data               => start_compute_w_data,
             ready_compute_w_data               => ready_compute_w_data,
             reg_en_data_temp                   => reg_en_data_temp,
             reg_en_data_out                    => reg_en_data_out,
             sel_mux_data                       => sel_mux_data,
             step                               => step);

end Behavioral;
