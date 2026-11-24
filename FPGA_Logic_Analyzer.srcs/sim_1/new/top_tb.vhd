
----------------------------------------------------------------------------------
-- Project Name : FPGA_Logic_Analyzer
-- Module Name  : top_tb
-- Description  : Top-Level Integration Testbench
--
-- Verification Objectives:
--   TEST 1  : System Reset
--   TEST 2  : Start Capture
--   TEST 3  : Dynamic Input Sampling
--   TEST 4  : Capture Completion
--   TEST 5  : BRAM Read - Address 0    (0xAA)
--   TEST 6  : BRAM Read - Address 11   (0x55)
--   TEST 7  : BRAM Read - Address 5    (0xAA)
--   TEST 8  : BRAM Read - Address 24   (0xF0)
--   TEST 9  : BRAM Read - Address 40   (0x0F)
--   TEST 10 : Controller DONE State Verification
--
-- Configuration:
--   Clock Frequency    : 100 MHz
--   Sampling Frequency : 1 MHz
--   Data Width         : 8 bits
--   Memory Depth       : 1024 samples
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.analyzer_pkg.all;


entity top_tb is
    -- Port ( );
end top_tb;


architecture Behavioral of top_tb is

    ------------------------------------------------------------------------------
    -- SIGNAL DECLARATIONS
    ------------------------------------------------------------------------------

    signal clk       : std_logic := '0';
    signal rst       : std_logic := '0';

    signal fpga_pins : std_logic_vector(DATA_WIDTH - 1 downto 0)
                       := (others => '0');

    signal start     : std_logic := '0';
    signal rd_en     : std_logic := '0';

    signal rd_addr   : unsigned(ADDR_WIDTH - 1 downto 0)
                       := (others => '0');

    signal rd_data   : std_logic_vector(DATA_WIDTH - 1 downto 0)
                       := (others => '0');

    signal cap_done  : std_logic := '0';


begin

    ------------------------------------------------------------------------------
    -- DUT INSTANTIATION
    -- Connect the complete Logic Analyzer Top-Level module.
    ------------------------------------------------------------------------------

    DUT : entity work.top
        port map (
            clk       => clk,
            rst       => rst,
            fpga_pins => fpga_pins,
            start     => start,
            rd_en     => rd_en,
            rd_addr   => rd_addr,
            rd_data   => rd_data,
            cap_done  => cap_done
        );


    ------------------------------------------------------------------------------
    -- CLOCK GENERATOR
    -- Frequency : 100 MHz
    -- Period    : 10 ns
    -- Duty Cycle: 50%
    ------------------------------------------------------------------------------

    clock : process
    begin

        loop
            clk <= '0';
            wait for 5 ns;

            clk <= '1';
            wait for 5 ns;
        end loop;

    end process;


    ------------------------------------------------------------------------------
    -- INTEGRATION TEST SEQUENCE
    ------------------------------------------------------------------------------

    test : process
    begin

        --------------------------------------------------------------------------
        -- TEST 1: SYSTEM RESET
        --
        -- Objective:
        --   Apply a reset to the Logic Analyzer.
        --   Verify that the capture_done signal is LOW.
        --
        -- Expected:
        --   cap_done = '0'
        --------------------------------------------------------------------------

        wait until falling_edge(clk);
        rst <= '1';

        wait until falling_edge(clk);
        rst <= '0';

        wait for 1 ns;

        assert cap_done = '0'
            report "Reset failed!"
            severity error;


        --------------------------------------------------------------------------
        -- TEST 2: START CAPTURE
        --
        -- Objective:
        --   Assert the start signal to begin recording.
        --   The Capture Controller should enter the CAP state.
        --
        -- Expected:
        --   Capture operation begins.
        --------------------------------------------------------------------------

        wait until falling_edge(clk);
        start <= '1';

        wait until rising_edge(clk);


        --------------------------------------------------------------------------
        -- TEST 3: DYNAMIC INPUT SAMPLING
        --
        -- Objective:
        --   Apply different 8-bit input patterns during capture.
        --   Verify that the Logic Analyzer can record changing digital signals.
        --
        -- Input Sequence:
        --   Pattern 1 : 0xAA for 10 us
        --   Pattern 2 : 0x55 for 10 us
        --   Pattern 3 : 0xF0 for 10 us
        --   Pattern 4 : 0x0F until capture completes
        --------------------------------------------------------------------------

        -- Pattern 1: 10101010
        fpga_pins <= "10101010";
        wait for 10 us;

        -- Pattern 2: 01010101
        fpga_pins <= x"55";
        wait for 10 us;

        -- Pattern 3: 11110000
        fpga_pins <= x"F0";
        wait for 10 us;

        -- Pattern 4: 00001111
        fpga_pins <= x"0F";


        --------------------------------------------------------------------------
        -- TEST 4: CAPTURE COMPLETION
        --
        -- Objective:
        --   Wait until the Capture Controller finishes recording.
        --   Prevent the simulation from waiting indefinitely.
        --
        -- Expected:
        --   cap_done = '1' within 2 ms
        --------------------------------------------------------------------------

        wait until falling_edge(clk);
        start <= '0';

        wait until cap_done = '1' for 2 ms;

        assert cap_done = '1'
            report "Capture timeout!"
            severity failure;


        --------------------------------------------------------------------------
        -- TEST 5: BRAM READ - ADDRESS 0
        --
        -- Objective:
        --   Read the first memory location.
        --   Verify the stored sample matches the expected input pattern.
        --
        -- Expected:
        --   Address 0 = 0xAA
        --------------------------------------------------------------------------

        rd_addr <= to_unsigned(0, ADDR_WIDTH);
        rd_en   <= '1';

        wait until rising_edge(clk);
        wait for 1 ns;

        assert rd_data = x"AA"
            report "Memory address 0 failed!"
            severity error;

        rd_en <= '0';
        wait until falling_edge(clk);


        --------------------------------------------------------------------------
        -- TEST 6: BRAM READ - ADDRESS 11
        --
        -- Objective:
        --   Verify that the second input pattern was stored correctly.
        --
        -- Expected:
        --   Address 11 = 0x55
        --------------------------------------------------------------------------

        rd_addr <= to_unsigned(11, ADDR_WIDTH);
        rd_en   <= '1';

        wait until rising_edge(clk);
        wait for 1 ns;

        assert rd_data = x"55"
            report "Address 11 failed!"
            severity error;

        rd_en <= '0';
        wait until falling_edge(clk);


        --------------------------------------------------------------------------
        -- TEST 7: BRAM READ - ADDRESS 5
        --
        -- Objective:
        --   Verify that an earlier memory location still contains
        --   the original captured data.
        --
        -- Expected:
        --   Address 5 = 0xAA
        --------------------------------------------------------------------------

        rd_addr <= to_unsigned(5, ADDR_WIDTH);
        rd_en   <= '1';

        wait until rising_edge(clk);
        wait for 1 ns;

        assert rd_data = x"AA"
            report " memory address 5 failed!"
            severity error;

        rd_en <= '0';

        wait until rising_edge(clk);
        wait for 1 ns;


        --------------------------------------------------------------------------
        -- TEST 8: BRAM READ - ADDRESS 24
        --
        -- Objective:
        --   Verify that the third input pattern was captured.
        --
        -- Expected:
        --   Address 24 = 0xF0
        --------------------------------------------------------------------------

        rd_addr <= to_unsigned(24, ADDR_WIDTH);
        rd_en   <= '1';

        wait until rising_edge(clk);
        wait for 1 ns;

        assert rd_data = x"f0"
            report "Memory address 24 failed!"
            severity error;

        rd_en <= '0';
        wait until falling_edge(clk);


        --------------------------------------------------------------------------
        -- TEST 9: BRAM READ - ADDRESS 40
        --
        -- Objective:
        --   Verify that the final input pattern was captured.
        --
        -- Expected:
        --   Address 40 = 0x0F
        --------------------------------------------------------------------------

        rd_addr <= to_unsigned(40, ADDR_WIDTH);
        rd_en   <= '1';

        wait until rising_edge(clk);
        wait for 1 ns;

        assert rd_data = x"0F"
            report "Address 40 failed!"
            severity error;

        rd_en <= '0';


        --------------------------------------------------------------------------
        -- TEST 10: CONTROLLER DONE STATE VERIFICATION
        --
        -- Objective:
        --   Verify that the Capture Controller remains in DONE
        --   after the memory read operations.
        --
        -- Expected:
        --   cap_done = '1'
        --------------------------------------------------------------------------

        assert cap_done = '1'
            report "Controller unexpectedly left DONE!"
            severity error;


        --------------------------------------------------------------------------
        -- END OF INTEGRATION TESTS
        --------------------------------------------------------------------------

        report "All integration tests completed!"
            severity note;

        std.env.finish;

    end process;

end Behavioral;
