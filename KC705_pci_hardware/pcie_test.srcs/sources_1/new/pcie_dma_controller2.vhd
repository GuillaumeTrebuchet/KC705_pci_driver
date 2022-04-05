
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

--use work.axi_helper.ALL; 

entity pcie_dma_controller2 is
	port ( 
		clk : in std_logic;
		resetn : in std_logic;
	
		leds : out std_logic_vector(7 downto 0);
	
		-- register block ram
		clkb : out std_logic;
		addrb : out std_logic_vector(2 downto 0);
		dinb : out std_logic_vector(511 downto 0);
		doutb : in std_logic_vector(511 downto 0);
		enb : out std_logic;
		web : out std_logic_vector(63 downto 0);
	
		-- memory block ram
		mem_clka : out std_logic;
		mem_addra : out std_logic_vector(10 downto 0);
		mem_dina : out std_logic_vector(127 downto 0);
		mem_douta : in std_logic_vector(127 downto 0);
		mem_ena : out std_logic;
		mem_wea : out std_logic_vector(15 downto 0)
		);
end pcie_dma_controller2;

architecture pcie_dma_controller2_behavioral of pcie_dma_controller2 is
	
	constant REG_ID_LED : NATURAL := 0;
	constant REG_ID_DMA_SRC_ADDRESS_HI : NATURAL := 1;
	constant REG_ID_DMA_SRC_ADDRESS_LO : NATURAL := 2;
	constant REG_ID_DMA_DST_ADDRESS_HI : NATURAL := 3;
	constant REG_ID_DMA_DST_ADDRESS_LO : NATURAL := 4;
	constant REG_ID_DMA_LENGTH : NATURAL := 5;
	constant REG_ID_DMA_STATUS : NATURAL := 6;
	
	subtype register_32_t is std_logic_vector(31 downto 0);
	type register_32_array_t is array(NATURAL range <>) of register_32_t;
	
	
	type state_t is ( state_read_0, state_read_0_data );
	signal state : state_t;
	signal state_next : state_t;
	
	type dma_state_t is ( dma_state_ready, dma_state_prepare, dma_state_write);
	signal dma_state : dma_state_t;
	signal dma_state_next : dma_state_t;
	
	
	signal leds_reg : std_logic_vector(7 downto 0);
	signal leds_reg_next : std_logic_vector(7 downto 0);
	
	function RegisterFromVector(data : std_logic_vector; register_id : NATURAL) return register_32_t is
	begin
		return data(32 * register_id + 31 downto 32 * register_id);
	end function;
	
	signal dma_src_address : std_logic_vector(63 downto 0);
	signal dma_dst_address : std_logic_vector(63 downto 0);
	
	constant PCIE_CTL_REG_ADDR_AXIBAR2PCIEBAR_0U : std_logic_vector(31 downto 0) := x"00000208";
	constant PCIE_CTL_REG_ADDR_AXIBAR2PCIEBAR_0L : std_logic_vector(31 downto 0) := x"0000020C";
	constant PCIE_CTL_REG_ADDR_AXIBAR2PCIEBAR_1U : std_logic_vector(31 downto 0) := x"00000210";
	constant PCIE_CTL_REG_ADDR_AXIBAR2PCIEBAR_1L : std_logic_vector(31 downto 0) := x"00000214";
	
	type dma_direction_t is (dma_direction_mem2dev, dma_direction_dev2mem);
	signal dma_direction : dma_direction_t;
begin
	clkb <= clk;
	leds <= leds_reg;
	
	mem_clka <= clk;
	
	process (clk) is
	begin
		if rising_edge(clk) then
			state <= state_next;
			
			leds_reg <= leds_reg_next;
		end if;
	end process;

	process (state, resetn, doutb) is
	begin
		
		addrb <= "000";
		dinb <= (others => '0');
		enb <= '0';
		web <= (others => '0');
		
		leds_reg_next <= leds_reg;
		state_next <= state;
		
		if resetn = '0' then
			state_next <= state_read_0;
			leds_reg_next <= x"00";
		else
			case (state) is
				when state_read_0 =>
					addrb <= "000";
					enb <= '1';
					state_next <= state_read_0_data;
				when state_read_0_data =>
					enb <= '1';
					leds_reg_next <= RegisterFromVector(doutb, REG_ID_LED)(7 downto 0);
						
					state_next <= state_read_0;
				
				when others =>
			end case;
		end if;
	end process;
end pcie_dma_controller2_behavioral;
