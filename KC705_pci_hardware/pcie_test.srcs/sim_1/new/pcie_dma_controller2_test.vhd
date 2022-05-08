
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity pcie_dma_controller2_test is
	port (
		leds : out std_logic_vector(7 downto 0)
	);
end pcie_dma_controller2_test;

architecture Behavioral of pcie_dma_controller2_test is
  component pcie_dma_controller2_test_design is
	port(
		leds_0 : out std_logic_vector(7 downto 0)
	);
  end component pcie_dma_controller2_test_design;
begin
	pcie_dma_controller2_test_design_i: component pcie_dma_controller2_test_design
	port map(
		leds_0 => leds
		);
end Behavioral;
