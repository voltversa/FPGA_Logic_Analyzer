----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.11.2026 02:12:12
-- Design Name: 
-- Module Name: cap_controller_tb - Behavioral
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

entity cap_controller_tb is
--  Port ( );
end cap_controller_tb;

architecture Behavioral of cap_controller_tb is
 signal clk :       std_logic :='0';
 signal       rst :       std_logic :='0';
         
signal         start :     std_logic:='0';
signal         is_valid :   std_logic:='0';
signal         wr_en :     std_logic:='0';
signal        wr_addr:    unsigned( 9 downto 0) :=(others =>'0');
signal       cap_done :  std_logic :='0';
begin
 DUT : entity work.capture_controller port map (
   clk => clk , rst => rst ,
   start => start , is_valid => is_valid,
   wr_en => wr_en, wr_addr => wr_addr,
   cap_done => cap_done
 );
clock : process 
variable i : integer := 0;
begin
while i< 1200 loop
clk <= '0';
wait for 5ns;
clk <= '1';
wait for 5ns;
i:= i+1;
end loop ;
wait;
end process ;

test : process 
begin
wait until rising_edge (clk);
rst <= '1';
wait for 1 ns;

assert wr_addr = "00000000000" 
report "rest failed"
severity error;

assert cap_done = '0'
    report "Reset failed: cap_done is HIGH"
    severity error;
    
wait until falling_edge(clk);
rst <= '0';
start <= '1';

wait until rising_edge(clk);
wait for 1 ns;

wait until rising_edge (clk);
wait for 1ns;
is_valid <= '1';
wait for 1 ns;

assert wr_en = '1'
    report "writting error"
    severity error;
    
wait for 10.24us;
assert wr_addr = "1111111111"
    report "last number failed"
    severity error;
is_valid <= '0';
wait until rising_edge(clk);
wait for 1 ns;

assert wr_en = '0'
    report "Unexpected write enable"
    severity error;
    
assert cap_done = '1'
    report "cap_done is low"
    severity error;
wait;
end process ;
end Behavioral;
