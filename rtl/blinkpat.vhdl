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

    signal s_in_tmp0 : std_logic;
    signal s_in_tmp1 : std_logic;
    signal s_out_tmp : std_logic;
    signal s_reduced_out : std_logic;
    signal s_bit_count : std_logic_vector(3 downto 0);

    function and_reduce( a : std_logic_vector ) return std_logic is
        variable result : std_logic;
    begin
        result := '1';
        for i in a'range loop
            result := result and a(i);
        end loop;
        return result;
    end function;

    function bit_count( a: std_logic_vector ) return std_logic_vector is
        variable result : std_logic_vector(3 downto 0);
    begin
        result := (others => '0');
        for i in a'range loop
            if ( a(i) = '1' ) then
                result := result + 1;
            end if;
        end loop;
        return result;
    end function;


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

    process (s_cnt) begin
        if (s_cnt = "000000") then
            s_in_tmp0 <= '1';
        elsif (s_cnt(5 downto 1) = "00000") then
            s_in_tmp1 <= '1';
        else
            s_in_tmp0 <= '0';
            s_in_tmp1 <= '0';
        end if;
    end process;

    s_out_tmp <= s_in_tmp0 and s_in_tmp1;
    s_reduced_out <= and_reduce(s_ledpat);
    s_bit_count <= bit_count(s_ledpat);

    LED_RGB <= s_ledpat;

end RTL;



