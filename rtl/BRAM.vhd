----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.11.2026 20:16:17
-- Design Name: 
-- Module Name: BRAM - Behavioral
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
use ieee.math_real.all; -- Required for ceil and log2

use IEEE.NUMERIC_STD.ALL;
library work;
use work.analyzer_pkg.all;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
entity BRAM is
generic (
    data_w : positive := DATA_WIDTH;
    mem_w  : positive := MEM_DEPTH;
    addr_w : positive := ADDR_WIDTH
);
 Port ( 
 clk :   in std_logic;
 wr_en : in std_logic := '0';
 rd_en : in std_logic := '0';
 wr_data : in std_logic_vector (data_w -1 downto 0);
 rd_data: out std_logic_vector (data_w -1 downto 0);
 wr_addr : in unsigned(addr_w-1 downto 0);
 rd_addr : in unsigned(addr_w-1 downto 0)
 );
end BRAM;

architecture Behavioral of BRAM is
type mem_type is array (0 to mem_w-1) of std_logic_vector(data_w-1 downto 0) ;
signal mem : mem_type;
signal data_out: std_logic_vector(data_w-1 downto 0);
begin
        process(clk)
        begin
        if rising_edge(clk) then
        if wr_en ='1' then 
        mem(TO_INTEGER(wr_addr)) <= wr_data;
        end if;
        if rd_en ='1' then
        data_out <= mem(TO_INTEGER(rd_addr));
end if;
end if;

end process;
rd_data <= data_out; 
end Behavioral;
