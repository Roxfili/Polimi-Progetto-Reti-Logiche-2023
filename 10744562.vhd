
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--DATAPATH--

entity datapath is
	Port (
		i_clk: in STD_LOGIC;
		i_rst: in STD_LOGIC;
		i_w: in STD_LOGIC;
        i_start: in STD_LOGIC; 
        count_load: in STD_LOGIC;  
        load: in STD_LOGIC;
        sel: in STD_LOGIC;
        i_mem_data: in STD_LOGIC_VECTOR(7 downto 0);
        o_mem_addr: out STD_LOGIC_VECTOR(15 downto 0);
        o_done: out STD_LOGIC;
        o_z0: out STD_LOGIC_VECTOR(7 downto 0);
        o_z1: out STD_LOGIC_VECTOR(7 downto 0);
        o_z2: out STD_LOGIC_VECTOR(7 downto 0);
        o_z3: out STD_LOGIC_VECTOR(7 downto 0);
        count: out STD_LOGIC_VECTOR(1 downto 0)
       
	); 

end datapath;

architecture Behavioral of datapath is
signal o_count : UNSIGNED(1 downto 0);
signal o_sh1 : STD_LOGIC_VECTOR (1 downto 0);
signal o_sh2 : STD_LOGIC_VECTOR (15 downto 0);
signal r0_load : STD_LOGIC;
signal r1_load : STD_LOGIC;
signal r2_load : STD_LOGIC;
signal r3_load : STD_LOGIC;
signal o_reg0 : STD_LOGIC_VECTOR (7 downto 0);
signal o_reg1 : STD_LOGIC_VECTOR (7 downto 0);
signal o_reg2 : STD_LOGIC_VECTOR (7 downto 0);
signal o_reg3 : STD_LOGIC_VECTOR (7 downto 0);

begin	

--REGISTRO INDIRIZZO Zk
process(i_clk, i_rst, sel)
begin 
    if(i_rst ='1' or sel='1') then
        o_sh1<="00";
    elsif(i_clk'event and i_clk ='1') then
      if (o_count < "01" and i_start = '1') then 
        o_sh1(1) <= o_sh1(0);
        o_sh1(0) <= i_w;
      end if;
    end if;
end process;
  
 --REGISTRO INDIRIZZO MEMORIA
process(i_clk, i_rst, sel)
begin
  if (i_rst='1' or sel='1') then
    o_sh2<="0000000000000000";
  elsif(i_clk'event and i_clk ='1') then
    if (o_count > "00" and i_start= '1') then			
	   o_sh2(15)<=o_sh2(14);
       o_sh2(14)<=o_sh2(13);
	   o_sh2(13)<=o_sh2(12);
	   o_sh2(12)<=o_sh2(11);	
	   o_sh2(11)<=o_sh2(10);
	   o_sh2(10)<=o_sh2(9);
	   o_sh2(9)<=o_sh2(8);
	   o_sh2(8)<=o_sh2(7);
	   o_sh2(7)<=o_sh2(6);	  
	   o_sh2(6)<=o_sh2(5);
	   o_sh2(5)<=o_sh2(4);
	   o_sh2(4)<=o_sh2(3);
	   o_sh2(3)<=o_sh2(2);
	   o_sh2(2)<=o_sh2(1);
	   o_sh2(1)<=o_sh2(0);
	   o_sh2(0)<=i_w;		
	end if;	      
  end if;

end process;

o_mem_addr <= o_sh2;

with o_sh1 select
    r0_load <= load when "00",
               '0' when others;
with o_sh1 select
    r1_load <= load when "01",
               '0' when others;
with o_sh1 select
    r2_load <= load when "10",
               '0' when others;
with o_sh1 select
    r3_load <= load when "11",
               '0' when others;
 
process(i_rst, i_clk, sel)
begin
    if(i_rst='1' or sel ='1') then
        o_count <= "00";
    elsif(i_clk'event and i_clk ='1') then
        if(count_load ='1' and o_count < "10") then
           o_count <= o_count + "01";
        elsif o_count = "10" then
           o_count <= "10";
        end if;
    end if;   
end process;

count <= STD_LOGIC_VECTOR(o_count);

--registro r0
process(i_rst, i_clk)
begin
    if(i_rst='1') then
        o_reg0 <= "00000000";
    elsif(i_clk'event and i_clk ='1') then
      if( r0_load='1') then
        o_reg0 <= i_mem_data;
      end if;
    end if;
end process;

--registro r1
process(i_rst, i_clk)
begin
    if(i_rst='1') then
        o_reg1 <= "00000000";
    elsif(i_clk'event and i_clk ='1') then
      if( r1_load='1') then
        o_reg1 <= i_mem_data;
      end if;
    end if;
end process;

--registro r2
process(i_rst, i_clk)
begin
    if(i_rst='1') then
        o_reg2 <= "00000000";
    elsif(i_clk'event and i_clk ='1') then
       if( r2_load='1') then
        o_reg2 <= i_mem_data;
       end if;
    end if;
end process;

--registro r3
process(i_rst, i_clk)
begin
    if(i_rst='1') then
        o_reg3 <= "00000000";
    elsif(i_clk'event and i_clk ='1') then
      if( r3_load='1') then
        o_reg3 <= i_mem_data;
      end if;
    end if;
end process;

with sel select
    o_z0 <= o_reg0 when '1',
            "00000000" when others;

with sel select
    o_z1 <= o_reg1 when '1',
            "00000000" when others;

with sel select
    o_z2 <= o_reg2 when '1',
            "00000000" when others;

with sel select
    o_z3 <= o_reg3 when '1',
            "00000000" when others;            

o_done <= sel;


end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity project_reti_logiche is
port (
	i_clk : in STD_LOGIC;
	i_rst : in std_logic;
	i_start : in std_logic;
	i_w : in std_logic;
	o_z0 : out std_logic_vector(7 downto 0);
	o_z1 : out std_logic_vector(7 downto 0);
	o_z2 : out std_logic_vector(7 downto 0);
	o_z3 : out std_logic_vector(7 downto 0);
	o_done : out std_logic;
	o_mem_addr : out std_logic_vector(15 downto 0);
	i_mem_data : in std_logic_vector(7 downto 0);
	o_mem_we : out std_logic;
	o_mem_en : out std_logic
);
end project_reti_logiche;

Architecture Behavioral of project_reti_logiche is
component datapath is
  Port ( 
          i_clk: in STD_LOGIC;
          i_rst: in STD_LOGIC;
          i_w: in STD_LOGIC;
          i_start: in STD_LOGIC; 
          count_load: in STD_LOGIC;
          load: in STD_LOGIC;
          sel: in STD_LOGIC;
          i_mem_data: in STD_LOGIC_VECTOR(7 downto 0);
          o_mem_addr: out STD_LOGIC_VECTOR(15 downto 0);
          o_done: out STD_LOGIC;
          o_z0: out STD_LOGIC_VECTOR(7 downto 0);
          o_z1: out STD_LOGIC_VECTOR(7 downto 0);
          o_z2: out STD_LOGIC_VECTOR(7 downto 0);
          o_z3: out STD_LOGIC_VECTOR(7 downto 0);
          count: out STD_LOGIC_VECTOR(1 downto 0)
                  
	  );
end component; 
signal sel : STD_LOGIC;
signal load : STD_LOGIC;
signal count_load: STD_LOGIC;
signal count: STD_LOGIC_VECTOR(1 downto 0);
type S is (S0, S1, S2, S3, S4);
signal cur_state, next_state : S;

begin 
  DATAPATH0: datapath port map(
  i_clk,
  i_rst,
  i_w,
  i_start,
  count_load,
  load,
  sel,
  i_mem_data,
  o_mem_addr,
  o_done,
  o_z0,
  o_z1,
  o_z2,
  o_z3,
  count
  );

-- MACCHINA A STATI
 process(i_clk, i_rst)
 begin
   if(i_rst='1') then
     cur_state <= S0;
   elsif (i_clk'event and i_clk='1') then
     cur_state <= next_state;
   end if;
 end process;

 process(cur_state, i_start, i_rst)
 begin
   next_state <= cur_state;
   case cur_state is
	when S0 => 
		if i_start = '1' then
		   next_state <= S1;
		end if;
	when S1 =>
	   if i_start='0' then
		   next_state <= S2;
	   elsif i_rst = '1' then
	       next_state <= S0;
	   end if;
    when S2 =>
          next_state <= S3;
	when S3 =>
		  next_state <= S4;
	when S4 =>
		next_state <= S0;
   end case;
 end process;
	
 process(cur_state)
 begin
	o_mem_en <= '0';
	o_mem_we <= '0';
	sel <= '0';
	load <= '0';
	count_load <= '0';
	case cur_state is
	   when S0 =>
          sel <= '0';
	   when S1 =>
	      count_load <= '1';		
	   when S2=>
	      count_load <= '0';
	      o_mem_en <= '1';
	   when S3 =>
		  load <= '1';
		  o_mem_en <= '0';
	   when S4 =>
		  load <= '0';
		  sel <= '1';
	end case;
  end process;

end Behavioral;

