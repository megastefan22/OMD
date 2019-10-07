----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/21/2019 11:55:04 AM
-- Design Name: 
-- Module Name: tb_blake512 - Behavioral
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

entity tb_blake512 is
--  Port ( );
end tb_blake512;

architecture Behavioral of tb_blake512 is

component blake512 is
    Port ( clk              : in  STD_LOGIC;
           rst              : in  STD_LOGIC;
           msg              : in  STD_LOGIC_VECTOR (1023 downto 0);
           salt256          : in  STD_LOGIC_VECTOR (255 downto 0);
           count            : in  STD_LOGIC_VECTOR (127 downto 0);
           start            : in  STD_LOGIC;
           IV512            : in  STD_LOGIC_VECTOR (511 downto 0);
           busy             : out STD_LOGIC;
           ready            : out STD_LOGIC;
           blake512         : out STD_LOGIC_VECTOR (511 downto 0)
           );
end component;

-- input signals
signal  clk                 :   STD_LOGIC                           :=  '0';
signal  rst                 :   STD_LOGIC                           :=  '0';
signal  msg                 :   STD_LOGIC_VECTOR (1023 downto 0)    :=  (others => '0');
signal  salt256             :   STD_LOGIC_VECTOR ( 255 downto 0)    :=  (others => '0');
signal  count               :   STD_LOGIC_VECTOR ( 127 downto 0)    :=  (others => '0');
signal  start               :   STD_LOGIC                           :=  '0';
signal  IV512               :   STD_LOGIC_VECTOR ( 511 downto 0)    :=  (others => '0');

-- output signals
signal  busy                :   STD_LOGIC;          
signal  ready               :   STD_LOGIC;
signal  blake512_out        :   STD_LOGIC_VECTOR ( 511 downto 0); 

constant   clk_period       :   time                                := 8ns;
signal     digest           :   STD_LOGIC_VECTOR ( 511 downto 0)    := (others => '0');
                                                                       



begin

process 
begin
clk <= '1';
wait for clk_period/2;
clk <= '0';
wait for clk_period/2;
end process;

UUT: blake512
    Port Map ( clk                  =>  clk,
               rst                  =>  rst,
               msg                  =>  msg,
               salt256              =>  salt256,
               count                =>  count,
               start                =>  start,
               IV512                =>  IV512,
               
               busy                 =>  busy,
               ready                =>  ready,
               blake512             =>  blake512_out);

               
process
begin
    -- reset the UUT
    rst <= '1';
    wait for clk_period * 10;
    rst <= '0';
    wait for clk_period *  2;
    assert false
        report "Reset Completed"
    severity note;
    
    
------------------------------------------------------------------------------------
-----------------------------   run Test Vector 1   --------------------------------
------------------------------------------------------------------------------------
    count           <= X"00000000_00000000_00000000_00000000";
       
    IV512           <= x"AE5F9156_E7B6D99B_CF6C85D3_9D1A1E15"&
                       x"2F73477D_6A4563CA_6D1826CA_FD82E1ED"&
                       x"8B43D457_0A51B936_E360B596_DC380C3F"&
                       x"1C456002_CE13E9F8_6F196331_43A0AF0E";
                        
    msg             <= X"00000000_00000000_00000000_00000000"&
                       X"00000000_00000000_00000000_00000000"&
                       X"00000000_00000000_00000000_00000000"&
                       X"00000000_00000000_00000000_00000000"&
                       X"00000000_00000000_00000000_00000000"&
                       X"00000000_00000000_00000000_00000000"&
                       X"00000000_00000000_00000000_00000000"&
                       X"00000000_00000000_00000000_00000000";
                       
    digest          <= x"293DE467_B6484898_4B8592D3_60209433"&
                       x"3452601F_C386CA04_A566C58B_0876A62A"&
                       x"04D7FB72_270BDAFB_DC2E9C4B_EF5BBC60"&
                       x"06B8AE56_776E9620_2F1D04AF_3D39331A";
                       
    start           <= '1';
    wait for clk_period;
    start           <= '0';
 

    wait until ready = '1';
    wait for clk_period*2;
    if(blake512_out = digest) then
        report "Test Vector 1: --Passed--"     severity note;
    else
        report "Test Vector 1: --Failed--"     severity error;
    end if;



------------------------------------------------------------------------------------
-----------------------------   run Test Vector 2   --------------------------------
------------------------------------------------------------------------------------
    count           <= X"ffffffff_ffffffff_ffffffff_ffffffff";
       
    IV512           <= x"AE5F9156_E7B6D99B_CF6C85D3_9D1A1E15"&
                       x"2F73477D_6A4563CA_6D1826CA_FD82E1ED"&
                       x"8B43D457_0A51B936_E360B596_DC380C3F"&
                       x"1C456002_CE13E9F8_6F196331_43A0AF0E";
                        
    msg             <= X"ffffffff_ffffffff_ffffffff_ffffffff"&
                       X"ffffffff_ffffffff_ffffffff_ffffffff"&
                       X"ffffffff_ffffffff_ffffffff_ffffffff"&
                       X"ffffffff_ffffffff_ffffffff_ffffffff"&
                       X"ffffffff_ffffffff_ffffffff_ffffffff"&
                       X"ffffffff_ffffffff_ffffffff_ffffffff"&
                       X"ffffffff_ffffffff_ffffffff_ffffffff"&
                       X"ffffffff_ffffffff_ffffffff_ffffffff";
                       
    digest          <= x"5e5d7e63_3aa892de_35a23220_5fe4a329"&
                       x"017edd47_949324bc_0f197e32_1bbe4d1f"&
                       x"20925be0_3d2b575a_953ee2a8_ef1a29be"&
                       x"ec2a9bac_093986ee_b8973d6c_044b5528";
                       
    start           <= '1';
    wait for clk_period;
    start           <= '0';
 

    wait until ready = '1';
    wait for clk_period*2;
    if(blake512_out = digest) then
        report "Test Vector 2: --Passed--"     severity note;
    else
        report "Test Vector 2: --Failed--"     severity error;
    end if;



------------------------------------------------------------------------------------
-----------------------------   run Test Vector 3   --------------------------------
------------------------------------------------------------------------------------
        count           <= X"6a09e667_f3bcc908_6a09e667_f3bcc908";
           
        IV512           <= x"AE5F9156_E7B6D99B_CF6C85D3_9D1A1E15"&
                           x"2F73477D_6A4563CA_6D1826CA_FD82E1ED"&
                           x"8B43D457_0A51B936_E360B596_DC380C3F"&
                           x"1C456002_CE13E9F8_6F196331_43A0AF0E";
                            
        msg             <= X"adadadad_adadadad_adadadad_adadadad"&
                           X"adadadad_adadadad_adadadad_adadadad"&
                           X"adadadad_adadadad_adadadad_adadadad"&
                           X"adadadad_adadadad_adadadad_adadadad"&
                           X"adadadad_adadadad_adadadad_adadadad"&
                           X"adadadad_adadadad_adadadad_adadadad"&
                           X"adadadad_adadadad_adadadad_adadadad"&
                           X"adadadad_adadadad_adadadad_adadadad";
                           
        digest          <= x"bd2dbdb8_4643387d_c6349cc8_7abea181"&
                           x"57b0893b_92c2ca82_4c872547_af12bdfc"&
                           x"2ea17de0_ebdbc751_47abb9e0_1850a1bc"&
                           x"aa1c3c4c_54b7d490_57be0e82_0d1d998d";
                           
        start           <= '1';
        wait for clk_period;
        start           <= '0';
     
    
        wait until ready = '1';
        wait for clk_period*2;
        if(blake512_out = digest) then
            report "Test Vector 3: --Passed--"     severity note;
        else
            report "Test Vector 3: --Failed--"     severity error;
        end if;



------------------------------------------------------------------------------------
-----------------------------   run Test Vector 4   --------------------------------
------------------------------------------------------------------------------------
        count           <= X"bb67ae85_84caa73b_3c6ef372_fe94f82b";
           
        IV512           <= x"AE5F9156_E7B6D99B_CF6C85D3_9D1A1E15"&
                           x"2F73477D_6A4563CA_6D1826CA_FD82E1ED"&
                           x"8B43D457_0A51B936_E360B596_DC380C3F"&
                           x"1C456002_CE13E9F8_6F196331_43A0AF0E";
                            
        msg             <= X"efefefef_efefefef_efefefef_efefefef"&
                           X"efefefef_efefefef_efefefef_efefefef"&
                           X"efefefef_efefefef_efefefef_efefefef"&
                           X"efefefef_efefefef_efefefef_efefefef"&
                           X"efefefef_efefefef_efefefef_efefefef"&
                           X"efefefef_efefefef_efefefef_efefefef"&
                           X"efefefef_efefefef_efefefef_efefefef"&
                           X"efefefef_efefefef_efefefef_efefefef";
                           
        digest          <= x"c11de0d1_517298c5_0d63dc54_b843b370"&
                           x"0bc75c33_7684b820_1c4c16dc_924b06fe"&
                           x"93316246_d6a93122_3e774dbb_a22e18c4"&
                           x"3f59ddb8_94c30665_3150fa14_d88a5317";
                           
        start           <= '1';
        wait for clk_period;
        start           <= '0';
     
    
        wait until ready = '1';
        wait for clk_period*2;
        if(blake512_out = digest) then
            report "Test Vector 4: --Passed--"     severity note;
        else
            report "Test Vector 4: --Failed--"     severity error;
        end if;
   


    wait;
end process;

end Behavioral;
