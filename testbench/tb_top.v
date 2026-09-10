`timescale 1ns / 1ps

module tb_top;

    // Simulation Parameters
    parameter CLK_PERIOD   = 10;             // 100 MHz clock (10ns period)
    parameter IMG_WIDTH    = 512;
    parameter IMG_HEIGHT   = 512;
    parameter TOTAL_PIXELS = IMG_WIDTH * IMG_HEIGHT;

    // UUT Input Signals
    reg        clk;
    reg        rst;
    reg  [7:0] i_data;
    reg        i_data_valid;

    // UUT Output Signals
    wire [7:0] o_data;
    wire       o_data_valid;
    wire       o_intr;

    reg [7:0] input_mem [0:TOTAL_PIXELS-1];

    
    integer pixel_idx     = 0;
    integer out_pixel_cnt = 0;
    integer out_file;

    top uut (
        .clk(clk),
        .rst(rst),
        .i_data(i_data),
        .i_data_valid(i_data_valid),
        .o_data(o_data),
        .o_data_valid(o_data_valid),
        .o_intr(o_intr)
    );

    // 100 MHz Clock Generator
    always #(CLK_PERIOD / 2) clk = ~clk;

   
    always @(posedge clk) begin
        if (o_data_valid) begin
            $fwrite(out_file, "%02h\n", o_data);
            out_pixel_cnt <= out_pixel_cnt + 1;
        end
    end

 
    initial begin
      
        $dumpfile("top_tb.vcd");
        $dumpvars(0, tb_top);

       
        out_file = $fopen("output.hex", "w");
        if (out_file == 0) begin
            $display("ERROR");
            $finish;
        end

       
        $display("[%0t ns] Loading 'input.hex'", $time);
        $readmemh("input.hex", input_mem);

      
        clk          = 1'b0;
        rst          = 1'b1;
        i_data       = 8'h00;
        i_data_valid = 1'b0;

       
        #(CLK_PERIOD * 10);
        rst = 1'b0;
        #(CLK_PERIOD * 5);
        
        $display("[%0t ns] Start", $time);
        for (pixel_idx = 0; pixel_idx < TOTAL_PIXELS; pixel_idx = pixel_idx + 1) begin
            @(posedge clk);
            i_data       <= input_mem[pixel_idx];
            i_data_valid <= 1'b1;
        end

        // End Input Stream
        @(posedge clk);
        i_data       <= 8'h00;
        i_data_valid <= 1'b0;
        $display("[%0t ns] All pixels sent. ...", $time);

        // Wait for latency drain (5 line-buffer delays ~50,000 cycles)
        repeat (50000) @(posedge clk);

        $fclose(out_file);
        $display("[%0t ns]DONE! Total Pixels Received: %0d", $time, out_pixel_cnt);
        $finish;
    end

endmodule
