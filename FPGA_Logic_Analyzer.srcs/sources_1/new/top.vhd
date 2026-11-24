----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.11.2026 03:21:14
-- Design Name: 
-- Module Name: top - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
library work;
use work.analyzer_pkg.all;
library UNISIM;
use UNISIM.VComponents.all;

entity top is
Port (
clk : in std_logic ;
rst : in std_logic ;
fpga_pins : in std_logic_vector (DATA_WIDTH - 1  downto 0);
 start : in std_logic;
 rd_en : in std_logic;
 rd_addr : in unsigned(ADDR_WIDTH-1 downto 0);
 rd_data: out std_logic_vector ( DATA_WIDTH - 1  downto 0);
 cap_done : out std_logic

 );
end top;

architecture Behavioral of top is
signal en : std_logic;
signal sampled: std_logic_vector ( DATA_WIDTH - 1  downto 0);
 signal sample_valid :std_logic;
 signal wr_en :std_logic;
 signal wr_addr : unsigned(ADDR_WIDTH -1 downto 0);
begin
clk_gen: entity work.clk_en generic map(clock_frequency=>CLK_FREQ,required_frequency=>SAMPLE_FREQ,c_len=>7) port map ( clk => clk,en=>en);
sampler : entity work.Digital_sampling port map ( data_in=>fpga_pins , en=>en ,rst=>rst, clk=>clk, sampled=>sampled);
cap_control: entity work.capture_controller port map (clk =>clk, rst=>rst, start=> start ,is_valid=>sample_valid, wr_en=>wr_en, wr_addr=>wr_addr, cap_done=>cap_done);
store: entity work.BRAM  generic map (data_w => DATA_WIDTH,mem_w  => MEM_DEPTH,addr_w => ADDR_WIDTH) port map(clk=>clk, wr_en=>wr_en ,rd_en=>rd_en ,wr_data=>sampled ,rd_data=> rd_data,wr_addr=>wr_addr ,rd_addr=> rd_addr);

-- we need this process to delay 'en' 1 cycle so bram can store the new value on the next rising adge
process(clk)
begin
    if rising_edge(clk) then
        if rst = '1' then
            sample_valid <= '0';
        else
            sample_valid <= en;
        end if;
    end if;
end process;
end Behavioral;
