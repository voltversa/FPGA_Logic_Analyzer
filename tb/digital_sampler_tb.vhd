----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.11.2026 00:59:47
-- Design Name: 
-- Module Name: digital_sampler_tb - Behavioral
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

entity digital_sampler_tb is
--  Port ( );
end digital_sampler_tb;

architecture Behavioral of digital_sampler_tb is
signal data_in  :  std_logic_vector(7 downto 0) := "00000000";
signal en :        std_logic :='0';
signal rst :       std_logic; 
signal clk :       std_logic :='0';
signal sampled :   std_logic_vector( 7 downto 0) := (others => '0') ;
begin
DUT : entity work.Digital_sampling port map( data_in => data_in,en => en,rst=>rst, clk => clk, sampled => sampled);
ck: process 
variable i : integer := 0 ;
begin
while i < 250 loop
clk <= '0';
wait for 5 ns;
clk <= '1';
wait for 5 ns;
i := i+1;
end loop;
wait;
end process;
test : process
begin
  rst <= '1';
    en <= '0';

  wait until rising_edge(clk); -- pauses the testbench until a rising edge happens
    wait for 1 ns;

    assert sampled = "00000000"
        report "Reset failed!"
        severity error;


rst <= '0';
en <= '1';
data_in <= "10101010";

    wait until rising_edge(clk);
    wait for 1 ns;
    assert sampled = "10101010"
    report "Sampling failed for 10101010!"
    severity error;
    
en <= '1';
data_in <= "11111111";

    wait until rising_edge(clk);
    wait for 1 ns;
    assert sampled = "11111111"
    report "Sampling failed for 11111111!"
    severity error;
    
en <= '1';
data_in <= "11110000";

    wait until rising_edge(clk);
    wait for 1 ns;
    
    en <= '0';
data_in <= "00000000";

wait until rising_edge(clk);
wait for 1 ns;

rst <= '1';
en <= '1';
data_in <= "01111110";

    wait until rising_edge(clk);
    wait for 1 ns;
    assert sampled = "01111110"
    report "Sampling failed for 01111110!"
    severity error;
    
    
en <= '0';
rst <= '0';

wait;

end process;
end Behavioral;
