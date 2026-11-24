----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.11.2026 23:24:25
-- Design Name: 
-- Module Name: clk_en_tb - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clk_en_tb is
--  Port ( );
end clk_en_tb;

architecture Behavioral of clk_en_tb is
constant c_f   : positive := 100_000_000;
constant r_f   : positive := 1_000_000;
constant c_len : positive := 7;

signal clk : std_logic :='0';
signal en : std_logic :='0';
begin

clllk : entity work.clk_en
generic map(     clock_frequency => c_f,
                 required_frequency => r_f,
                 c_len=> c_len  )
port map (
           clk => clk,
            en => en );

process 
variable counter: integer :=0;

begin
while  counter < 250 loop
clk <= '0';
wait for 5ns;
clk <= '1';
wait for 5ns;
counter := counter +1;
if (counter rem 100) = 0 then
assert (en = '1')
        report "Enable missing at cycle 100!"
        severity error;
        
else
    assert en = '0'
        report "Unexpected enable pulse!"
        severity error;
end if;
end loop;
wait;
end process;

end Behavioral;
