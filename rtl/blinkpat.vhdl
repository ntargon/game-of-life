library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity blinkpat is
    port (
        clk: in std_logic;
        rst: in std_logic;
        btn: in std_logic;
        LED_RGB: out std_logic_vector(2 downto 0)
    );
end blinkpat;


architecture RTL of blinkpat is
    signal s_ledpat : std_logic_vector(2 downto 0);
    signal s_cnt : std_logic_vector(5 downto 0);


begin


    process (clk) begin
        if (clk'event and clk = '1') then
            if ( rst = '1' ) then
                s_ledpat <= (others => '0');
                s_cnt <= (others => '0');
            elsif ( btn = '1' ) then
                s_cnt <= (others => '0');
            else
                s_ledpat <= s_ledpat + 1;
                s_cnt <= s_cnt + 1;
            end if;
        end if;
    end process;


    LED_RGB <= s_ledpat;

end RTL;



