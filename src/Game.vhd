----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:20:20 11/05/2025 
-- Design Name: 
-- Module Name:    Game - Behavioral 
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


entity Game is
  port(
    clk : in  std_logic;  
    reset : in  std_logic;  
    P1_Up : in  std_logic;
    P1_Down : in  std_logic;
    P2_Up : in  std_logic;
    P2_Down: in  std_logic;
    hsync : out std_logic;
    vsync : out std_logic;
    dac_clk : out std_logic;
    Rout : out std_logic_vector(7 downto 0);
    Gout : out std_logic_vector(7 downto 0);
    Bout : out std_logic_vector(7 downto 0)
  );
end Game;
architecture Structural of Game is
  signal dac_clk_int : std_logic;
  signal hsync_int : std_logic;
  signal vsync_int : std_logic;
  signal player1_y : std_logic_vector(8 downto 0);
  signal player2_y : std_logic_vector(8 downto 0);
  signal ball_x : std_logic_vector(9 downto 0);
  signal ball_y : std_logic_vector(8 downto 0);
  signal ball_scored : std_logic;
  signal Rout_int : std_logic_vector(7 downto 0);
  signal Gout_int : std_logic_vector(7 downto 0);
  signal Bout_int : std_logic_vector(7 downto 0);

  component ICON
    port (
      CONTROL0 : out std_logic_vector(35 downto 0)
    );
  end component;
  component ILA
    port (
      CONTROL : in  std_logic_vector(35 downto 0);
      CLK : in  std_logic;
      TRIG0 : in  std_logic_vector(26 downto 0)
    );
  end component;
  signal CONTROL0 : std_logic_vector(35 downto 0);
  signal TRIG0 : std_logic_vector(26 downto 0);
begin

  ClockDiv : entity work.Clock_Divider
    port map(
      clk_in => clk,
      reset => reset,
      clk_out => dac_clk_int
    );
  dac_clk <= dac_clk_int;

  PlayerCtrl : entity work.Player_Control
    port map(
      clk => dac_clk_int,
      reset => reset,
      P1_Up => P1_Up,
      P1_Down => P1_Down,
      P2_Up => P2_Up,
      P2_Down => P2_Down,
      player1_y => player1_y,
      player2_y => player2_y
    );

  BallPhys : entity work.Ball_Physics
    port map(
      clk => dac_clk_int,
      reset => reset,
      player1_y => player1_y,
      player2_y => player2_y,
      ball_x => ball_x,
      ball_y => ball_y,
      ball_scored => ball_scored
    );

  VGA_FULL : entity work.VGA_Controller
    port map(
      clk => dac_clk_int,
      reset => reset,
      player1_y => player1_y,
      player2_y => player2_y,
      ball_x => ball_x,
      ball_y => ball_y,
      ball_scored => ball_scored,
      hsync => hsync_int,
      vsync => vsync_int,
      Rout  => Rout_int,
      Gout  => Gout_int,
      Bout  => Bout_int
    );
	
  hsync <= hsync_int;
  vsync <= vsync_int;
  Rout <= Rout_int;
  Gout <= Gout_int;
  Bout <= Bout_int;

  TRIG0(0) <= hsync_int;
  TRIG0(1) <= vsync_int;
  TRIG0(2) <= dac_clk_int;
  TRIG0(10 downto 3)  <= Rout_int;  
  TRIG0(18 downto 11) <= Gout_int;  
  TRIG0(26 downto 19) <= Bout_int;  
  G_ICON : ICON
    port map (
      CONTROL0 => CONTROL0
    );
  G_ILA : ILA
    port map(
      CONTROL => CONTROL0,
      CLK => dac_clk_int,
      TRIG0 => TRIG0
    );
end Structural;