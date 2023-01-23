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
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;

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
			  
			  leds : out std_logic_vector (7 downto 0);
			  
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

    COMPONENT transmitter
    PORT(
         clk : IN  std_logic;
         clk_div : IN  std_logic_vector(18 downto 0);
         parity : IN  std_logic_vector(1 downto 0);
         two_stop : IN  std_logic;
         eight_data : IN  std_logic;
         data : IN  std_logic_vector(7 downto 0);
         txdata : OUT  std_logic;
         txready : OUT  std_logic;
         txstart : IN  std_logic
        );
    END COMPONENT;
	 
	 type sysstate is (
		prepare,
		request_tx,
		wait_tx
	);
	
	signal state : sysstate := prepare;
	 
	 --constant clk_div : std_logic_vector(18 downto 0) := "0000000000110110010";	-- 57600
	 constant clk_div : std_logic_vector(18 downto 0) := "0000000101000101100";	--  9600
	 constant parity : std_logic_vector(1 downto 0) := "00";
	 constant two_stop : std_logic := '0';
	 constant eight_data : std_logic := '1';
	 signal data : std_logic_vector(7 downto 0) := "00000000";
	 signal txready : std_logic := '0';
	 signal txstart : std_logic := '0';
	 
	 signal charcount : std_logic_vector(3 downto 0) := "1111";

begin

   txunit: transmitter PORT MAP (
          clk => clkin_50,
          clk_div => clk_div,
          parity => parity,
          two_stop => two_stop,
          eight_data => eight_data,
          data => data,
          txdata => console_uart_tx,
          txready => txready,
          txstart => txstart
        );
		  
	leds(7 downto 4) <= "0000";
	leds(3 downto 0) <= charcount;
		  
	--process (txready, console_uart_rx) begin
	--	txstart <= txready and console_uart_rx;
	--end process;
	
	process (clkin_50) begin
		if rising_edge(clkin_50) and (state = prepare or state = request_tx) then
			case charcount is
				when "0000" =>
					data <= std_logic_vector(to_unsigned(natural(character'pos('C')), 8));
				when "0001" =>
					data <= std_logic_vector(to_unsigned(natural(character'pos('O')), 8));
				when "0010" =>
					data <= std_logic_vector(to_unsigned(natural(character'pos('M')), 8));
				when "0011" =>
					data <= std_logic_vector(to_unsigned(natural(character'pos('P')), 8));
				when "0100" =>
					data <= std_logic_vector(to_unsigned(natural(character'pos('Y')), 8));
				when "0101" =>
					data <= std_logic_vector(to_unsigned(natural(character'pos('-')), 8));
				when "0110" =>
					data <= std_logic_vector(to_unsigned(natural(character'pos('V')), 8));
				when "0111" =>
					data <= std_logic_vector(to_unsigned(natural(character'pos(' ')), 8));
				when "1000" =>
					data <= std_logic_vector(to_unsigned(natural(character'pos(' ')), 8));
				when others =>
					data <= "00000000";
			end case;
		end if;
	end process;
		
	process (clkin_50) begin
		if rising_edge(clkin_50) and console_uart_rx = '1' and state = prepare then
			charcount <= charcount + 1;
		end if;
	end process;
	
	process (clkin_50) begin
		if rising_edge(clkin_50) then
			case state is
				when prepare =>
					txstart <= '0';
					if console_uart_rx = '1' then
						state <= request_tx;
					end if;
					
				when request_tx =>
					txstart <= '1';
					if txready = '0' then
						state <= wait_tx;
					end if;
					
				when wait_tx =>
					txstart <= '0';
					if txready = '1' then
						state <= prepare;
					end if;
			end case;
		end if;
	end process;

	--console_uart_tx <= console_uart_rx;
end Behavioral;

