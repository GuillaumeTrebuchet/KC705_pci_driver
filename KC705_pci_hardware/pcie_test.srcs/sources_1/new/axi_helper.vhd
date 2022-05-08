
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package axi_helper is
	type axi_lite_port_m_t is record
		awaddr : STD_LOGIC_VECTOR(31 DOWNTO 0);
		awvalid : STD_LOGIC;
		wdata : STD_LOGIC_VECTOR(31 DOWNTO 0);
		wstrb : STD_LOGIC_VECTOR(3 DOWNTO 0);
		wvalid : STD_LOGIC;
		bready : STD_LOGIC;
		araddr : STD_LOGIC_VECTOR(31 DOWNTO 0);
		arvalid : STD_LOGIC;
		rready : STD_LOGIC;
	end record;
	type axi_lite_port_s_t is record
		awready : STD_LOGIC;
		wready : STD_LOGIC;
		bresp : STD_LOGIC_VECTOR(1 DOWNTO 0);
		bvalid : STD_LOGIC;
		arready : STD_LOGIC;
		rdata : STD_LOGIC_VECTOR(31 DOWNTO 0);
		rresp : STD_LOGIC_VECTOR(1 DOWNTO 0);
		rvalid : STD_LOGIC;
	end record;
	type axi4_port_m_t is record
		awid :  STD_LOGIC_VECTOR ( 3 downto 0 );
		awaddr :  STD_LOGIC_VECTOR ( 31 downto 0 );
		awregion :  STD_LOGIC_VECTOR ( 3 downto 0 );
		awlen :  STD_LOGIC_VECTOR ( 7 downto 0 );
		awsize :  STD_LOGIC_VECTOR ( 2 downto 0 );
		awburst :  STD_LOGIC_VECTOR ( 1 downto 0 );
		awvalid :  STD_LOGIC;
		wdata :  STD_LOGIC_VECTOR ( 127 downto 0 );
		wstrb :  STD_LOGIC_VECTOR ( 15 downto 0 );
		wlast :  STD_LOGIC;
		wvalid :  STD_LOGIC;
		bready :  STD_LOGIC;
		arid :  STD_LOGIC_VECTOR ( 3 downto 0 );
		araddr :  STD_LOGIC_VECTOR ( 31 downto 0 );
		arregion :  STD_LOGIC_VECTOR ( 3 downto 0 );
		arlen :  STD_LOGIC_VECTOR ( 7 downto 0 );
		arsize :  STD_LOGIC_VECTOR ( 2 downto 0 );
		arburst :  STD_LOGIC_VECTOR ( 1 downto 0 );
		arvalid :  STD_LOGIC;
		rready :  STD_LOGIC;
	end record;
	type axi4_port_s_t is record
		awready :  STD_LOGIC;
		wready :  STD_LOGIC;
		bid :  STD_LOGIC_VECTOR ( 3 downto 0 );
		bresp :  STD_LOGIC_VECTOR ( 1 downto 0 );
		bvalid :  STD_LOGIC;
		arready :  STD_LOGIC;
		rid :  STD_LOGIC_VECTOR ( 3 downto 0 );
		rdata :  STD_LOGIC_VECTOR ( 127 downto 0 );
		rresp :  STD_LOGIC_VECTOR ( 1 downto 0 );
		rlast :  STD_LOGIC;
		rvalid :  STD_LOGIC;
	end record;
	
	constant AXI_RESP_OKAY : std_logic_vector(1 downto 0) := "00";
	constant AXI_RESP_EXOKAY : std_logic_vector(1 downto 0) := "01";
	constant AXI_RESP_SLVERR : std_logic_vector(1 downto 0) := "10";
	constant AXI_RESP_DECERR : std_logic_vector(1 downto 0) := "11";
	
	type AXI_write_result_t is (AXI_write_result_pending, AXI_write_result_OK, AXI_write_result_ERR);
	
	-- AXI LITE
	procedure AXI_LITE_idle(signal pm : out axi_lite_port_m_t);
	procedure AXI_LITE_write_addr(
		signal pm : out axi_lite_port_m_t;
		signal ps : in axi_lite_port_s_t;
		addr : std_logic_vector;
		variable handshake : out BOOLEAN);
	procedure AXI_LITE_write_data(
		signal pm : out axi_lite_port_m_t;
		signal ps : in axi_lite_port_s_t;
		data : std_logic_vector;
		strb : std_logic_vector;
		variable handshake : out BOOLEAN);
	procedure AXI_LITE_write_errcheck(
		signal pm : out axi_lite_port_m_t;
		signal ps : in axi_lite_port_s_t;
		variable result : out AXI_write_result_t);
	
	-- AXI4
	procedure AXI4_idle(signal p : out axi4_port_m_t);
	procedure AXI4_write_addr(
		signal pm : out axi4_port_m_t;
		signal ps : in axi4_port_s_t;
		addr : std_logic_vector;
		burst_type : std_logic_vector;
		burst_size : std_logic_vector;
		burst_len : std_logic_vector;
		variable result : out BOOLEAN);
	procedure AXI4_write_data(
		signal pm : out axi4_port_m_t;
		signal ps : in axi4_port_s_t;
		data : std_logic_vector;
		strb : std_logic_vector;
		last : std_logic;
		variable result : out BOOLEAN);
	procedure AXI4_read_addr(
		signal pm : out axi4_port_m_t;
		signal ps : in axi4_port_s_t;
		addr : std_logic_vector;
		burst_type : std_logic_vector;
		burst_size : std_logic_vector;
		burst_len : std_logic_vector;
		variable handshake : out BOOLEAN);
	procedure AXI4_read_data(
		signal pm : out axi4_port_m_t;
		signal ps : in axi4_port_s_t;
		signal data : out std_logic_vector;
		signal resp : out std_logic_vector;
		variable handshake : out BOOLEAN);
	procedure AXI4_write_errcheck(
		signal pm : out axi4_port_m_t;
		signal ps : in axi4_port_s_t;
		variable result : out AXI_write_result_t);

	constant AXI4_BURST_FIXED : std_logic_vector(1 downto 0) := "00";
	constant AXI4_BURST_INCR : std_logic_vector(1 downto 0) := "01";
	constant AXI4_BURST_WRAP : std_logic_vector(1 downto 0) := "10";
	
	constant AXI4_BURST_SIZE_1 : std_logic_vector(2 downto 0) := "000";
	constant AXI4_BURST_SIZE_2 : std_logic_vector(2 downto 0) := "001";
	constant AXI4_BURST_SIZE_4 : std_logic_vector(2 downto 0) := "010";
	constant AXI4_BURST_SIZE_8 : std_logic_vector(2 downto 0) := "011";
	constant AXI4_BURST_SIZE_16 : std_logic_vector(2 downto 0) := "100";
	constant AXI4_BURST_SIZE_32 : std_logic_vector(2 downto 0) := "101";
	constant AXI4_BURST_SIZE_64 : std_logic_vector(2 downto 0) := "110";
	constant AXI4_BURST_SIZE_128 : std_logic_vector(2 downto 0) := "111";
end axi_helper;

package body axi_helper is

	procedure AXI_LITE_idle(signal pm : out axi_lite_port_m_t) is
	begin
		pm.awaddr <= (others => '0');
		pm.awvalid <= '0';
		pm.wdata <= (others => '0');
		pm.wstrb <= (others => '0');
		pm.wvalid <= '0';
		pm.bready <= '0';
		pm.araddr <= (others => '0');
		pm.arvalid <= '0';
		pm.rready <= '0';
	end procedure;
	procedure AXI_LITE_write_addr(
		signal pm : out axi_lite_port_m_t;
		signal ps : in axi_lite_port_s_t;
		addr : std_logic_vector;
		variable handshake : out BOOLEAN) is
	begin
		pm.awaddr <= addr;
		pm.awvalid <= '1';
		if ps.awready = '1' then
			handshake := TRUE;
		else
			handshake := FALSE;
		end if;
	end procedure;
	
	procedure AXI_LITE_write_data(
		signal pm : out axi_lite_port_m_t;
		signal ps : in axi_lite_port_s_t;
		data : std_logic_vector;
		strb : std_logic_vector;
		variable handshake : out BOOLEAN) is
	begin
		pm.wdata <= data;
		pm.wstrb <= strb;
		pm.wvalid <= '1';
		if ps.wready = '1' then
			handshake := TRUE;
		else
			handshake := FALSE;
		end if;
	end procedure;
	procedure AXI_LITE_write_errcheck(
		signal pm : out axi_lite_port_m_t;
		signal ps : in axi_lite_port_s_t;
		variable result : out AXI_write_result_t) is
	begin
		pm.bready <= '1';
		if ps.bvalid = '1' then
			case (ps.bresp) is
				when AXI_RESP_OKAY =>
					result := AXI_write_result_OK;
				when AXI_RESP_EXOKAY =>
					result := AXI_write_result_OK;
				when AXI_RESP_SLVERR =>
					result := AXI_write_result_ERR;
				when AXI_RESP_DECERR =>
					result := AXI_write_result_ERR;
				when others =>
					result := AXI_write_result_ERR;
			end case;
		else
			result := AXI_write_result_pending;
		end if;
	end procedure;
	
	
	procedure AXI4_idle(signal p : out axi4_port_m_t) is
	begin
		p.awid <= (others => '0');
		p.awaddr <= (others => '0');
		p.awregion <= (others => '0');
		p.awlen <= (others => '0');
		p.awsize <= (others => '0');
		p.awburst <= (others => '0');
		p.awvalid <= '0';
		p.wdata <= (others => '0');
		p.wstrb <= (others => '0');
		p.wlast <= '0';
		p.wvalid <= '0';
		p.bready <= '0';
		p.arid <= (others => '0');
		p.araddr <= (others => '0');
		p.arregion <= (others => '0');
		p.arlen <= (others => '0');
		p.arsize <= (others => '0');
		p.arburst <= (others => '0');
		p.arvalid <= '0';
		p.rready <= '0';
	end procedure;
	procedure AXI4_write_addr( 
		signal pm : out axi4_port_m_t;
		signal ps : in axi4_port_s_t;
		addr : std_logic_vector;
		burst_type : std_logic_vector;
		burst_size : std_logic_vector;
		burst_len : std_logic_vector;
		variable result : out BOOLEAN) is
	begin
		pm.awburst <= burst_type;
		pm.awsize <= burst_size;
		pm.awlen <= burst_len;
		pm.awaddr <= addr;
		pm.awvalid <= '1';
		if ps.awready = '1' then
			result := TRUE;
		else
			result := FALSE;
		end if;
	end procedure;
	
	procedure AXI4_write_data(
		signal pm : out axi4_port_m_t;
		signal ps : in axi4_port_s_t;
		data : std_logic_vector;
		strb : std_logic_vector;
		last : std_logic;
		variable result : out BOOLEAN) is
	begin
		pm.wdata <= data;
		pm.wstrb <= strb;
		pm.wlast <= last;
		pm.wvalid <= '1';
		if ps.wready = '1' then
			result := TRUE;
		else
			result := FALSE;
		end if;
	end procedure;
	
	procedure AXI4_read_addr(
		signal pm : out axi4_port_m_t;
		signal ps : in axi4_port_s_t;
		addr : std_logic_vector;
		burst_type : std_logic_vector;
		burst_size : std_logic_vector;
		burst_len : std_logic_vector;
		variable handshake : out BOOLEAN) is
	begin
		pm.arburst <= burst_type;
		pm.arsize <= burst_size;
		pm.arlen <= burst_len;
		pm.araddr <= addr;
		pm.arvalid <= '1';
		if ps.arready = '1' then
			handshake := TRUE;
		else
			handshake := FALSE;
		end if;
	end procedure;
	
	procedure AXI4_read_data(
		signal pm : out axi4_port_m_t;
		signal ps : in axi4_port_s_t;
		signal data : out std_logic_vector;
		signal resp : out std_logic_vector;
		variable handshake : out BOOLEAN) is
	begin
		data <= ps.rdata;
		resp <= ps.rresp;
		pm.rready <= '1';
		if ps.rvalid = '1' then
			handshake := TRUE;
		else
			handshake := FALSE;
		end if;
	end procedure;
		
	procedure AXI4_write_errcheck(
		signal pm : out axi4_port_m_t;
		signal ps : in axi4_port_s_t;
		variable result : out AXI_write_result_t) is
	begin
		pm.bready <= '1';
		if ps.bvalid = '1' then
			case (ps.bresp) is
				when AXI_RESP_OKAY =>
					result := AXI_write_result_OK;
				when AXI_RESP_EXOKAY =>
					result := AXI_write_result_OK;
				when AXI_RESP_SLVERR =>
					result := AXI_write_result_ERR;
				when AXI_RESP_DECERR =>
					result := AXI_write_result_ERR;
				when others => 
					result := AXI_write_result_ERR;
			end case;
		else
			result := AXI_write_result_pending;
		end if;
	end procedure;
end axi_helper;
