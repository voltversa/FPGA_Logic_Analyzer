----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.11.2026 01:22:10
-- Design Name: 
-- Module Name: capture_controller - Behavioral
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

entity capture_controller is
 Port (
                 clk :      in std_logic;
                 rst :      in std_logic;
                 
                 start :    in std_logic;
                 is_valid : in  std_logic;
                 wr_en :    out std_logic;
                 wr_addr:   out unsigned( ADDR_WIDTH-1 downto 0) :=(others =>'0');
                 cap_done : out std_logic
                  );
end capture_controller;

architecture Behavioral of capture_controller is
                    type state_type is 
                                        (
                                        idle,
                                        cap,
                                        done
                                        );
                                        
                    signal state : state_type := idle;
             --       signal next_state : state_type := idle;
                    signal addr_counter : unsigned(ADDR_WIDTH-1 downto 0) := (others => '0');
begin
                    process (clk)
                    begin
                    
                    if rising_edge(clk) then
                    if rst= '1' then
                                addr_counter <= (others => '0');

                                state    <= idle; 
                           
                    else 
                    
                    case state is 
                    
                    
                    when idle =>
                    
                    if start ='1' then
                    state <= cap;
                    else
              
                    addr_counter <= (others => '0');
                
                   end if;
                    
-- capture
                   when cap =>
                   if is_valid = '1' then
                   
                   if addr_counter = "1111111111" then 
                 
                   state <= done ;
                   
                   else 
                   addr_counter <= addr_counter+1;
                   end if;
                   end if ;
                   

-- done
                   when done =>
                   null;
                   
                    end case;
                    end if;
                    end if;
end process;
                
                wr_en <= '1' when
                    (state = cap and is_valid = '1' and rst = '0')
                    else '0';
                wr_addr <= addr_counter;
                cap_done <= '1' when state = done else '0';
end Behavioral;
