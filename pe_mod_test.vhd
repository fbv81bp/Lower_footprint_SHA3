library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pe_mod_test is
    Port ( --counter_plane_to_pe: in integer range 0 to 4 := 3;
           --counter_sheet_to_pe: in integer range 0 to 4 := 2;
           --rho_in : in STD_LOGIC_VECTOR (63 downto 0) := x"adbcef1023456789";
           rho_old : inout STD_LOGIC_VECTOR (63 downto 0);
           rho_new : inout STD_LOGIC_VECTOR (63 downto 0);
           equal: out STD_LOGIC);
end pe_mod_test;

architecture Behavioral of pe_mod_test is

    constant rho_in :  STD_LOGIC_VECTOR (63 downto 0) := x"adbcef1023456789";
    signal counter_plane_to_pe:  integer range 0 to 4 := 0;
    signal counter_sheet_to_pe:  integer range 0 to 4 := 0;
           
    type rhoT1 is array (0 to 4) of integer range 0 to 63;
    type rhoT2 is array (0 to 4) of rhoT1;
    constant rho_index : rhoT2 := ((0,1,62,28,27),(36,44,6,55,20),(3,10,43,25,39),(41,45,15,21,8),(18,2,61,56,14));
    signal rho_out0, rho_out1,  rho_out2,  rho_out3,  rho_out4 : std_logic_vector(63 downto 0);
    
begin

process begin
    wait for 10 ns;
    counter_plane_to_pe <= counter_plane_to_pe + 1;
    wait for 10 ns;
    counter_plane_to_pe <= counter_plane_to_pe + 1;
    wait for 10 ns;
    counter_plane_to_pe <= counter_plane_to_pe + 1;
    wait for 10 ns;
    counter_plane_to_pe <= counter_plane_to_pe + 1;
    wait for 10 ns;
    counter_sheet_to_pe <= counter_sheet_to_pe + 1;
    counter_plane_to_pe <= 0;
    wait for 10 ns;
end process;

rho_out0 <= (rho_in(62 downto 0) & rho_in(63)) when rho_index(counter_plane_to_pe)(counter_sheet_to_pe) mod 2 = 1 else
            rho_in;
rho_out1 <= (rho_out0(61 downto 0) & rho_out0(63 downto 62)) when (rho_index(counter_plane_to_pe)(counter_sheet_to_pe) / 2) mod 2 = 1 else
            rho_out0;
rho_out2 <= (rho_out1(59 downto 0) & rho_out1(63 downto 60)) when (rho_index(counter_plane_to_pe)(counter_sheet_to_pe) / 4) mod 2 = 1 else
            rho_out1;
rho_out3 <= (rho_out2(55 downto 0) & rho_out2(63 downto 56)) when (rho_index(counter_plane_to_pe)(counter_sheet_to_pe) / 8) mod 2 = 1 else
            rho_out2;
rho_out4 <= (rho_out3(47 downto 0) & rho_out3(63 downto 48)) when (rho_index(counter_plane_to_pe)(counter_sheet_to_pe) / 16) mod 2 = 1 else
            rho_out3;
rho_new <= (rho_out4(31 downto 0) & rho_out4(63 downto 32)) when (rho_index(counter_plane_to_pe)(counter_sheet_to_pe) / 32) mod 2 = 1 else
            rho_out4;

rho_old <= rho_in when (counter_plane_to_pe=0 and counter_sheet_to_pe=0) else
	rho_in(63-1 downto 0) & rho_in(63) when (counter_plane_to_pe=0 and counter_sheet_to_pe=1) else
	rho_in(63-62 downto 0) & rho_in(63 downto 64-62) when (counter_plane_to_pe=0 and counter_sheet_to_pe=2) else
	rho_in(63-28 downto 0) & rho_in(63 downto 64-28) when (counter_plane_to_pe=0 and counter_sheet_to_pe=3) else
	rho_in(63-27 downto 0) & rho_in(63 downto 64-27) when (counter_plane_to_pe=0 and counter_sheet_to_pe=4) else
	
	rho_in(63-36 downto 0) & rho_in(63 downto 64-36) when (counter_plane_to_pe=1 and counter_sheet_to_pe=0) else
	rho_in(63-44 downto 0) & rho_in(63 downto 64-44) when (counter_plane_to_pe=1 and counter_sheet_to_pe=1) else
	rho_in(63-6 downto 0) & rho_in(63 downto 64-6) when (counter_plane_to_pe=1 and counter_sheet_to_pe=2) else
	rho_in(63-55 downto 0) & rho_in(63 downto 64-55) when (counter_plane_to_pe=1 and counter_sheet_to_pe=3) else
	rho_in(63-20 downto 0) & rho_in(63 downto 64-20) when (counter_plane_to_pe=1 and counter_sheet_to_pe=4) else
	
	rho_in(63-3 downto 0) & rho_in(63 downto 64-3) when (counter_plane_to_pe=2 and counter_sheet_to_pe=0) else
	rho_in(63-10 downto 0) & rho_in(63 downto 64-10) when (counter_plane_to_pe=2 and counter_sheet_to_pe=1) else
	rho_in(63-43 downto 0) & rho_in(63 downto 64-43) when (counter_plane_to_pe=2 and counter_sheet_to_pe=2) else
	rho_in(63-25 downto 0) & rho_in(63 downto 64-25) when (counter_plane_to_pe=2 and counter_sheet_to_pe=3) else
	rho_in(63-39 downto 0) & rho_in(63 downto 64-39) when (counter_plane_to_pe=2 and counter_sheet_to_pe=4) else
	
	rho_in(63-41 downto 0) & rho_in(63 downto 64-41) when (counter_plane_to_pe=3 and counter_sheet_to_pe=0) else
	rho_in(63-45 downto 0) & rho_in(63 downto 64-45) when (counter_plane_to_pe=3 and counter_sheet_to_pe=1) else
	rho_in(63-15 downto 0) & rho_in(63 downto 64-15) when (counter_plane_to_pe=3 and counter_sheet_to_pe=2) else
	rho_in(63-21 downto 0) & rho_in(63 downto 64-21) when (counter_plane_to_pe=3 and counter_sheet_to_pe=3) else
	rho_in(63-8 downto 0) & rho_in(63 downto 64-8) when (counter_plane_to_pe=3 and counter_sheet_to_pe=4) else
	
	rho_in(63-18 downto 0) & rho_in(63 downto 64-18) when (counter_plane_to_pe=4 and counter_sheet_to_pe=0) else
	rho_in(63-2 downto 0) & rho_in(63 downto 64-2) when (counter_plane_to_pe=4 and counter_sheet_to_pe=1) else
	rho_in(63-61 downto 0) & rho_in(63 downto 64-61) when (counter_plane_to_pe=4 and counter_sheet_to_pe=2) else
	rho_in(63-56 downto 0) & rho_in(63 downto 64-56) when (counter_plane_to_pe=4 and counter_sheet_to_pe=3) else
	rho_in(63-14 downto 0) & rho_in(63 downto 64-14) when (counter_plane_to_pe=4 and counter_sheet_to_pe=4) else
	
	rho_in;

equal <= '1' when rho_new = rho_old else '0';

end Behavioral;
