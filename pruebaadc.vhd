-- Copyright (C) 1991-2013 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- PROGRAM		"Quartus II 64-Bit"
-- VERSION		"Version 13.0.1 Build 232 06/12/2013 Service Pack 1 SJ Web Edition"
-- CREATED		"Mon Nov 11 18:13:05 2024"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY pruebaadc IS 
	PORT
	(
		ADC_DOUT :  IN  STD_LOGIC;
		df :  IN  STD_LOGIC;
		inclk0 :  IN  STD_LOGIC;
		areset :  IN  STD_LOGIC;
		ADC_SCLK :  OUT  STD_LOGIC;
		ADC_CS_N :  OUT  STD_LOGIC;
		ADC_DIN :  OUT  STD_LOGIC;
		M1I :  OUT  STD_LOGIC;
		M0I :  OUT  STD_LOGIC;
		M1D :  OUT  STD_LOGIC;
		M0D :  OUT  STD_LOGIC;
		velmi:OUT STD_LOGIC;
		velmd:OUT STD_LOGIC;
		Envio1 :  OUT  STD_LOGIC;
		Envio0 :  OUT  STD_LOGIC;
		ledcheckdf : OUT STD_LOGIC;
		ledcheckdd : OUT STD_LOGIC;
		ledcheckdi : OUT STD_LOGIC;
		ledcheckm0i : OUT STD_LOGIC;
		ledcheckm1i : OUT STD_LOGIC;
		ledcheckm0d : OUT STD_LOGIC;
		ledcheckm1d: OUT STD_LOGIC
	);
END pruebaadc;

ARCHITECTURE bdf_type OF pruebaadc IS 

COMPONENT doblar
	PORT(clk : IN STD_LOGIC;
		 df : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 dd : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
		 di : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
		 M1I : OUT STD_LOGIC;
		 M0I : OUT STD_LOGIC;
		 M1D : OUT STD_LOGIC;
		 M0D : OUT STD_LOGIC;
		 velmi:OUT STD_LOGIC;
		 velmd:OUT STD_LOGIC;
		 Envio1 : OUT STD_LOGIC;
		 Envio0 : OUT STD_LOGIC;
		 ledcheckdf : OUT STD_LOGIC;
		 ledcheckdd : OUT STD_LOGIC;
		 ledcheckdi : OUT STD_LOGIC;
		 ledcheckm0i : OUT STD_LOGIC;
		ledcheckm1i : OUT STD_LOGIC;
		ledcheckm0d : OUT STD_LOGIC;
		ledcheckm1d: OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT esqumaticoadc
	PORT(inclk0 : IN STD_LOGIC;
		 areset : IN STD_LOGIC;
		 ADC_DOUT : IN STD_LOGIC;
		 ADC_SCLK : OUT STD_LOGIC;
		 ADC_CS_N : OUT STD_LOGIC;
		 ADC_DIN : OUT STD_LOGIC;
		 CH0 : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
		 CH1 : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC_VECTOR(11 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC_VECTOR(11 DOWNTO 0);


BEGIN 



b2v_inst : doblar
PORT MAP(clk => inclk0,
		 df => df,
		 reset => areset,
		 dd => SYNTHESIZED_WIRE_0,
		 di => SYNTHESIZED_WIRE_1,
		 ledcheckdf => ledcheckdf,
 		 ledcheckdd => ledcheckdd,
		 ledcheckm0i => ledcheckm0i,
 		 ledcheckm1i => ledcheckm1i,
		 ledcheckm0d => ledcheckm0d,
 		 ledcheckm1d => ledcheckm1d,
 		 ledcheckdi => ledcheckdi,
		 velmi => velmi,
		 velmd => velmd
		 );


b2v_inst1 : esqumaticoadc
PORT MAP(inclk0 => inclk0,
		 areset => areset,
		 ADC_DOUT => ADC_DOUT,
		 ADC_SCLK => ADC_SCLK,
		 ADC_CS_N => ADC_CS_N,
		 ADC_DIN => ADC_DIN,
		 CH0 => SYNTHESIZED_WIRE_1,
		 CH1 => SYNTHESIZED_WIRE_0);


END bdf_type;