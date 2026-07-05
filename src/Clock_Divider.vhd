----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:12:09 11/05/2025 
-- Design Name: 
-- Module Name:    Clock_Divider - Behavioral 
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

entity Clock_Divider is
  port(
    clk_in  : in  std_logic;   -- 50 MHz board clock
    reset   : in  std_logic;   -- active-high reset (tie low if unused)
    clk_out : out std_logic    -- 25 MHz pixel clock output
  );
end Clock_Divider;

architecture Behavioral of Clock_Divider is
  signal clk_div : std_logic := '0';
begin

  process(clk_in)
  begin
    if rising_edge(clk_in) then
      if reset = '1' then
        clk_div <= '0';
      else
        clk_div <= not clk_div;
      end if;
    end if;
  end process;

  clk_out <= clk_div;

end Behavioral;
