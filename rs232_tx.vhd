library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rs232_tx is 
	generic(
		SYSTEM_SPEED : integer := 50e6;
		BAUDRATE		 : integer := 9600);
	port(
		clk_i		: in std_logic;
		rst_i		: in std_logic;
		req_i		: in std_logic;
		ack_o		: out std_logic;
		tx			: out std_logic);
end rs232_tx;

architecture behave of rs232_tx is 
	constant MAX_COUNTER : integer := (SYSTEM_SPEED / BAUDRATE);
	type state_type is (
		WAIT_FOR_REQ,
		SEND_START_BIT,
		SEND_BITS,
		SEND_STOP_BIT);
	signal	data_i 	: std_logic_vector(17 downto 0) := "010010110101001111";--01001111 O -- 01001011 K
	signal	state : state_type := WAIT_FOR_REQ;
	signal   baudrate_counter : integer range 0 to MAX_COUNTER := 0;
	signal   bit_counter : integer range 0 to 17 := 0;
	signal   shift_reg : std_logic_vector(17 downto 0) := (others => '0');
	signal   data_sending_started : std_logic := '0';
	
	begin
		ack_o <= data_sending_started and (not req_i);
		
	update : process(clk_i)
		begin
		if rising_edge(clk_i)then
			
			if rst_i = '0' then
				tx <= '1';
				data_sending_started <= '0';
				state <= WAIT_FOR_REQ;
			else
			case state is
				when WAIT_FOR_REQ =>
					if req_i = '1' then
						state <= SEND_START_BIT;
						baudrate_counter <= MAX_COUNTER - 1;
						tx <= '0';
						shift_reg <= data_i;
						data_sending_started <= '1';
					else
						tx <= '1';
					end if;
				when SEND_START_BIT =>
					if baudrate_counter = 0 then 
						state <= SEND_BITS;
						baudrate_counter <= MAX_COUNTER - 1;
						tx <= shift_reg(0);
						bit_counter <= 17;
					else
						baudrate_counter <= baudrate_counter - 1;
					end if;
				when SEND_BITS =>
					if baudrate_counter = 0 then 
						if bit_counter = 0 then 
							state <= SEND_STOP_BIT;
							tx <= '1';
						else 
							tx <= shift_reg(1);
							shift_reg <= '0' & shift_reg(17 downto 1);
							bit_counter <= bit_counter - 1;
						end if;
						baudrate_counter <= MAX_COUNTER - 1;
					else
						baudrate_counter <= baudrate_counter - 1;
					end if;
				when SEND_STOP_BIT =>
					if baudrate_counter = 0 then
						state <= WAIT_FOR_REQ;
					else
						baudrate_counter <= baudrate_counter - 1;
					end if;
				end case;
				
		if req_i = '0' and data_sending_started = '1' then 
			data_sending_started <= '0';
		end if;
	end if;
	end if;
end process;
end behave;

			
	
	