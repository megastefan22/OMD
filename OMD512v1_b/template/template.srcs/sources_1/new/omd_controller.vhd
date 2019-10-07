----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/15/2019 03:38:51 PM
-- Design Name: 
-- Module Name: omd_controller - Behavioral
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

entity omd_controller is
    Port ( CLK                      : in STD_LOGIC;
           RST                      : in STD_LOGIC;
           START                    : in STD_LOGIC;
           PTXT_DATA_VALID          : in STD_LOGIC;
           PTXT_CTRL                : in STD_LOGIC_VECTOR (15 downto 0);
           PTXT_RDY                 : out STD_LOGIC;
           CTXT_DATA_VALID          : out STD_LOGIC;
           CTXT_CTRL                : out STD_LOGIC_VECTOR (15 downto 0);
           READY                    : out STD_LOGIC;
           START_BLAKE              : out STD_LOGIC;
           busy_blake               : in STD_LOGIC;
           READY_BLAKE              : in STD_LOGIC;
           sel_mux_blake            : out STD_LOGIC_VECTOR(1 downto 0);
           reg_en_msg               : out STD_LOGIC;
           rd_addr_ram_delta        : out STD_LOGIC_VECTOR(7 downto 0);
           reg_en_ctxt              : out STD_LOGIC;
           reg_en_delta_NONCE_00    : out STD_LOGIC;
           start_compute_delta_NONCE: out STD_LOGIC;
           reg_en_tage              : out STD_LOGIC);
end omd_controller;

architecture Behavioral of omd_controller is

signal state                    : integer range 0 to 63;
signal rd_addr_ram_delta_temp   : STD_LOGIC_VECTOR(7 downto 0) ;
signal count_busy_blake         : STD_LOGIC_VECTOR (3 downto 0);

begin

process (CLK) 
begin
if(CLK'event and CLK = '1') then
    if (RST = '1') then
        PTXT_RDY        <= '0';
        CTXT_DATA_VALID <= '0';
        CTXT_CTRL       <= (others => '0');
        START_BLAKE     <= '0';
        sel_mux_blake   <= (others => '0');
        reg_en_msg      <= '0';
        rd_addr_ram_delta_temp <= (others => '0');
        reg_en_ctxt     <= '0';
        reg_en_delta_NONCE_00   <= '0';
        reg_en_tage     <= '0';
        READY           <= '0';
        count_busy_blake    <= (others => '0');
        start_compute_delta_NONCE <= '0';
        state           <=  0 ;
    else
        case state is 
        when 0 =>
            rd_addr_ram_delta_temp <= x"00";
            PTXT_RDY        <= '0'; 
            sel_mux_blake <= "10";  
            if (START = '1' and PTXT_DATA_VALID = '1') then
                START_BLAKE <= '1';
                state       <= 32;               
            end if;
        when 32 =>
        START_BLAKE <= '0';
        if(READY_BLAKE = '1') then
            reg_en_delta_NONCE_00 <= '1';
            start_compute_delta_NONCE <= '1';
            state                 <= 33;
        end if;
        when 33 =>
            reg_en_delta_NONCE_00 <= '0'; 
            start_compute_delta_NONCE <= '0';   
            if(PTXT_CTRL = X"AA00") then
                sel_mux_blake <= "00";
                state <= 1;
            elsif (PTXT_CTRL(15 downto 8) = X"CC") then
                state <= 24;
            end if;
        when 1 =>
            reg_en_msg <= '1';
            sel_mux_blake <= "00";
            state <= 2;
        when 2 =>
            reg_en_msg <= '0';
            state   <= 35;
        when 35 =>
            state  <= 36;
        when 36 =>    
            START_BLAKE <= '1';
            state <= 3;
        when 3 =>
            START_BLAKE <= '0';
            if (busy_blake = '1') then
                if(count_busy_blake = X"A") then
                    count_busy_blake <= (others => '0');
                    READY            <= '1';
                    state <= 4;
                else
                    count_busy_blake <= count_busy_blake + '1';
                end if;
            end if;
        when 4 =>
            READY <= '0';
            if(READY_BLAKE = '1') then
                reg_en_ctxt <= '1';
                state <= 5;
            end if;
        when 5 =>
            reg_en_ctxt <= '0';
            CTXT_DATA_VALID <='1';
            CTXT_CTRL <= PTXT_CTRL;
            state <= 6;
        when 6 =>
            CTXT_DATA_VALID <= '0';
            PTXT_RDY        <= '1';
            state           <=  7 ;
        when 7 =>
            rd_addr_ram_delta_temp <= rd_addr_ram_delta_temp + '1';
            PTXT_RDY        <= '0';
            state <= 8;
        when 8 =>
            sel_mux_blake <= "01";
            if (PTXT_DATA_VALID = '1') then
                if(PTXT_CTRL = X"AA00") then
                    state <= 9;
                elsif (PTXT_CTRL(15 downto 8) = X"55") then
                    state <= 14;
                end if;  
            end if; 
        when 9 =>
            START_BLAKE <= '1';
            state <= 10;
        when 10 =>
            START_BLAKE <= '0';
            if(READY_BLAKE = '1') then
                reg_en_ctxt <= '1';
                state <= 11;
            end if;
        when 11 =>
            reg_en_ctxt <= '1';
            reg_en_msg <= '1';
            state <= 12;
        when 12 =>
            reg_en_msg <= '0';
            CTXT_DATA_VALID <='1';
            CTXT_CTRL <= PTXT_CTRL;
            state <= 13;
        when 13 =>
            CTXT_DATA_VALID <= '0';
            PTXT_RDY        <= '1';
            state           <=  6 ;
        when 14 =>
            START_BLAKE <= '1';
            state <= 15;
        when 15 =>
            START_BLAKE <= '0';
            if(READY_BLAKE = '1') then
                reg_en_ctxt <= '1';
                state <= 16;
            end if;
        when 16 =>
            reg_en_ctxt <= '0';
            reg_en_msg <= '1';
            state <= 17;
        when 17 =>
            reg_en_msg <= '0';
            rd_addr_ram_delta_temp <= rd_addr_ram_delta_temp + '1';
            state <= 20;
        when 20 =>
            START_BLAKE <= '1';
            state <= 21;
        when 21 =>
            START_BLAKE <= '0';
            if(READY_BLAKE = '1') then
                reg_en_tage <= '1';
                state <= 22;
            end if;
        when 22 =>
            reg_en_tage <='0';
            CTXT_DATA_VALID <='1';
            CTXT_CTRL <= PTXT_CTRL;
            state <= 23;
        when 23 =>
            CTXT_DATA_VALID <= '0';
            PTXT_RDY        <= '1';
            state           <=  0 ;
        -- single block
        when 24 =>
            reg_en_msg <= '1';
            sel_mux_blake <= "00";
            state <= 25;
        when 25 =>
            reg_en_msg <= '0';
            START_BLAKE <= '1';
            state <= 26;
        when 26 =>
            START_BLAKE <= '0';
            if (busy_blake = '1') then
                if(count_busy_blake = X"A") then
                    count_busy_blake <= (others => '0');
                    READY            <= '1';
                    state <= 27;
                else
                    count_busy_blake <= count_busy_blake + '1';
                end if;
            end if;
        when 27 =>
            READY <= '0';
            if(READY_BLAKE = '1') then
                reg_en_ctxt <= '1';
                state <= 28;
            end if;
        when 28 =>
            reg_en_ctxt <= '0';
--            CTXT_DATA_VALID <='1';
            CTXT_CTRL <= PTXT_CTRL;
            state <= 29;
        when 29 =>
--            CTXT_DATA_VALID <= '0';
--            PTXT_RDY        <= '1';
            state           <=  30 ;
        when 30 =>
            rd_addr_ram_delta_temp <= rd_addr_ram_delta_temp + '1';
--            PTXT_RDY        <= '0';
            reg_en_msg <= '1';
            sel_mux_blake <= "01";
            state <= 17;                        
        when others => null;
        end case;
    end if;
end if;
end process;

rd_addr_ram_delta <= rd_addr_ram_delta_temp;

end Behavioral;
