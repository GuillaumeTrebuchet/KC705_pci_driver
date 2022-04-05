
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity pcie_design_top is
    port (
		PCIE_RX0_P : in std_logic;
		PCIE_RX0_N : in std_logic;
		PCIE_RX1_P : in std_logic;
		PCIE_RX1_N : in std_logic;
		PCIE_RX2_P : in std_logic;
		PCIE_RX2_N : in std_logic;
		PCIE_RX3_P : in std_logic;
		PCIE_RX3_N : in std_logic;
		PCIE_RX4_P : in std_logic;
		PCIE_RX4_N : in std_logic;
		PCIE_RX5_P : in std_logic;
		PCIE_RX5_N : in std_logic;
		PCIE_RX6_P : in std_logic;
		PCIE_RX6_N : in std_logic;
		PCIE_RX7_P : in std_logic;
		PCIE_RX7_N : in std_logic;
		
		PCIE_TX0_P : out std_logic;
		PCIE_TX0_N : out std_logic;
		PCIE_TX1_P : out std_logic;
		PCIE_TX1_N : out std_logic;
		PCIE_TX2_P : out std_logic;
		PCIE_TX2_N : out std_logic;
		PCIE_TX3_P : out std_logic;
		PCIE_TX3_N : out std_logic;
		PCIE_TX4_P : out std_logic;
		PCIE_TX4_N : out std_logic;
		PCIE_TX5_P : out std_logic;
		PCIE_TX5_N : out std_logic;
		PCIE_TX6_P : out std_logic;
		PCIE_TX6_N : out std_logic;
		PCIE_TX7_P : out std_logic;
		PCIE_TX7_N : out std_logic;
	
		PCIE_PERST_LS : in std_logic;
	
		PCIE_CLK_QO_P : in std_logic;
		PCIE_CLK_QO_N : in std_logic;
	
		SYSCLK_P : in std_logic;
		SYSCLK_N : in std_logic;
	
        USB_CTS : out std_logic;
        USB_RTS : in std_logic;
        USB_TX : in std_logic;
        USB_RX : out std_logic;
	
        GPIO_LED_0_LS : out std_logic;
        GPIO_LED_1_LS : out std_logic;
        GPIO_LED_2_LS : out std_logic;
        GPIO_LED_3_LS : out std_logic;
        GPIO_LED_4_LS : out std_logic;
        GPIO_LED_5_LS : out std_logic;
        GPIO_LED_6_LS : out std_logic;
        GPIO_LED_7_LS : out std_logic
	);
end pcie_design_top;

architecture pcie_design_top_behavioral of pcie_design_top is
    component design_1 is
        port (
			pcie_refclk_clk_p : in STD_LOGIC;
			pcie_refclk_clk_n : in STD_LOGIC;
			PCIE_PERST_LS : in STD_LOGIC;
			pcie_7x_mgt_0_rxn : in STD_LOGIC_VECTOR ( 7 downto 0 );
			pcie_7x_mgt_0_rxp : in STD_LOGIC_VECTOR ( 7 downto 0 );
			pcie_7x_mgt_0_txn : out STD_LOGIC_VECTOR ( 7 downto 0 );
			pcie_7x_mgt_0_txp : out STD_LOGIC_VECTOR ( 7 downto 0 );
			leds_0 : out STD_LOGIC_VECTOR ( 7 downto 0 )
        );
    end component design_1;
	signal leds : std_logic_vector(7 downto 0);
	
	signal PCIE_TX_P : std_logic_vector(7 downto 0);
	signal PCIE_TX_N : std_logic_vector(7 downto 0);
	signal PCIE_RX_P : std_logic_vector(7 downto 0);
	signal PCIE_RX_N : std_logic_vector(7 downto 0);
begin
	(GPIO_LED_7_LS, GPIO_LED_6_LS, GPIO_LED_5_LS, GPIO_LED_4_LS, GPIO_LED_3_LS, GPIO_LED_2_LS, GPIO_LED_1_LS, GPIO_LED_0_LS) <= leds;
		
	(PCIE_TX0_P,
	PCIE_TX1_P,
	PCIE_TX2_P,
	PCIE_TX3_P,
	PCIE_TX4_P,
	PCIE_TX5_P,
	PCIE_TX6_P,
	PCIE_TX7_P) <= PCIE_TX_P;
	(PCIE_TX0_N,
	PCIE_TX1_N,
	PCIE_TX2_N,
	PCIE_TX3_N,
	PCIE_TX4_N,
	PCIE_TX5_N,
	PCIE_TX6_N,
	PCIE_TX7_N) <= PCIE_TX_N;
	
	PCIE_RX_P <= (PCIE_RX0_P,
		PCIE_RX1_P,
		PCIE_RX2_P,
		PCIE_RX3_P,
		PCIE_RX4_P,
		PCIE_RX5_P,
		PCIE_RX6_P,
		PCIE_RX7_P);
	PCIE_RX_N <= (PCIE_RX0_N,
		PCIE_RX1_N,
		PCIE_RX2_N,
		PCIE_RX3_N,
		PCIE_RX4_N,
		PCIE_RX5_N,
		PCIE_RX6_N,
		PCIE_RX7_N);
	
	design_1_i: component design_1
		port map (
			PCIE_PERST_LS => PCIE_PERST_LS,
			leds_0 => leds,
			pcie_7x_mgt_0_rxn => PCIE_RX_N,
			pcie_7x_mgt_0_rxp => PCIE_RX_P,
			pcie_7x_mgt_0_txn => PCIE_TX_N,
			pcie_7x_mgt_0_txp => PCIE_TX_P,
			pcie_refclk_clk_n => PCIE_CLK_QO_N,
			pcie_refclk_clk_p => PCIE_CLK_QO_P
		);
end pcie_design_top_behavioral;
