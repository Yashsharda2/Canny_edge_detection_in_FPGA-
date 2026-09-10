module top (
    input clk,
    input rst,
    // Pixel Input Interface
    input [7:0] i_data,
    input i_data_valid,
    // Processed Pixel Output Interface
    output [7:0] o_data,
    output o_data_valid,
    // Line Buffer Interrupt Output
    output o_intr
);

    // Interconnect Wires
    wire [71:0] data_to_gb;
    wire        data_to_gb_valid;
    wire [7:0]  data_from_gb;
    wire        data_from_gb_valid;

    wire [71:0] data_to_sobel;
    wire        data_to_sobel_valid;
    wire [7:0]  mag_from_sobel;
    wire [7:0]  dir_from_sobel;
    wire        data_from_sobel_valid;

    wire [71:0] mag_to_nms;
    wire        mag_to_nms_valid;
    wire [71:0] dir_to_nms;
    wire        dir_to_nms_valid;

    wire [7:0]  data_from_nms;
    wire        data_from_nms_valid;

    wire [7:0]  data_from_dt;
    wire        data_from_dt_valid;

    wire [71:0] data_to_et;
    wire        data_to_et_valid;

    // Stage 1: Line Buffer for Gaussian Blur
    imageControl IC1 (
        .i_clk(clk),
        .i_rst(rst),
        .i_pixel_data(i_data),
        .i_pixel_data_valid(i_data_valid),
        .o_pixel_data(data_to_gb),
        .o_pixel_data_valid(data_to_gb_valid),
        .o_intr(o_intr)
    );

    // Stage 2: Gaussian Blur Filter
    gaussianBlur gb (
        .clk(clk),
        .rst(rst),
        .p_in(data_to_gb),
        .p_valid(data_to_gb_valid),
        .c_out(data_from_gb),
        .c_valid(data_from_gb_valid)
    );

    // Stage 3: Line Buffer for Sobel 
    imageControl IC2 (
        .i_clk(clk),
        .i_rst(rst),
        .i_pixel_data(data_from_gb),
        .i_pixel_data_valid(data_from_gb_valid),
        .o_pixel_data(data_to_sobel),
        .o_pixel_data_valid(data_to_sobel_valid),
        .o_intr()
    );

    // Stage 4: Single-Cycle Sobel Filter
    sobel s1 (
        .clk(clk),
        .rst(rst),
        .p_in(data_to_sobel),
        .p_valid(data_to_sobel_valid),
        .mag(mag_from_sobel),
        .dir(dir_from_sobel),
        .c_valid(data_from_sobel_valid)
    );

    // Stage 5a: Magnitude Line Buffer for NMS
    imageControl IC3 (
        .i_clk(clk),
        .i_rst(rst),
        .i_pixel_data(mag_from_sobel),
        .i_pixel_data_valid(data_from_sobel_valid),
        .o_pixel_data(mag_to_nms),
        .o_pixel_data_valid(mag_to_nms_valid),
        .o_intr()
    );

    // Stage 5b: Direction Line Buffer for NMS
    imageControl IC4 (
        .i_clk(clk),
        .i_rst(rst),
        .i_pixel_data(dir_from_sobel),
        .i_pixel_data_valid(data_from_sobel_valid),
        .o_pixel_data(dir_to_nms),
        .o_pixel_data_valid(dir_to_nms_valid),
        .o_intr()
    );

    // Stage 6: Non-Maximum Suppression
    non_max_suppr n1 (
        .clk(clk),
        .mag_data(mag_to_nms),
        .mag_valid(mag_to_nms_valid),
        .dir_data(dir_to_nms),
        .dir_valid(dir_to_nms_valid),
        .p_out(data_from_nms),
        .p_vld(data_from_nms_valid)
    );

    // Stage 7: Double Thresholding
    double_threshold dt1 (
        .clk(clk),
        .data_in(data_from_nms),
        .data_in_valid(data_from_nms_valid),
        .data_out(data_from_dt),
        .data_out_valid(data_from_dt_valid)
    );

    // Stage 8: Line Buffer for Edge Tracking
    imageControl IC5 (
        .i_clk(clk),
        .i_rst(rst),
        .i_pixel_data(data_from_dt),
        .i_pixel_data_valid(data_from_dt_valid),
        .o_pixel_data(data_to_et),
        .o_pixel_data_valid(data_to_et_valid),
        .o_intr()
    );

    // Stage 9: Edge Tracking
    edge_track et1 (
        .clk(clk),
        .data_in(data_to_et),
        .data_in_valid(data_to_et_valid),
        .data_out(o_data),
        .data_out_valid(o_data_valid)
    );

endmodule
