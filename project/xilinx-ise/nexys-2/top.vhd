----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:37:59 01/07/2023 
-- Design Name: 
-- Module Name:    top - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
    Port ( clkin_50 : in  STD_LOGIC;
	        -- NOTE: Address bus is actually 32 bits, but
			  -- nothing outside of the FPGA uses that many bits.
			  -- The 16MB RAM and Flash chips only need 24 bits
			  -- (plus chip select), while the peripheral bus will
			  -- either be 16-bit data + 24-bit address OR
			  -- 32-bit data + 8-bit address w/ bank switching (TBD)
           --mem_addr : out  STD_LOGIC_VECTOR (23 downto 0);
           --mem_data : inout  STD_LOGIC_VECTOR (16 downto 0);

			  -- ---------
			  -- Signals specific to the 16MB RAM module
           --ram_oe : out  STD_LOGIC;
           --ram_we : out  STD_LOGIC;
           --ram_mt_adv : out  STD_LOGIC;
           --ram_mt_clk : out  STD_LOGIC;
			  -- CE == Chip Enable
           --ram_mt_ce : out  STD_LOGIC;
           --ram_mt_wait : out  STD_LOGIC;
			  -- ---------

           --reset : in  STD_LOGIC;
           --reset_out : out  STD_LOGIC;
			  
           console_uart_tx : out  STD_LOGIC;
           console_uart_rx : in  STD_LOGIC--;
			  
           --vga_hsync : out  STD_LOGIC;
           --vga_vsync : out  STD_LOGIC;
           --vga_low_red : out  STD_LOGIC_VECTOR (2 downto 0);
           --vga_low_green : out  STD_LOGIC_VECTOR (2 downto 0);
           --vga_low_blue : out  STD_LOGIC_VECTOR (1 downto 0);
           --vga_high_red : out  STD_LOGIC_VECTOR (3 downto 0);
           --vga_high_green : out  STD_LOGIC_VECTOR (3 downto 0);
           --vga_high_blue : out  STD_LOGIC_VECTOR (3 downto 0)
		);
end top;

architecture Behavioral of top is

begin
	console_uart_tx <= console_uart_rx;
end Behavioral;

