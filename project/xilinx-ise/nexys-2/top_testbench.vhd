--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:24:03 01/11/2023
-- Design Name:   
-- Module Name:   /home/greg/git/compy-v/project/xilinx-ise/nexys-2/top_testbench.vhd
-- Project Name:  nexys-2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: top
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY top_testbench IS
END top_testbench;
 
ARCHITECTURE behavior OF top_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT top
    PORT(
         clkin_50 : IN  std_logic;
         leds : OUT  std_logic_vector(7 downto 0);
         console_uart_tx : OUT  std_logic;
         console_uart_rx : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clkin_50 : std_logic := '0';
   signal console_uart_rx : std_logic := '0';

 	--Outputs
   signal leds : std_logic_vector(7 downto 0);
   signal console_uart_tx : std_logic;

   -- Clock period definitions
   constant clkin_50_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: top PORT MAP (
          clkin_50 => clkin_50,
          leds => leds,
          console_uart_tx => console_uart_tx,
          console_uart_rx => console_uart_rx
        );

   -- Clock process definitions
   clkin_50_process :process
   begin
		clkin_50 <= '0';
		wait for clkin_50_period/2;
		clkin_50 <= '1';
		wait for clkin_50_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clkin_50_period*10;

      -- insert stimulus here
		console_uart_rx <= '1';
		

      wait;
   end process;

END;
