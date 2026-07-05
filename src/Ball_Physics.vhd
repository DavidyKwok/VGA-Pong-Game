----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:25:09 11/05/2025 
-- Design Name: 
-- Module Name:    Ball_Physics - Behavioral 
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

entity Ball_Physics is
	port(
		clk : in std_logic;
		reset : in std_logic;
		player1_y : in std_logic_vector(8 downto 0);
		player2_y : in std_logic_vector(8 downto 0);
		ball_x : out std_logic_vector(9 downto 0);
		ball_y : out std_logic_vector(8 downto 0);
		ball_scored: out std_logic
		);
end Ball_Physics;

architecture Behavioral of Ball_Physics is

  constant H_VISIBLE : integer := 640;
  constant V_VISIBLE : integer := 480;
  constant BALL_SIZE : integer := 12;
  constant BORDER_LEFT : integer := 30;
  constant BORDER_RIGHT: integer:= H_VISIBLE - 30;
  constant BORDER_WIDTH: integer := 10;
  constant PADDLE_WIDTH : integer := 8;   
  constant PADDLE_HEIGHT : integer := 100;
  constant GOAL_HEIGHT : integer := 120;
  constant GOAL_TOP : integer := (V_VISIBLE - GOAL_HEIGHT)/2;
  constant GOAL_BOTTOM : integer := (V_VISIBLE + GOAL_HEIGHT)/2;
  constant BORDER_MARGIN_TOP : integer := 20;
  constant BORDER_MARGIN_BOTTOM : integer := 460;
  constant LEFT_INNER : integer := BORDER_LEFT  + BORDER_WIDTH;
  constant RIGHT_INNER: integer := BORDER_RIGHT - BORDER_WIDTH;
  constant TOP_INNER : integer := BORDER_MARGIN_TOP + BORDER_WIDTH;
  constant BOTTOM_INNER : integer := BORDER_MARGIN_BOTTOM - BORDER_WIDTH;

  
  signal bx : integer := H_VISIBLE/2;
  signal by : integer := V_VISIBLE/2;
  signal dx, dy : integer := 1;
  signal score_flag : std_logic := '0';

  constant WAIT_TIME : integer := 12500000;
  signal wait_count: integer :=0;
  signal wait_done : std_logic := '1';
  
  constant BALL_SPEED : integer := 250000;
  signal frame_count : integer := 0;
  
begin
	process(clk,reset)
	begin 
		if reset = '1' then 
			bx <= H_VISIBLE/2;
			by <= V_VISIBLE/2;
			dx <= 1; 
			dy <= 1;
			score_flag <= '0';
			wait_count <= 0;
			wait_done <= '1';
		elsif rising_edge(clk) then
		   -- when a goal is scored reset the ball in the middle
			if wait_done = '0' then
			  if wait_count < WAIT_TIME then
				 wait_count <= wait_count + 1;
				 score_flag <= '1';   
			  else
				 wait_done <= '1';
				 wait_count <= 0;
				 score_flag <= '0';   
				 -- Reset ball to center after delay
				 bx <= H_VISIBLE/2;
				 by <= V_VISIBLE/2;
				 dx <= 1;
				 dy <= 1;
			  end if;
		else
			if frame_count < BALL_SPEED then
				frame_count <= frame_count +1;
			else
				frame_count <= 0;
				-- update position
				bx <= bx + dx;
				by <= by + dy;
					-- bounce off edges
				if by <= TOP_INNER then
            dy <= 1;
          elsif (by + BALL_SIZE) >= BOTTOM_INNER then
            dy <= -1;
          end if;
			 -- paddle collision
          if (bx <= BORDER_LEFT + 15 + PADDLE_WIDTH) and (bx + BALL_SIZE >= BORDER_LEFT + 15) and (by + BALL_SIZE >= to_integer(unsigned(player1_y))) and (by <= to_integer(unsigned(player1_y)) + PADDLE_HEIGHT) then
            dx <= 1;
          end if;
          if (bx + BALL_SIZE >= BORDER_RIGHT - 15 - PADDLE_WIDTH) and (bx <= BORDER_RIGHT - 15) and (by + BALL_SIZE >= to_integer(unsigned(player2_y))) and (by <= to_integer(unsigned(player2_y)) + PADDLE_HEIGHT) then
            dx <= -1;
          end if;
			 if (bx <= LEFT_INNER) then
			  -- check if ball is fully past the border on left side
			  if (bx + BALL_SIZE) <= BORDER_LEFT then
				 -- if inside then goal
				 if (by >= GOAL_TOP and (by + BALL_SIZE) <= GOAL_BOTTOM) then
					score_flag <= '1';
					wait_done  <= '0';
					wait_count <= 0;
				 else
					-- hit a wall
					dx <= 1;
				 end if;
			  else
				 -- If ball touching left border
				 if (by < GOAL_TOP or (by + BALL_SIZE) > GOAL_BOTTOM) then
					dx <= 1;
				 end if;
			  end if;
			-- right border
			elsif (bx + BALL_SIZE >= RIGHT_INNER) then
			  -- check if ball is fully past the border on right side
			  if (bx >= BORDER_RIGHT) then
				 if (by >= GOAL_TOP and (by + BALL_SIZE) <= GOAL_BOTTOM) then
					score_flag <= '1';
					wait_done  <= '0';
					wait_count <= 0;
				 else
					dx <= -1;
				 end if;
			  else
				 -- If touching border bounce back
				 if (by < GOAL_TOP or (by + BALL_SIZE) > GOAL_BOTTOM) then
					dx <= -1;
				 end if;
			  end if;
			else
			  score_flag <= '0';
			end if;

       end if; 
     end if;   
   end if;     
end process;


ball_x <= std_logic_vector(to_unsigned(bx, 10));
ball_y <= std_logic_vector(to_unsigned(by, 9));
ball_scored <= score_flag;



end Behavioral;

