library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;


entity doblar is

	port(
		clk,df,reset	: in	std_logic;
	   di,dd	 : in	std_logic_vector(11 downto 0);
		M1I,M0I,M1D,M0D:buffer std_LOGIC;
		velmi,velmd,Envio1,Envio0,ledcheckdf,ledcheckdi,ledcheckdd,ledcheckm0i,ledcheckm1i,ledcheckm0d,ledcheckm1d	 : out	std_logic
	);

end entity;

architecture rtl of doblar is
   component lpm_counter0 
	port (
		aclr		: IN STD_LOGIC ;
		clock		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
	end component;
	
	component pll 
	port ( 
		areset		: IN STD_LOGIC  := '0';
		inclk0		: IN STD_LOGIC  := '0';
		c0		: OUT STD_LOGIC
	);
	end component;
	
	-- Build an enumerated type for the state machine
	type state_type is (parado,der,izq,reversa);

	-- Register to hold the current state
	signal state   : state_type;
	signal dddig: unsigned(11 downto 0);
	signal didig: unsigned(11 downto 0);
	signal ddbool: std_logic;
	signal dibool: std_logic;
	signal reset1: std_logic;
	signal ic:std_logic;----iniciar contador doblar
	signal tc1:std_logic;----termina contador doblar 90
	signal tc2:std_logic;----termina contador doblar 180
	signal clc:std_logic;-------clear contador doblar
	signal cclk:std_logic;-------clock intermedio de 50khz
	signal cclkfin:std_logic;------------ and del contador reducido a 50khz con la ic
	signal salidacounter:std_logic_vector(15 downto 0);

begin

	counter: lpm_counter0 
		port map (
		aclr=>clc ,
		clock=>cclkfin,
		q=>salidacounter
		);
		
	pll50k:pll 
		port map( 
			areset=>reset1,
			inclk0=>clk,
			c0=>cclk
		);
	
	tc1<=salidacounter(1) and salidacounter(2) and salidacounter(3) and salidacounter(4) and salidacounter(5) and 
		salidacounter(8) and salidacounter(11) and salidacounter(14);
	tc2<=salidacounter(2) and salidacounter(3) and salidacounter(4) and salidacounter(5) and salidacounter(6) and 
       salidacounter(9) and salidacounter(12) and salidacounter(15);
	cclkfin<= ic and cclk;
	reset1<= not reset;
	ledcheckdf<= df;
	ledcheckdi<= dibool;
	ledcheckdd<= ddbool;
	ledcheckm0d<=M0D;
	ledcheckm1d<=M1D;
	ledcheckm0i<=M0I;
	ledcheckm1i<=M1I;
	velmd<='1';
	velmi<='1';	
	-- Logic to advance to the next state	
	process (dd,di)
	begin
		dddig<= unsigned(dd);
		didig<= unsigned(di);
		if dddig > 500 then
            ddbool <= '0';
        else
            ddbool <= '1';
        end if;
		if didig > 500 then
            dibool <= '0';
        else
            dibool <= '1';
        end if;
	end process;

	process (clk, reset1,df,dibool,ddbool,tc1,tc2)
	begin
		if reset1 = '1' then
			state <= parado;
		elsif (rising_edge(clk)) then
			case state is
				when parado=>
					if (df='0' and dibool='1') then
						if (ddbool='1') then
							state<= reversa;
						else
							state<= der;
						end if;
					else
						state <= izq;
					end if;
				when der=>
					if tc1='0' then
						state <= der;
					else
						state <= parado ;---------------------------------------agregar adelante
					end if; 
				when izq=>
					if tc1='0' then
						state <= izq;
					else
						state <=parado ;-------------------------------------agregar adelante
					end if;
				when reversa =>
					if tc2='0' then
						state <= reversa;
					else
						state <= parado ;---------agregar adelante
					end if;
			end case;
		end if;
	end process;

	-- Output depends solely on the current state
	process (state)
	begin
		case state is
			when parado =>
				M1I<= '0';M0I<= '0';M1D<= '0';M0D<= '0';
				ic<= '0';clc<= '1';
				envio0<= '0';envio1<= '0';
			when izq =>
				M1I<= '0';M0I<= '1';M1D<= '1';M0D<= '0';
				ic<= '1';clc<= '0';
				envio0<= '1';envio1<= '0';
			when der =>
				M1I<= '1';M0I<= '0';M1D<= '0';M0D<= '1';
				ic<= '1';clc<= '0';
				envio0<= '0';envio1<= '1';
			when reversa =>
				M1I<= '1';M0I<= '0';M1D<= '0';M0D<= '1';
				ic<= '1';clc<= '0';
				envio0<= '1';envio1<= '1';

			end case;
	end process;

end rtl;
