----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.11.2026 21:50:23
-- Design Name: 
-- Module Name: Digital sampling - Behavioral
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
library work;
use work.analyzer_pkg.all;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Digital_sampling is

Port (
data_in  : in std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
en :       in std_logic :='0';
rst :      in std_logic; 
clk :      in std_logic :='0';
sampled :  out std_logic_vector( DATA_WIDTH-1 downto 0) := (others => '0')

 );
end Digital_sampling;

architecture Behavioral of Digital_sampling is
signal samp :  std_logic_vector( DATA_WIDTH-1 downto 0) := (others => '0');
begin
process(clk)
begin
if rising_edge(clk) then
if rst ='1' then
samp <= (others =>'0');
elsif en = '1' then
samp <= data_in ;
end if;
end if;
end process;
sampled <= samp;
end Behavioral;
