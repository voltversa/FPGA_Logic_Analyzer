----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.11.2026 16:15:11
-- Design Name: 
-- Module Name: analyzer_pkg - 
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
use ieee.math_real.all; -- Required for ceil and log2

package analyzer_pkg is

    -- Clock configuration
    constant CLK_FREQ    : positive := 100_000_000;
    constant SAMPLE_FREQ : positive := 1_000_000;

    -- Memory configuration
    constant DATA_WIDTH  : positive := 8;
    constant MEM_DEPTH   : positive := 1024;
    constant ADDR_WIDTH  : positive :=  positive(ceil(log2(real(MEM_DEPTH))));

end package analyzer_pkg;
