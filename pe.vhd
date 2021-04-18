-- The Keccak sponge function, designed by Guido Bertoni, Joan Daemen,
-- Michaël Peeters and Gilles Van Assche. For more information, feedback or
-- questions, please refer to our website: http://keccak.noekeon.org/

-- Implementation by the designers,
-- hereby denoted as "the implementer".

-- To the extent possible under law, the implementer has waived all copyright
-- and related or neighboring rights to the source code in this file.
-- http://creativecommons.org/publicdomain/zero/1.0/

-- Modifications made by Balazs Valer Fekete 16.04.2021.
-- Contact fbv81bp@outlook.hu fbv81bp@gmail.com
-- Same license.

-- Modification's rationale: by replacing the the rho function with shifters that
-- shifts exponentially growing amounts of the data and storing the shift steps
-- in a constant array the synthesized size of this partricular file decresead from
-- 983 LUT-s to 404 LUT-s under Vivado 2020.1 for Xilinx Artix devices, while the
-- functionality stays the same.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity pe is
	port (
		clk     : in  std_logic;
		rst_n   : in  std_logic;
		data_from_mem: in std_logic_vector(63 downto 0);
		data_to_mem: out std_logic_vector(63 downto 0);
		nr_round: in integer range 0 to 23;
		command: in std_logic_vector(7 downto 0) ;
		counter_plane_to_pe: in integer range 0 to 4;
		counter_sheet_to_pe: in integer range 0 to 4);
end pe;

architecture rtl of pe is

	constant num_plane : integer := 5;
	constant num_sheet : integer := 5;
	constant logD : integer :=4;
	constant N : integer := 64;

--types
	type k_lane        is array ((N-1) downto 0)  of std_logic;    
	type k_plane       is array ((num_sheet-1) downto 0)  of k_lane;    
	type k_state       is array ((num_plane-1) downto 0)  of k_plane;  
	subtype addr_type  is integer range 0 to 63;
	subtype mod_5_type is integer range 0 to 4;
 
--components

----------------------------------------------------------------------------
-- Internal signal declarations
----------------------------------------------------------------------------

	signal r1_out, r2_out, r3_out,rho_out, chi_out,iota: std_logic_vector(63 downto 0);
	signal r1_in, r2_in, r3_in : std_logic_vector(63 downto 0);

-- Modification begins
 
	type rhoT1 is array (0 to 4) of integer range 0 to 63;
	type rhoT2 is array (0 to 4) of rhoT1;
	constant rho_index : rhoT2 := ((0,1,62,28,27),(36,44,6,55,20),(3,10,43,25,39),(41,45,15,21,8),(18,2,61,56,14));
	signal rho_out0, rho_out1,  rho_out2,  rho_out3,  rho_out4 : std_logic_vector(63 downto 0);

-- End of modifictaion

begin  -- Rtl

 
 
 -- 3 registers
 
  reg_main : process (clk, rst_n)
    
  begin  -- process p_main
    if rst_n = '0' then                 -- asynchronous rst_n (active low)
		r1_out<=(others=>'0');
		r2_out<=(others=>'0');
		r3_out<=(others=>'0');
      

    elsif clk'event and clk = '1' then  -- rising clk edge
	
		r1_out<=r1_in;
		r2_out<=r2_in;
		r3_out<=r3_in;
  end if;
  end process reg_main;
  
  
--registers input
r1_in<= data_from_mem when command(0)='1' else
		data_from_mem xor r1_out when command(1)='1' else
		data_from_mem xor r3_out xor (r2_out(62 downto 0) & r2_out(63)) when command(2)='1' else
		r1_out;

r2_in<=r1_out when command(3)='1' else
	r2_out;
r3_in <= r2_out when command(3)='1' else
	r3_out;


data_to_mem<= r1_out when command(4)='1' else
			rho_out when command(5)='1' else
			chi_out when command(6)='1' else
			chi_out xor iota when command(7)='1' else
			(others=>'0');
			
chi_out <= r3_out xor( not(r2_out) and r1_out);

--MODIFIED AREA
rho_out0 <= (r1_out(62 downto 0) & r1_out(63)) when rho_index(counter_plane_to_pe)(counter_sheet_to_pe) mod 2 = 1 else
            r1_out;
rho_out1 <= (rho_out0(61 downto 0) & rho_out0(63 downto 62)) when (rho_index(counter_plane_to_pe)(counter_sheet_to_pe) / 2) mod 2 = 1 else
            rho_out0;
rho_out2 <= (rho_out1(59 downto 0) & rho_out1(63 downto 60)) when (rho_index(counter_plane_to_pe)(counter_sheet_to_pe) / 4) mod 2 = 1 else
            rho_out1;
rho_out3 <= (rho_out2(55 downto 0) & rho_out2(63 downto 56)) when (rho_index(counter_plane_to_pe)(counter_sheet_to_pe) / 8) mod 2 = 1 else
            rho_out2;
rho_out4 <= (rho_out3(47 downto 0) & rho_out3(63 downto 48)) when (rho_index(counter_plane_to_pe)(counter_sheet_to_pe) / 16) mod 2 = 1 else
            rho_out3;
rho_out <= (rho_out4(31 downto 0) & rho_out4(63 downto 32)) when (rho_index(counter_plane_to_pe)(counter_sheet_to_pe) / 32) mod 2 = 1 else
            rho_out4;
--END OF MODIFICATIONS

iota <= X"0000000000000001" when nr_round=0  else
		X"0000000000008082" when nr_round=1  else
		X"800000000000808A" when nr_round=2  else
		X"8000000080008000" when nr_round=3  else
		X"000000000000808B" when nr_round=4  else
		X"0000000080000001" when nr_round=5  else
		X"8000000080008081" when nr_round=6  else
		X"8000000000008009" when nr_round=7  else
		X"000000000000008A" when nr_round=8  else
		X"0000000000000088" when nr_round=9  else
		X"0000000080008009" when nr_round=10 else
		X"000000008000000A" when nr_round=11 else
		X"000000008000808B" when nr_round=12 else
		X"800000000000008B" when nr_round=13 else
		X"8000000000008089" when nr_round=14 else
		X"8000000000008003" when nr_round=15 else
		X"8000000000008002" when nr_round=16 else
		X"8000000000000080" when nr_round=17 else
		X"000000000000800A" when nr_round=18 else
		X"800000008000000A" when nr_round=19 else
		X"8000000080008081" when nr_round=20 else
		X"8000000000008080" when nr_round=21 else
		X"0000000080000001" when nr_round=22 else
		X"8000000080008008" when nr_round=23 else
		X"0000000000000000";

end rtl;
