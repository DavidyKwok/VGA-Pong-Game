----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:58:08 11/05/2025 
-- Design Name: 
-- Module Name:    Player_Control - Behavioral 
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Player_Control is
	port (
    clk : in  std_logic;  
    reset : in  std_logic;
    P1_Up : in  std_logic;
    P1_Down : in  std_logic;
    P2_Up : in  std_logic;
    P2_Down : in  std_logic;
    player1_y : out std_logic_vector(8 downto 0);
    player2_y : out std_logic_vector(8 downto 0)
  );
end Player_Control;

architecture Behavioral of Player_Control is

  constant V_VISIBLE : integer := 480;
  constant PADDLE_HEIGHT : integer := 100;
  constant MOVE_SPEED : integer := 300000; 
  constant TOP_MARGIN : integer := 20;
  constant BOTTOM_MARGIN : integer :=20;
  signal p1_y, p2_y : unsigned(8 downto 0) := (others => '0');
  signal move_counter : integer := 0;
  
begin

	process(clk, reset)
	begin
		if reset = '1' then
			p1_y <= to_unsigned((V_VISIBLE - PADDLE_HEIGHT)/2, 9);
			p2_y <= to_unsigned((V_VISIBLE - PADDLE_HEIGHT)/2, 9);
			move_counter <= 0;
		elsif rising_edge(clk) then
		-- movement delay
			if move_counter < MOVE_SPEED then 
				move_counter <= move_counter + 1;
			else
				move_counter <= 0;
				   -- moves up or down 1 pixel
				   if P1_Up = '1' and to_integer(p1_y) > TOP_MARGIN + 10 then
						p1_y <= p1_y - 1;
					elsif P1_Down = '1' and to_integer(p1_y) < (V_VISIBLE - PADDLE_HEIGHT - BOTTOM_MARGIN - 10) then
						p1_y <= p1_y + 1;
					end if;
					
					if P2_Up = '1' and to_integer(p2_y) > TOP_MARGIN + 10 then
						p2_y <= p2_y - 1;
					elsif P2_Down = '1' and to_integer(p2_y) < (V_VISIBLE - PADDLE_HEIGHT - BOTTOM_MARGIN - 10) then
						p2_y <= p2_y + 1;
					end if;
			end if;
     end if;
  end process;
  player1_y <= std_logic_vector(p1_y);
  player2_y <= std_logic_vector(p2_y);

end Behavioral;

