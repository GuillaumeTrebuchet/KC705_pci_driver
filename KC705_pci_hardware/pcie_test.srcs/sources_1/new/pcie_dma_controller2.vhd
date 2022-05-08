
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

use work.axi_helper.ALL; 

entity pcie_dma_controller2 is
	port ( 
		clk : in std_logic;
		resetn : in std_logic;
	
		leds : out std_logic_vector(7 downto 0);
	
		-- register block ram
		clkb : out std_logic;
		addrb : out std_logic_vector(31 downto 0);
		dinb : out std_logic_vector(511 downto 0);
		doutb : in std_logic_vector(511 downto 0);
		enb : out std_logic;
		web : out std_logic_vector(63 downto 0);
		rstb : out std_logic;
		
		-- memory mm
		m_mem_axi_awid : out STD_LOGIC_VECTOR ( 3 downto 0 );
		m_mem_axi_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
		m_mem_axi_awregion : out STD_LOGIC_VECTOR ( 3 downto 0 );
		m_mem_axi_awlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
		m_mem_axi_awsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
		m_mem_axi_awburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
		m_mem_axi_awvalid : out STD_LOGIC;
		m_mem_axi_awready : in STD_LOGIC;
		m_mem_axi_wdata : out STD_LOGIC_VECTOR ( 127 downto 0 );
		m_mem_axi_wstrb : out STD_LOGIC_VECTOR ( 15 downto 0 );
		m_mem_axi_wlast : out STD_LOGIC;
		m_mem_axi_wvalid : out STD_LOGIC;
		m_mem_axi_wready : in STD_LOGIC;
		m_mem_axi_bid : in STD_LOGIC_VECTOR ( 3 downto 0 );
		m_mem_axi_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
		m_mem_axi_bvalid : in STD_LOGIC;
		m_mem_axi_bready : out STD_LOGIC;
		m_mem_axi_arid : out STD_LOGIC_VECTOR ( 3 downto 0 );
		m_mem_axi_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
		m_mem_axi_arregion : out STD_LOGIC_VECTOR ( 3 downto 0 );
		m_mem_axi_arlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
		m_mem_axi_arsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
		m_mem_axi_arburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
		m_mem_axi_arvalid : out STD_LOGIC;
		m_mem_axi_arready : in STD_LOGIC;
		m_mem_axi_rid : in STD_LOGIC_VECTOR ( 3 downto 0 );
		m_mem_axi_rdata : in STD_LOGIC_VECTOR ( 127 downto 0 );
		m_mem_axi_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
		m_mem_axi_rlast : in STD_LOGIC;
		m_mem_axi_rvalid : in STD_LOGIC;
		m_mem_axi_rready : out STD_LOGIC;
	
		-- pcie mm
		m_pcie_axi_awid : out STD_LOGIC_VECTOR ( 3 downto 0 );
		m_pcie_axi_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
		m_pcie_axi_awregion : out STD_LOGIC_VECTOR ( 3 downto 0 );
		m_pcie_axi_awlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
		m_pcie_axi_awsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
		m_pcie_axi_awburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
		m_pcie_axi_awvalid : out STD_LOGIC;
		m_pcie_axi_awready : in STD_LOGIC;
		m_pcie_axi_wdata : out STD_LOGIC_VECTOR ( 127 downto 0 );
		m_pcie_axi_wstrb : out STD_LOGIC_VECTOR ( 15 downto 0 );
		m_pcie_axi_wlast : out STD_LOGIC;
		m_pcie_axi_wvalid : out STD_LOGIC;
		m_pcie_axi_wready : in STD_LOGIC;
		m_pcie_axi_bid : in STD_LOGIC_VECTOR ( 3 downto 0 );
		m_pcie_axi_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
		m_pcie_axi_bvalid : in STD_LOGIC;
		m_pcie_axi_bready : out STD_LOGIC;
		m_pcie_axi_arid : out STD_LOGIC_VECTOR ( 3 downto 0 );
		m_pcie_axi_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
		m_pcie_axi_arregion : out STD_LOGIC_VECTOR ( 3 downto 0 );
		m_pcie_axi_arlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
		m_pcie_axi_arsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
		m_pcie_axi_arburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
		m_pcie_axi_arvalid : out STD_LOGIC;
		m_pcie_axi_arready : in STD_LOGIC;
		m_pcie_axi_rid : in STD_LOGIC_VECTOR ( 3 downto 0 );
		m_pcie_axi_rdata : in STD_LOGIC_VECTOR ( 127 downto 0 );
		m_pcie_axi_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
		m_pcie_axi_rlast : in STD_LOGIC;
		m_pcie_axi_rvalid : in STD_LOGIC;
		m_pcie_axi_rready : out STD_LOGIC;
			
		-- pci control
		m_pcie_axi_ctl_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
		m_pcie_axi_ctl_awvalid : out STD_LOGIC;
		m_pcie_axi_ctl_awready : in STD_LOGIC;
		m_pcie_axi_ctl_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
		m_pcie_axi_ctl_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
		m_pcie_axi_ctl_wvalid : out STD_LOGIC;
		m_pcie_axi_ctl_wready : in STD_LOGIC;
		m_pcie_axi_ctl_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
		m_pcie_axi_ctl_bvalid : in STD_LOGIC;
		m_pcie_axi_ctl_bready : out STD_LOGIC;
		m_pcie_axi_ctl_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
		m_pcie_axi_ctl_arvalid : out STD_LOGIC;
		m_pcie_axi_ctl_arready : in STD_LOGIC;
		m_pcie_axi_ctl_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
		m_pcie_axi_ctl_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
		m_pcie_axi_ctl_rvalid : in STD_LOGIC;
		m_pcie_axi_ctl_rready : out STD_LOGIC;
	
		msi_request : out std_logic
		);
end pcie_dma_controller2;

architecture pcie_dma_controller2_behavioral of pcie_dma_controller2 is
	
	ATTRIBUTE X_INTERFACE_PARAMETER : STRING;
	ATTRIBUTE X_INTERFACE_INFO : STRING;
	
	attribute X_INTERFACE_PARAMETER of clkb : signal is "MODE Master";--, MASTER_TYPE BRAM_CTRL, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, READ_WRITE_MODE READ_WRITE, READ_LATENCY 1";
	ATTRIBUTE X_INTERFACE_INFO of clkb : SIGNAL is "xilinx.com:interface:bram_rtl:1.0 BRAM_REGISTERS CLK";
	ATTRIBUTE X_INTERFACE_INFO of addrb : SIGNAL is "xilinx.com:interface:bram_rtl:1.0 BRAM_REGISTERS ADDR";
	ATTRIBUTE X_INTERFACE_INFO of dinb : SIGNAL is "xilinx.com:interface:bram_rtl:1.0 BRAM_REGISTERS DIN";
	ATTRIBUTE X_INTERFACE_INFO of doutb : SIGNAL is "xilinx.com:interface:bram_rtl:1.0 BRAM_REGISTERS DOUT";
	ATTRIBUTE X_INTERFACE_INFO of enb : SIGNAL is "xilinx.com:interface:bram_rtl:1.0 BRAM_REGISTERS EN";
	ATTRIBUTE X_INTERFACE_INFO of rstb : SIGNAL is "xilinx.com:interface:bram_rtl:1.0 BRAM_REGISTERS RST";
	ATTRIBUTE X_INTERFACE_INFO of web : SIGNAL is "xilinx.com:interface:bram_rtl:1.0 BRAM_REGISTERS WE";
	
	constant REG_ID_LED : NATURAL := 0;
	constant REG_ID_DMA_SRC_ADDRESS_LO : NATURAL := 1;
	constant REG_ID_DMA_SRC_ADDRESS_HI : NATURAL := 2;
	constant REG_ID_DMA_DST_ADDRESS_LO : NATURAL := 3;
	constant REG_ID_DMA_DST_ADDRESS_HI : NATURAL := 4;
	constant REG_ID_DMA_DIRECTION : NATURAL := 5;
	constant REG_ID_DMA_LENGTH : NATURAL := 6;
	constant REG_ID_DMA_STATUS : NATURAL := 7;
		
	type state_t is ( state_read_0, state_read_0_data, state_writeback_0 );
	signal state : state_t;
	signal state_next : state_t;
	
	type dma_state_t is ( dma_state_ready,
		dma_state_prepare,
	
		dma_state_data_burst,
		dma_state_complete,
	
		dma_state_prepare_debug,
		dma_state_debug);
	
	signal dma_state : dma_state_t;
	signal dma_state_next : dma_state_t;
	
	
	signal leds_reg : std_logic_vector(7 downto 0);
	signal leds_reg_next : std_logic_vector(7 downto 0);
	
	function RegisterFromVector(data : std_logic_vector; register_id : NATURAL) return std_logic_vector is
		 variable result : std_logic_vector(31 downto 0);
	begin
		result := data(32 * register_id + 31 downto 32 * register_id);
		return result;
	end function;
	procedure SetWritebackVector(
		signal data : out std_logic_vector;
		signal enable : out std_logic_vector;
		register_id : NATURAL;
		value : std_logic_vector) is
	begin
		enable(register_id) <= '1';
		data(32 * register_id + 31 downto 32 * register_id) <= value;
	end procedure;
	function WritebackEnableToVector(enable : std_logic_vector) return std_logic_vector is
		variable result : std_logic_vector(63 downto 0);
	begin
		for i in 0 to 15 loop
			if enable(i) = '1' then
				result(i * 4 + 3 downto i * 4) := x"F";
			else
				result(i * 4 + 3 downto i * 4) := x"0";
			end if;
		end loop;
		return result;
	end function;
		
	constant PCIE_CTL_REG_ADDR_AXIBAR2PCIEBAR_0U : std_logic_vector(31 downto 0) := x"00000208";
	constant PCIE_CTL_REG_ADDR_AXIBAR2PCIEBAR_0L : std_logic_vector(31 downto 0) := x"0000020C";
	constant PCIE_CTL_REG_ADDR_AXIBAR2PCIEBAR_1U : std_logic_vector(31 downto 0) := x"00000210";
	constant PCIE_CTL_REG_ADDR_AXIBAR2PCIEBAR_1L : std_logic_vector(31 downto 0) := x"00000214";
	
	type dma_direction_t is (dma_direction_mem2dev, dma_direction_dev2mem);
	
	signal pcie_ctl_port_m : axi_lite_port_m_t;
	signal pcie_ctl_port_s : axi_lite_port_s_t;
	signal pcie_port_m : axi4_port_m_t;
	signal pcie_port_s : axi4_port_s_t;
	signal data_mem_port_m : axi4_port_m_t;
	signal data_mem_port_s : axi4_port_s_t;
	
	signal port_direction : dma_direction_t;
	signal port_direction_next : dma_direction_t;
	signal src_port_m : axi4_port_m_t;
	signal src_port_s : axi4_port_s_t;
	signal dst_port_m : axi4_port_m_t;
	signal dst_port_s : axi4_port_s_t;
	
	signal total_burst_len : unsigned(31 downto 0); -- this is burst length - 1, 255 is 256
	signal total_burst_len_next : unsigned(31 downto 0);
	signal current_burst_len : UNSIGNED(7 downto 0);
	signal current_burst_len_next : UNSIGNED(7 downto 0);
	signal current_src_addr : UNSIGNED(31 downto 0);
	signal current_src_addr_next : UNSIGNED(31 downto 0);
	signal current_dst_addr : UNSIGNED(31 downto 0);
	signal current_dst_addr_next : UNSIGNED(31 downto 0);
	signal current_burst_src_addr_start : UNSIGNED(31 downto 0);
	signal current_burst_src_addr_start_next : UNSIGNED(31 downto 0);
	signal current_burst_dst_addr_start : UNSIGNED(31 downto 0);
	signal current_burst_dst_addr_start_next : UNSIGNED(31 downto 0);
	signal current_burst_len_start : UNSIGNED(7 downto 0);
	signal current_burst_len_start_next : UNSIGNED(7 downto 0);
	signal current_burst_total_len_start : UNSIGNED(31 downto 0);
	signal current_burst_total_len_start_next : UNSIGNED(31 downto 0);
	
	signal data_buffer : std_logic_vector(127 downto 0);
	signal data_buffer_next : std_logic_vector(127 downto 0);
	signal read_resp : std_logic_vector(1 downto 0);
	signal read_resp_next : std_logic_vector(1 downto 0);
		
	signal dma_param_src_addr : std_logic_vector(63 downto 0);
	signal dma_param_src_addr_next : std_logic_vector(63 downto 0);
	signal dma_param_dst_addr : std_logic_vector(63 downto 0);
	signal dma_param_dst_addr_next : std_logic_vector(63 downto 0);
	signal dma_param_direction : dma_direction_t;
	signal dma_param_direction_next : dma_direction_t;
	signal dma_param_length : std_logic_vector(31 downto 0);
	signal dma_param_length_next : std_logic_vector(31 downto 0);
	signal dma_requested : std_logic;
		
	signal read_address_ok : BOOLEAN;
	signal read_address_ok_next : BOOLEAN;
	signal read_data_ok : BOOLEAN;
	signal read_data_ok_next : BOOLEAN;
	signal write_address_ok : BOOLEAN;
	signal write_address_ok_next : BOOLEAN;
	signal write_data_ok : BOOLEAN;
	signal write_data_ok_next : BOOLEAN;
	
	signal register_writeback_0_ready : std_logic;
	signal register_writeback_0_valid : std_logic;
	signal dma_register_writeback : std_logic_vector(511 downto 0);
	signal dma_register_writeback_enable : std_logic_vector(15 downto 0);
		
	signal dma_debug_counter : UNSIGNED(31 downto 0);
	signal dma_debug_counter_next : UNSIGNED(31 downto 0);
	
	signal dma_debug_counter2 : UNSIGNED(31 downto 0);
	signal dma_debug_counter2_next : UNSIGNED(31 downto 0);
begin
	clkb <= clk;
	rstb <= resetn;
	leds <= leds_reg;
		
	m_mem_axi_awid <= data_mem_port_m.awid;
	m_mem_axi_awaddr <= data_mem_port_m.awaddr;
	m_mem_axi_awregion <= data_mem_port_m.awregion; 
	m_mem_axi_awlen <= data_mem_port_m.awlen;
	m_mem_axi_awsize <= data_mem_port_m.awsize;
	m_mem_axi_awburst <= data_mem_port_m.awburst;
	m_mem_axi_awvalid <= data_mem_port_m.awvalid;
	data_mem_port_s.awready <= m_mem_axi_awready;
	m_mem_axi_wdata <= data_mem_port_m.wdata;
	m_mem_axi_wstrb <= data_mem_port_m.wstrb;
	m_mem_axi_wlast <= data_mem_port_m.wlast;
	m_mem_axi_wvalid <= data_mem_port_m.wvalid;
	data_mem_port_s.wready <= m_mem_axi_wready;
	data_mem_port_s.bid <= m_mem_axi_bid;
	data_mem_port_s.bresp <= m_mem_axi_bresp;
	data_mem_port_s.bvalid <= m_mem_axi_bvalid;
	m_mem_axi_bready <= data_mem_port_m.bready;
	m_mem_axi_arid <= data_mem_port_m.arid;
	m_mem_axi_araddr <= data_mem_port_m.araddr;
	m_mem_axi_arregion <= data_mem_port_m.arregion;
	m_mem_axi_arlen <= data_mem_port_m.arlen;
	m_mem_axi_arsize <= data_mem_port_m.arsize;
	m_mem_axi_arburst <= data_mem_port_m.arburst;
	m_mem_axi_arvalid <= data_mem_port_m.arvalid;
	data_mem_port_s.arready <= m_mem_axi_arready;
	data_mem_port_s.rid <= m_mem_axi_rid;
	data_mem_port_s.rdata <= m_mem_axi_rdata;
	data_mem_port_s.rresp <= m_mem_axi_rresp;
	data_mem_port_s.rlast <= m_mem_axi_rlast;
	data_mem_port_s.rvalid <= m_mem_axi_rvalid;
	m_mem_axi_rready <= data_mem_port_m.rready;
		
	m_pcie_axi_awid <= pcie_port_m.awid;
	m_pcie_axi_awaddr <= pcie_port_m.awaddr;
	m_pcie_axi_awregion <= pcie_port_m.awregion;
	m_pcie_axi_awlen <= pcie_port_m.awlen;
	m_pcie_axi_awsize <= pcie_port_m.awsize;
	m_pcie_axi_awburst <= pcie_port_m.awburst;
	m_pcie_axi_awvalid <= pcie_port_m.awvalid;
	pcie_port_s.awready <= m_pcie_axi_awready;
	m_pcie_axi_wdata <= pcie_port_m.wdata;
	m_pcie_axi_wstrb <= pcie_port_m.wstrb;
	m_pcie_axi_wlast <= pcie_port_m.wlast;
	m_pcie_axi_wvalid <= pcie_port_m.wvalid;
	pcie_port_s.wready <= m_pcie_axi_wready;
	pcie_port_s.bid <= m_pcie_axi_bid;
	pcie_port_s.bresp <= m_pcie_axi_bresp;
	pcie_port_s.bvalid <= m_pcie_axi_bvalid;
	m_pcie_axi_bready <= pcie_port_m.bready;
	m_pcie_axi_arid <= pcie_port_m.arid;
	m_pcie_axi_araddr <= pcie_port_m.araddr;
	m_pcie_axi_arregion <= pcie_port_m.arregion;
	m_pcie_axi_arlen <= pcie_port_m.arlen;
	m_pcie_axi_arsize <= pcie_port_m.arsize;
	m_pcie_axi_arburst <= pcie_port_m.arburst;
	m_pcie_axi_arvalid <= pcie_port_m.arvalid;
	pcie_port_s.arready <= m_pcie_axi_arready;
	pcie_port_s.rid <= m_pcie_axi_rid;
	pcie_port_s.rdata <= m_pcie_axi_rdata;
	pcie_port_s.rresp <= m_pcie_axi_rresp;
	pcie_port_s.rlast <= m_pcie_axi_rlast;
	pcie_port_s.rvalid <= m_pcie_axi_rvalid;
	m_pcie_axi_rready <= pcie_port_m.rready;
	
	m_pcie_axi_ctl_awaddr <= pcie_ctl_port_m.awaddr;
	m_pcie_axi_ctl_awvalid <= pcie_ctl_port_m.awvalid;
	pcie_ctl_port_s.awready <= m_pcie_axi_ctl_awready;
	m_pcie_axi_ctl_wdata <= pcie_ctl_port_m.wdata;
	m_pcie_axi_ctl_wstrb <= pcie_ctl_port_m.wstrb;
	m_pcie_axi_ctl_wvalid <= pcie_ctl_port_m.wvalid;
	pcie_ctl_port_s.wready <= m_pcie_axi_ctl_wready;
	pcie_ctl_port_s.bresp <= m_pcie_axi_ctl_bresp;
	pcie_ctl_port_s.bvalid <= m_pcie_axi_ctl_bvalid;
	m_pcie_axi_ctl_bready <= pcie_ctl_port_m.bready;
	m_pcie_axi_ctl_araddr <= pcie_ctl_port_m.araddr;
	m_pcie_axi_ctl_arvalid <= pcie_ctl_port_m.arvalid;
	pcie_ctl_port_s.arready <= m_pcie_axi_ctl_arready;
	pcie_ctl_port_s.rdata <= m_pcie_axi_ctl_rdata;
	pcie_ctl_port_s.rresp <= m_pcie_axi_ctl_rresp;
	pcie_ctl_port_s.rvalid <= m_pcie_axi_ctl_rvalid;
	m_pcie_axi_ctl_rready <= pcie_ctl_port_m.rready;
	
	data_mem_port_m <= src_port_m when (port_direction = dma_direction_dev2mem) else dst_port_m;
	pcie_port_m <= dst_port_m when (port_direction = dma_direction_dev2mem) else src_port_m;
	src_port_s <= data_mem_port_s when (port_direction = dma_direction_dev2mem) else pcie_port_s;
	dst_port_s <= pcie_port_s when (port_direction = dma_direction_dev2mem) else data_mem_port_s;
	
	process (clk) is
	begin
		if rising_edge(clk) then
			state <= state_next;
			
			leds_reg <= leds_reg_next;
			
			dma_param_src_addr <= dma_param_src_addr_next;
			dma_param_dst_addr <= dma_param_dst_addr_next;
			dma_param_direction <= dma_param_direction_next;
			dma_param_length <= dma_param_length_next;
			
			
			dma_state <= dma_state_next;
				
			total_burst_len <= total_burst_len_next;
			current_burst_len <= current_burst_len_next;
		
			data_buffer <= data_buffer_next;
			read_resp <= read_resp_next;
			current_src_addr <= current_src_addr_next;
			current_dst_addr <= current_dst_addr_next;
			
			current_burst_len_start <= current_burst_len_start_next;
			current_burst_total_len_start <= current_burst_total_len_start_next;
			current_burst_src_addr_start <= current_burst_src_addr_start_next;
			current_burst_dst_addr_start <= current_burst_dst_addr_start_next;
			
			port_direction <= port_direction_next;
			
			read_address_ok <= read_address_ok_next;
			read_data_ok <= read_data_ok_next;
			write_address_ok <= write_address_ok_next;
			write_data_ok <= write_data_ok_next;
			
			dma_debug_counter <= dma_debug_counter_next;
		end if;
	end process;

	process (state, resetn, doutb, dma_state, register_writeback_0_valid, total_burst_len) is
		variable vtmp : std_logic_vector(31 downto 0);
	begin
		
		addrb <= x"00000000";
		dinb <= (others => '0');
		enb <= '0';
		web <= (others => '0');
		
		leds_reg_next <= leds_reg;
		state_next <= state;
		
		dma_param_src_addr_next <= dma_param_src_addr;
		dma_param_dst_addr_next <= dma_param_dst_addr;
		dma_param_direction_next <= dma_param_direction;
		dma_param_length_next <= dma_param_length;
		dma_requested <= '0';
		register_writeback_0_ready <= '0';
		
		if resetn = '0' then
			state_next <= state_read_0;
			leds_reg_next <= x"00";
			
			dma_param_src_addr_next <= (others => '0');
			dma_param_dst_addr_next <= (others => '0');
			dma_param_direction_next <= dma_direction_dev2mem;
			dma_param_length_next <= (others => '0');
			dma_requested <= '0';
		else
			case (state) is
				when state_read_0 =>
					addrb <= x"00000000";
					enb <= '1';
					state_next <= state_read_0_data;
				when state_read_0_data =>
					enb <= '1';
					leds_reg_next <= RegisterFromVector(doutb, REG_ID_DMA_LENGTH)(7 downto 0);
						
					-- read the dma parameters, must wait that DMA is ready not to corrupt data
					if dma_state = dma_state_ready then
						dma_param_src_addr_next <= RegisterFromVector(doutb, REG_ID_DMA_SRC_ADDRESS_HI) & RegisterFromVector(doutb, REG_ID_DMA_SRC_ADDRESS_LO);
						dma_param_dst_addr_next <= RegisterFromVector(doutb, REG_ID_DMA_DST_ADDRESS_HI) & RegisterFromVector(doutb, REG_ID_DMA_DST_ADDRESS_LO);
						vtmp := RegisterFromVector(doutb, REG_ID_DMA_DIRECTION);
						if vtmp = x"00000000" then
							dma_param_direction_next <= dma_direction_dev2mem;
						else
							dma_param_direction_next <= dma_direction_mem2dev;
						end if;
						dma_param_length_next <= RegisterFromVector(doutb, REG_ID_DMA_LENGTH);
				
						-- do not trigger DMA if length is 0
						if RegisterFromVector(doutb, REG_ID_DMA_LENGTH) /= x"00000000" then
							dma_requested <= '1'; -- just 1 cycle
						end if;
					end if;
				
					state_next <= state_writeback_0;
				when state_writeback_0 =>
					register_writeback_0_ready <= '1';
					if register_writeback_0_valid = '1' then
						addrb <= x"00000000";
						enb <= '1';
						web <= WritebackEnableToVector(dma_register_writeback_enable);
						dinb <= dma_register_writeback;
					end if;
					state_next <= state_read_0;
				when others =>
			end case;
		end if;
	end process;
	
	-- dont use all because IP integrator doesnt support VHDL 2008
	process (resetn,
		dma_state,
		src_port_s,
		dst_port_s,
		pcie_ctl_port_s,
		total_burst_len,
		total_burst_len_next,
		current_burst_len,
		current_burst_len_next,
		data_buffer,
		data_buffer_next,
		read_resp,
		read_resp_next,
		current_src_addr,
		current_src_addr_next,
		current_dst_addr,
		current_dst_addr_next,
		dma_param_dst_addr,
		dma_param_dst_addr_next,
		dma_param_direction,
		dma_param_direction_next,
		dma_param_src_addr,
		dma_param_src_addr_next,
		dma_param_length,
		dma_param_length_next,
		dma_requested,
		read_address_ok,
		read_address_ok_next,
		read_data_ok,
		read_data_ok_next,
		write_address_ok,
		write_address_ok_next,
		write_data_ok,
		write_data_ok_next,
		register_writeback_0_ready,
		current_burst_len_start,
		current_burst_len_start_next,
		current_burst_total_len_start,
		current_burst_total_len_start_next,
		current_burst_src_addr_start,
		current_burst_src_addr_start_next,
		current_burst_dst_addr_start,
		current_burst_dst_addr_start_next
		) is
		variable vctl_data : std_logic_vector(31 downto 0);
		variable vburst_len : UNSIGNED(7 downto 0);
		variable vburst_last : std_logic;
		variable vread_addr_handshake : BOOLEAN;
		variable vread_data_handshake : BOOLEAN;
		variable vwrite_addr_handshake : BOOLEAN;
		variable vwrite_data_handshake : BOOLEAN;
		variable vwrite_result : AXI_write_result_t;
	begin
		register_writeback_0_valid <= '0';
		msi_request <= '0';
		dma_register_writeback_enable <= (others => '0');
		dma_register_writeback <= (others => '0');
		
		if resetn = '0' then
			dma_state_next <= dma_state_ready;
					
			AXI4_idle(src_port_m);
			AXI4_idle(dst_port_m);
		
			AXI_LITE_idle(pcie_ctl_port_m);
				
			total_burst_len_next <= x"00000000";
			current_burst_len_next <= x"00";
		
			data_buffer_next <= (others => '0');
			read_resp_next <= "00";
			current_src_addr_next <= x"00000000";
			current_dst_addr_next <= x"00000000";
			
			current_burst_len_start_next <= (others => '0');
			current_burst_total_len_start_next <= (others => '0');
			current_burst_src_addr_start_next <= (others => '0');
			current_burst_dst_addr_start_next <= (others => '0');
			
			port_direction_next <= dma_direction_mem2dev;
	
			read_address_ok_next <= FALSE;
			read_data_ok_next <= FALSE;
			write_address_ok_next <= FALSE;
			write_data_ok_next <= FALSE;
			
			dma_debug_counter_next <= x"00000000";
		else
			dma_state_next <= dma_state;
					
			AXI4_idle(src_port_m);
			AXI4_idle(dst_port_m);
		
			AXI_LITE_idle(pcie_ctl_port_m);
				
			total_burst_len_next <= total_burst_len;
			current_burst_len_next <= current_burst_len;
		
			data_buffer_next <= data_buffer;
			read_resp_next <= read_resp;
			current_src_addr_next <= current_src_addr;
			current_dst_addr_next <= current_dst_addr;
						
			read_address_ok_next <= read_address_ok;
			read_data_ok_next <= read_data_ok;
			write_address_ok_next <= write_address_ok;
			write_data_ok_next <= write_data_ok;
			
			current_burst_len_start_next <= current_burst_len_start;
			current_burst_total_len_start_next <= current_burst_total_len_start;
			current_burst_src_addr_start_next <= current_burst_src_addr_start;
			current_burst_dst_addr_start_next <= current_burst_dst_addr_start;
			
			port_direction_next <= port_direction;
			
			vread_addr_handshake := FALSE;
			vread_data_handshake := FALSE;
			vwrite_addr_handshake := FALSE;
			vwrite_data_handshake := FALSE;
			vwrite_result := AXI_write_result_pending;
			
			dma_debug_counter_next <= dma_debug_counter;
			
			case (dma_state) is
				when dma_state_ready =>
		
					if dma_requested = '1' then
						-- length must be a multiple of 16
						-- need to be really carefull in the driver for that
						-- eg. if length is 15, (total_burst_len_next - 1) == 0xFFFFFFFF
						total_burst_len_next <= ("0000" & unsigned(dma_param_length_next(31 downto 4))) - 1;
						current_src_addr_next <= unsigned(dma_param_src_addr_next(31 downto 0));
						current_dst_addr_next <= unsigned(dma_param_dst_addr_next(31 downto 0));
										
						if total_burst_len_next > 255 then
							current_burst_len_next <= x"FF";
						else
							current_burst_len_next <= total_burst_len_next(7 downto 0);
						end if;
										
						current_burst_len_start_next <= current_burst_len_next;
						current_burst_total_len_start_next <= total_burst_len_next;
						current_burst_src_addr_start_next <= (others => '0');
						current_burst_src_addr_start_next(31 downto 7) <= current_src_addr_next(31 downto 7);
						current_burst_dst_addr_start_next <= (others => '0');
						current_burst_dst_addr_start_next(31 downto 7) <= current_dst_addr_next(31 downto 7);
										
						port_direction_next <= dma_param_direction;
										
						dma_state_next <= dma_state_prepare;
						--dma_debug_counter_next <= TO_UNSIGNED(250000000, 32);
						--dma_state_next <= dma_state_prepare_debug;
					end if;
				when dma_state_prepare_debug =>
					SetWritebackVector(dma_register_writeback, dma_register_writeback_enable, REG_ID_DMA_STATUS, x"00000001");
					register_writeback_0_valid <= '1';
					if register_writeback_0_ready = '1' then
						dma_state_next <= dma_state_debug;
					end if;
			
				-- write hi address in PCIE CTL register
				-- burst cannot cross 32bit boundary
				when dma_state_prepare =>
					if dma_param_direction = dma_direction_dev2mem then
						vctl_data := dma_param_dst_addr(63 downto 32);
					else
						vctl_data := dma_param_src_addr(63 downto 32);
					end if;
								
					if not write_address_ok then
						AXI_LITE_write_addr(pcie_ctl_port_m, pcie_ctl_port_s, PCIE_CTL_REG_ADDR_AXIBAR2PCIEBAR_0U, vwrite_addr_handshake);
						write_address_ok_next <= vwrite_addr_handshake;
					end if;
					if not write_data_ok then
						AXI_LITE_write_data(pcie_ctl_port_m, pcie_ctl_port_s, vctl_data, "1111", vwrite_data_handshake);
						write_data_ok_next <= vwrite_data_handshake;
					end if;
					
					if vwrite_data_handshake or write_data_ok then
						AXI_LITE_write_errcheck(pcie_ctl_port_m, pcie_ctl_port_s, vwrite_result);
						if vwrite_result = AXI_write_result_OK then
							write_address_ok_next <= FALSE;
							write_data_ok_next <= FALSE;
					
							dma_state_next <= dma_state_data_burst;
						elsif vwrite_result = AXI_write_result_ERR then
							write_address_ok_next <= FALSE;
							write_data_ok_next <= FALSE;
						end if;
					end if;
		
				when dma_state_data_burst =>		
					if total_burst_len > 255 then
						vburst_len := x"FF";
					else
						vburst_len := total_burst_len(7 downto 0);
					end if;
					if current_burst_len = x"00" then
						vburst_last := '1';
					else
						vburst_last := '0';
					end if;
			
					if not read_address_ok then
						AXI4_read_addr(src_port_m, src_port_s, std_logic_vector(current_src_addr), AXI4_BURST_INCR, AXI4_BURST_SIZE_16, std_logic_vector(vburst_len), vread_addr_handshake);
						read_address_ok_next <= vread_addr_handshake;
					end if;
					if not write_address_ok then
						AXI4_write_addr(dst_port_m, dst_port_s, std_logic_vector(current_dst_addr), AXI4_BURST_INCR, AXI4_BURST_SIZE_16, std_logic_vector(vburst_len), vwrite_addr_handshake);
						write_address_ok_next <= vwrite_addr_handshake;
					end if;
					if read_address_ok and not read_data_ok then
						AXI4_read_data(src_port_m, src_port_s, data_buffer_next, read_resp_next, vread_data_handshake);
						read_data_ok_next <= vread_data_handshake;
					end if;
					if (read_data_ok or vread_data_handshake) and not write_data_ok then
						AXI4_write_data(dst_port_m, dst_port_s, data_buffer_next, x"FFFF", vburst_last, vwrite_data_handshake);
						write_data_ok_next <= vwrite_data_handshake;
					end if;
			
					if write_data_ok or vwrite_data_handshake then
						if vburst_last = '1' then
							AXI4_write_errcheck(dst_port_m, dst_port_s, vwrite_result);
						else
							-- update current burst
							current_burst_len_next <= current_burst_len - 1;
							total_burst_len_next <= total_burst_len - 1;
							current_src_addr_next(31 downto 7) <= current_src_addr(31 downto 7) + 1;
							current_dst_addr_next(31 downto 7) <= current_dst_addr(31 downto 7) + 1;
					
							read_data_ok_next <= FALSE;
							write_data_ok_next <= FALSE;
						end if;
					end if;
			
					-- handle resp
					if vwrite_result /= AXI_write_result_pending then
				
						current_burst_len_next <= current_burst_len - 1;
						total_burst_len_next <= total_burst_len - 1;
						current_src_addr_next(31 downto 7) <= current_src_addr(31 downto 7) + 1;
						current_dst_addr_next(31 downto 7) <= current_dst_addr(31 downto 7) + 1;
				
						read_address_ok_next <= FALSE;
						read_data_ok_next <= FALSE;
						write_address_ok_next <= FALSE;
						write_data_ok_next <= FALSE;
				
						if read_resp = AXI_RESP_DECERR or read_resp = AXI_RESP_SLVERR or vwrite_result = AXI_write_result_ERR then
							-- error, re-read/write current burst
							current_burst_len_next <= current_burst_len_start;
							total_burst_len_next <= current_burst_total_len_start;
							
							current_src_addr_next(31 downto 7) <= current_burst_src_addr_start(31 downto 7);
							current_dst_addr_next(31 downto 7) <= current_burst_dst_addr_start(31 downto 7);
						else
							-- total finished, back to ready
							if total_burst_len = x"00000000" then
								total_burst_len_next <= x"00000000"; -- else gonna rollback
								dma_state_next <= dma_state_complete;
							else
								if total_burst_len > 255 then
									current_burst_len_start_next <= x"FF";
								else
									current_burst_len_start_next <= total_burst_len(7 downto 0) - 1;
								end if;
								current_burst_len_next <= current_burst_len_start_next;
								current_burst_total_len_start_next <= total_burst_len_next;
								current_burst_src_addr_start_next(31 downto 7) <= current_src_addr_next(31 downto 7);
								current_burst_dst_addr_start_next(31 downto 7) <= current_dst_addr_next(31 downto 7);
							end if;
						end if;
					end if;
		
				when dma_state_complete =>
					SetWritebackVector(dma_register_writeback, dma_register_writeback_enable, REG_ID_DMA_LENGTH, x"00000000");
					SetWritebackVector(dma_register_writeback, dma_register_writeback_enable, REG_ID_DMA_STATUS, x"00000000");
					register_writeback_0_valid <= '1';
					if register_writeback_0_ready = '1' then
						msi_request <= '1'; -- !!! the clock need to be synchronous with axi clk from the PCIE IP
						dma_state_next <= dma_state_ready;
					end if;
			
				when dma_state_debug =>
					if dma_debug_counter = x"00000000" then
						total_burst_len_next <= (others => '0');
						dma_state_next <= dma_state_complete;
					else
						dma_debug_counter_next <= dma_debug_counter - 1;
					end if;
				when others =>
					dma_state_next <= dma_state_ready;
			end case;
		end if;
	end process;
	
end pcie_dma_controller2_behavioral;
