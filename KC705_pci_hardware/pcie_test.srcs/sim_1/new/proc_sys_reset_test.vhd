----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.02.2022 20:56:59
-- Design Name: 
-- Module Name: proc_sys_reset_test - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity proc_sys_reset_test is
--  Port ( );
end proc_sys_reset_test;

architecture Behavioral of proc_sys_reset_test is

	COMPONENT proc_sys_reset_0
	  PORT (
		slowest_sync_clk : IN STD_LOGIC;
		ext_reset_in : IN STD_LOGIC;
		aux_reset_in : IN STD_LOGIC;
		mb_debug_sys_rst : IN STD_LOGIC;
		dcm_locked : IN STD_LOGIC;
		mb_reset : OUT STD_LOGIC;
		bus_struct_reset : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
		peripheral_reset : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
		interconnect_aresetn : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
		peripheral_aresetn : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
	  );
	END COMPONENT;
	signal clock : std_logic := '0';
	signal sys_reset_interconnect_aresetn : std_logic;
begin

process
begin
    clock <= not clock;
    wait for 5ns;
end process;

	proc_sys_reset_0_inst : proc_sys_reset_0 port map(
		slowest_sync_clk => clock,--CLK_100MHZ,
		ext_reset_in => '0',
		aux_reset_in => '0',
		mb_debug_sys_rst => '0',
		dcm_locked => '1',
		--mb_reset : OUT STD_LOGIC;
		--bus_struct_reset : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
		--peripheral_reset : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
		interconnect_aresetn(0) => sys_reset_interconnect_aresetn
		--peripheral_aresetn : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
	);
end Behavioral;
