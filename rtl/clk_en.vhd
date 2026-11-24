
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;
library work;
use work.analyzer_pkg.all;

entity clk_en is
generic(
    clock_frequency    : positive := CLK_FREQ ; -- 100MHz
    required_frequency : positive := SAMPLE_FREQ;  -- 1 MHz
    c_len : positive := 7);
Port (
clk :      in std_logic :='1';
en :       out std_logic :='0'

 );
end clk_en;

architecture Behavioral of clk_en is
                                    signal counter : unsigned(c_len -1 downto 0) := (others => '0'); -- we only need 7 bits to store 100
                                    constant X : positive := clock_frequency / required_frequency;
                                    signal enable :std_logic := '0';
begin
process(clk)
            begin
            if rising_edge(clk) then
            if counter = to_unsigned(X - 1, counter'length) then -- at 100 cycles
                                    enable <= '1';
                                    counter <= (others => '0');
            else 
            enable <= '0';
            counter <= counter +1;
            
            end if;
            end if;
            end process;
 en <= enable;
end Behavioral;