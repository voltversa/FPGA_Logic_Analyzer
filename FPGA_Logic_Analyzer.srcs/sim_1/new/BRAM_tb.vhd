----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.11.2026 23:16:52
-- Design Name: 
-- Module Name: BRAM_tb - Behavioral
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
use ieee.math_real.all; -- Required for ceil and log2
use ieee.std_logic_textio.all;
use std.textio.all;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity BRAM_tb is
--  Port ( );
end BRAM_tb;

architecture Behavioral of BRAM_tb is
    constant data_w : positive := 8;
    constant mem_w  : positive := 1024;
    constant addr_w : positive := positive(ceil(log2(real(mem_w))));
  signal       clk :    std_logic;
  signal       wr_en :  std_logic := '0';
  signal      rd_en :  std_logic := '0';
  signal       wr_data :  std_logic_vector (data_w -1 downto 0);
  signal       rd_data:  std_logic_vector (data_w -1 downto 0);
  signal       wr_addr :  unsigned(addr_w-1 downto 0);
  signal       rd_addr :  unsigned(addr_w-1 downto 0);
begin
DUT : entity work.BRAM 
        generic map 
        (
        data_w => data_w,
        mem_w  => mem_w,
        addr_w  => addr_w
        )
        port map 
        (
        clk => clk,
        wr_en => wr_en,
        rd_en => rd_en,
        wr_data => wr_data,
        rd_data => rd_data,
        wr_addr => wr_addr,
        rd_addr => rd_addr
);
clock : process
                variable i : integer := 0;
                begin
                    while i < 250 loop
                    clk <='0';
                    wait for 5ns;
                    clk <='1';
                    wait for 5ns;
                    
                    i := i+1;
                    end loop;
                wait;
        end process;
                
  test : process 
                begin
                -- write process
                wr_en   <= '1';
                wr_addr <= "0000000001";
                wr_data <= "01010101";
                
                wait until rising_edge(clk);
                wait for 1 ns;
   
                wr_en <= '0';
                
                -- read process
                -- READ TEST
                rd_en   <= '1';
                rd_addr <= "0000000001";
                
                wait until rising_edge(clk);
                wait for 1 ns;
                
                assert rd_data = "01010101"
                    report "BRAM READ FAILED!"
                    severity error;
                rd_en <= '0';
                
                -- read & write
                wr_en <='1';
                rd_en   <= '1';
                
                wr_addr <= "0000000011";
                wr_data <= "11111111";
                
                rd_addr <= "0000000001";
                
                wait until rising_edge(clk);
                wait for 1 ns;
                wr_en <='0';
                rd_en   <= '0';
                assert rd_data = "01010101"
                    report "Simultaneous read/write failed!"
                    severity error;
                    
                    
                -- READ TEST
                rd_en   <= '1';
                rd_addr <= "0000000011";
                
                wait until rising_edge(clk);
                wait for 1 ns;
                assert rd_data = "11111111"
                    report "Second memory read failed!"
                    severity error;
                
                rd_en <= '0';
                
                wait;
                end process;
end Behavioral;
