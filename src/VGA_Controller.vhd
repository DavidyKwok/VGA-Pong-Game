----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:56:48 11/04/2025 
-- Design Name: 
-- Module Name:    VGA_Controller - Behavioral 
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


entity VGA_Controller is
  port(
    clk : in  std_logic;  
    reset : in  std_logic;  
    player1_y : in  std_logic_vector(8 downto 0);
    player2_y : in  std_logic_vector(8 downto 0);
    ball_x : in  std_logic_vector(9 downto 0);
    ball_y : in  std_logic_vector(8 downto 0);
    ball_scored : in  std_logic;
    hsync : out std_logic;
    vsync : out std_logic;
    Rout : out std_logic_vector(7 downto 0);
    Gout : out std_logic_vector(7 downto 0);
    Bout : out std_logic_vector(7 downto 0)
  );
end VGA_Controller;

architecture Behavioral of VGA_Controller is

  constant H_VISIBLE : integer := 640;
  constant H_FP: integer := 16;
  constant H_SYNC: integer := 96;
  constant H_BP: integer := 48;
  constant H_TOTAL: integer := 800;
  constant V_VISIBLE : integer := 480;
  constant V_FP: integer := 10;
  constant V_SYNC: integer := 2;
  constant V_BP: integer := 33;
  constant V_TOTAL: integer := 525;

  signal h_count: integer range 0 to H_TOTAL-1 := 0;
  signal v_count: integer range 0 to V_TOTAL-1 := 0;
  signal video_on: std_logic := '0';
begin
  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        h_count <= 0;
        v_count <= 0;
      else
        if h_count = H_TOTAL - 1 then
          h_count <= 0;
          if v_count = V_TOTAL - 1 then
            v_count <= 0;
          else
            v_count <= v_count + 1;
          end if;
        else
          h_count <= h_count + 1;
        end if;
      end if;
    end if;
  end process;

  hsync <= '0' when (h_count >= H_VISIBLE + H_FP and h_count <  H_VISIBLE + H_FP + H_SYNC)
           else '1';

  vsync <= '0' when (v_count >= V_VISIBLE + V_FP and v_count <  V_VISIBLE + V_FP + V_SYNC)
           else '1';

  video_on <= '1' when (h_count < H_VISIBLE and v_count < V_VISIBLE)
              else '0';

  process(clk)
    variable R, G, B : unsigned(7 downto 0);
	 constant BORDER_MARGIN_TOP : integer := 20;
	 constant BORDER_MARGIN_BOTTOM : integer:= 460;
	 constant BORDER_LEFT : integer := 30;
	 constant BORDER_RIGHT: integer:= H_VISIBLE - 30;
    constant BORDER_WIDTH: integer := 10;
    constant PADDLE_WIDTH: integer := 8;
    constant PADDLE_HEIGHT: integer := 100;
    constant BALL_SIZE: integer := 12;
    constant GOAL_HEIGHT: integer := 120;
    constant GOAL_TOP: integer := (V_VISIBLE - GOAL_HEIGHT)/2;
    constant GOAL_BOTTOM: integer := (V_VISIBLE + GOAL_HEIGHT)/2;
    constant CENTER_X: integer := H_VISIBLE / 2;
  begin
    if rising_edge(clk) then
      R := (others => '0');
      G := (others => '0');
      B := (others => '0');

      if video_on = '1' then
        R := (others => '0');
        G := (others => '1');
        B := (others => '0');
			-- drawing borders

			-- top horizontal border
			if (v_count >= BORDER_MARGIN_TOP and v_count < BORDER_MARGIN_TOP + BORDER_WIDTH) and (h_count >= BORDER_LEFT and h_count <= BORDER_RIGHT - 1) then
			  R := (others => '1');
			  G := (others => '1');
			  B := (others => '1');
			end if;

			-- bottom horizontal border
			if (v_count >= BORDER_MARGIN_BOTTOM - BORDER_WIDTH and v_count < BORDER_MARGIN_BOTTOM) and (h_count >= BORDER_LEFT and h_count <= BORDER_RIGHT - 1) then
			  R := (others => '1');
			  G := (others => '1');
			  B := (others => '1');
			end if;

			-- left vertical border with goal
			if (h_count >= BORDER_LEFT and h_count < BORDER_LEFT + BORDER_WIDTH) and (v_count >= BORDER_MARGIN_TOP + BORDER_WIDTH) and (v_count < BORDER_MARGIN_BOTTOM - BORDER_WIDTH) and not (v_count >= GOAL_TOP and v_count < GOAL_BOTTOM) then
			  R := (others => '1');
			  G := (others => '1');
			  B := (others => '1');
			end if;

			-- right vertical border with goal 
			if (h_count >= BORDER_RIGHT - BORDER_WIDTH and h_count < BORDER_RIGHT) and (v_count >= BORDER_MARGIN_TOP + BORDER_WIDTH) and (v_count < BORDER_MARGIN_BOTTOM - BORDER_WIDTH) and not (v_count >= GOAL_TOP and v_count < GOAL_BOTTOM) then
			  R := (others => '1');
			  G := (others => '1');
			  B := (others => '1');
			end if;

		  -- drawing the center line
        if (h_count > 318 and h_count < 322) then
			  if (v_count > 60 and v_count < 100) or (v_count > 140 and v_count < 180) or (v_count > 220 and v_count < 260) or (v_count > 300 and v_count < 340) or (v_count > 380 and v_count < 420) then
				 R := (others => '0');
				 G := (others => '0');
				 B := (others => '0');  
			  end if;
			end if;

        -- drawing left blue paddle
        if (h_count >= BORDER_LEFT + 15 and h_count < BORDER_LEFT + 15 + PADDLE_WIDTH) and (v_count >= to_integer(unsigned(player1_y)) and v_count <  to_integer(unsigned(player1_y)) + PADDLE_HEIGHT) then
          R := (others => '0');
          G := (others => '0');
          B := (others => '1');
        end if;
			-- drawing right pink paddle
        if (h_count >= BORDER_RIGHT - 15 - PADDLE_WIDTH and h_count <  BORDER_RIGHT - 15) and (v_count >= to_integer(unsigned(player2_y)) and v_count <  to_integer(unsigned(player2_y)) + PADDLE_HEIGHT) then
          R := (others => '1');
          G := (others => '0');
          B := (others => '1');
        end if;

        -- changing ball colour
        if (h_count >= to_integer(unsigned(ball_x)) and h_count <  to_integer(unsigned(ball_x)) + BALL_SIZE) and (v_count >= to_integer(unsigned(ball_y)) and v_count <  to_integer(unsigned(ball_y)) + BALL_SIZE) then
          if ball_scored = '1' then
            R := (others => '1'); G := (others => '0'); B := (others => '0');  
          else
            R := (others => '1'); G := (others => '1'); B := (others => '0'); 
          end if;
        end if;
      end if;

      Rout <= std_logic_vector(R);
      Gout <= std_logic_vector(G);
      Bout <= std_logic_vector(B);
    end if;
  end process;

end Behavioral;