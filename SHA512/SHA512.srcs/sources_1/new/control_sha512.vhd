

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--library UNISIM;
--use UNISIM.VComponents.all;

entity control_SHA512 is
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
end control_SHA512;

architecture Behavioral of control_SHA512 is

    signal step_temp : std_logic_vector(6 downto 0);

    signal state : integer range 0 to 15;

begin

    process(clk)
    begin
    if(clk'event and clk='1') then
        if(reset='1') then
            step_temp <= (others => '0');
            ready <= '0';
            start_compute_w_data <= '0';
            reg_en_data_temp <= '0';
            reg_en_data_out <= '0';
            sel_mux_data <= '0';
            state <= 0;
        else
            case state is
                when 0 =>
                    sel_mux_data <= '0';
                    step_temp <= (others => '0');
                    if(start='1') then
                        state <= 1;
                    end if;
                -- compute w data    
                when 1 =>
                    start_compute_w_data <= '1';
                    state <= 2;
                when 2 =>
                    start_compute_w_data <= '0';
                    if(ready_compute_w_data='1') then
                        state <= 3;
                    end if;
                -- register initial values
                when 3 =>
                    reg_en_data_temp <= '1';
                    state <= 4;
                when 4 =>
                    reg_en_data_temp <= '0';
                    sel_mux_data <= '1';
                    state <= 5;
                when 5 =>
                    state <= 6;
                -- register round values
                when 6 =>
                    reg_en_data_temp <= '1';
                    state <= 7;
                when 7 =>
                    reg_en_data_temp <= '0';
                    if(step_temp="1001111") then -- 80 steps
                        step_temp <= (others => '0');
                        state <= 8;
                    else
                        step_temp <= step_temp + '1';
                        state <= 5;
                    end if;
                when 8 =>
                    reg_en_data_out <= '1';
                    state <= 9;
                when 9 =>
                    reg_en_data_out <= '0';
                    ready <= '1';
                    state <= 10;
                when 10 =>
                    ready <= '0';
                    state <= 0;
                when others => null;
            end case;
        end if;
    end if;
    end process;

    step <= step_temp;    

end Behavioral;
