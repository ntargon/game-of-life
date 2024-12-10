`timescale 1ns/1ns
`default_nettype none


module tbench ();

//==============================================================================
//-- tbench : RESET generator
//==============================================================================
    reg resetn;

    initial begin
        resetn = 1'b1;
        #1_234_000
        resetn = 1'b0;
    end

//==============================================================================
//-- tbench : CLOCK generator
//==============================================================================
    real    FREQ_CLK = 1.0/*MHz*/;
    reg     clk;

    initial begin
        clk = 1'b0;
        forever #(1_000_000_000 / (FREQ_CLK*1_000) / 2) clk = ~clk;
    end


//==============================================================================
//-- tbench : Test Target
//==============================================================================
    reg         sig_i;  // signal in
    reg [2:0]   sig_o;  // signal out

    blinkpat blinkpat (
        .clk    (clk)       //- in  clock
    ,   .rst (resetn)    //- in  reset negative
    ,   .btn    (sig_i)     //- in  signal
    ,   .led_rgb    (sig_o)     //- out signal
    );


    // `include "blinkpat.vhdl"


// シーケンス制御
    initial begin
        $display("run start");
        #(1_000_000_000 / (FREQ_CLK*1_000) * 10)
        sig_i = 1'b1;
        #(1_000_000_000 / (FREQ_CLK*1_000) * 1)
        sig_i = 1'b0;
        #(1_000_000_000 / (FREQ_CLK*1_000) * 10)
        $finish;
    end

endmodule

`default_nettype wire