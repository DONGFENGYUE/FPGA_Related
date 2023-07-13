`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/04/14 12:52:47
// Design Name:
// Module Name: sdf_fft_1024_top
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module sdf_fft_1024_top #(
    parameter   integer     DATA_NUM            = 1024,         //number of fft data
    parameter   integer     DATA_WIDTH          = 64,           //input data width, half real half image
    parameter   integer     TWIDDLE_WIDTH       = 64,           //twiddle width, half real half image
    parameter   integer     TWIDDLE_SCALE_SHIFT = 16            //left shift tiddle to scale
)(
    input   wire                                    clk,
    input   wire                                    rstn,
    input   wire                                    data_i_en,
    input   wire    signed  [DATA_WIDTH-1 : 0]      data_i,
    output  wire                                    data_o_en,
    output  wire    signed  [DATA_WIDTH-1 : 0]      data_o
);

    wire                                    en_s1;
    wire    signed  [DATA_WIDTH-1 : 0]      data_o_s1;
    wire                                    en_s2;
    wire    signed  [DATA_WIDTH-1 : 0]      data_o_s2;
    wire                                    en_s3;
    wire    signed  [DATA_WIDTH-1 : 0]      data_o_s3;
    wire                                    en_s4;
    wire    signed  [DATA_WIDTH-1 : 0]      data_o_s4;
    wire                                    en_s5;
    wire    signed  [DATA_WIDTH-1 : 0]      data_o_s5;
    wire                                    en_s6;
    wire    signed  [DATA_WIDTH-1 : 0]      data_o_s6;
    wire                                    en_s7;
    wire    signed  [DATA_WIDTH-1 : 0]      data_o_s7;
    wire                                    en_s8;
    wire    signed  [DATA_WIDTH-1 : 0]      data_o_s8;
    wire                                    en_s9;
    wire    signed  [DATA_WIDTH-1 : 0]      data_o_s9;

    sdf_unit #(
        .DATA_NUM(DATA_NUM),
        .STAGE_ID(1),
        .DATA_WIDTH(DATA_WIDTH),
        .TWIDDLE_WIDTH(TWIDDLE_WIDTH),
        .TWIDDLE_SCALE_SHIFT(TWIDDLE_SCALE_SHIFT)
    ) s1_sdf_unit (
        .clk       (clk),
        .rstn      (rstn),
        .data_i_en (data_i_en),
        .data_i    (data_i),
        .mul_o_en  (en_s1),
        .mul_o     (data_o_s1)
    );

    sdf_unit #(
        .DATA_NUM(DATA_NUM),
        .STAGE_ID(2),
        .DATA_WIDTH(DATA_WIDTH),
        .TWIDDLE_WIDTH(TWIDDLE_WIDTH),
        .TWIDDLE_SCALE_SHIFT(TWIDDLE_SCALE_SHIFT)
    ) s2_sdf_unit (
        .clk       (clk),
        .rstn      (rstn),
        .data_i_en (en_s1),
        .data_i    (data_o_s1),
        .mul_o_en  (en_s2),
        .mul_o     (data_o_s2)
    );

    sdf_unit #(
        .DATA_NUM(DATA_NUM),
        .STAGE_ID(3),
        .DATA_WIDTH(DATA_WIDTH),
        .TWIDDLE_WIDTH(TWIDDLE_WIDTH),
        .TWIDDLE_SCALE_SHIFT(TWIDDLE_SCALE_SHIFT)
    ) s3_sdf_unit (
        .clk       (clk),
        .rstn      (rstn),
        .data_i_en (en_s2),
        .data_i    (data_o_s2),
        .mul_o_en  (en_s3),
        .mul_o     (data_o_s3)
    );

    sdf_unit #(
        .DATA_NUM(DATA_NUM),
        .STAGE_ID(4),
        .DATA_WIDTH(DATA_WIDTH),
        .TWIDDLE_WIDTH(TWIDDLE_WIDTH),
        .TWIDDLE_SCALE_SHIFT(TWIDDLE_SCALE_SHIFT)
    ) s4_sdf_unit (
        .clk       (clk),
        .rstn      (rstn),
        .data_i_en (en_s3),
        .data_i    (data_o_s3),
        .mul_o_en  (en_s4),
        .mul_o     (data_o_s4)
    );

    sdf_unit #(
        .DATA_NUM(DATA_NUM),
        .STAGE_ID(5),
        .DATA_WIDTH(DATA_WIDTH),
        .TWIDDLE_WIDTH(TWIDDLE_WIDTH),
        .TWIDDLE_SCALE_SHIFT(TWIDDLE_SCALE_SHIFT)
    ) s5_sdf_unit (
        .clk       (clk),
        .rstn      (rstn),
        .data_i_en (en_s4),
        .data_i    (data_o_s4),
        .mul_o_en  (en_s5),
        .mul_o     (data_o_s5)
    );

    sdf_unit #(
        .DATA_NUM(DATA_NUM),
        .STAGE_ID(6),
        .DATA_WIDTH(DATA_WIDTH),
        .TWIDDLE_WIDTH(TWIDDLE_WIDTH),
        .TWIDDLE_SCALE_SHIFT(TWIDDLE_SCALE_SHIFT)
    ) s6_sdf_unit (
        .clk       (clk),
        .rstn      (rstn),
        .data_i_en (en_s5),
        .data_i    (data_o_s5),
        .mul_o_en  (en_s6),
        .mul_o     (data_o_s6)
    );

    sdf_unit #(
        .DATA_NUM(DATA_NUM),
        .STAGE_ID(7),
        .DATA_WIDTH(DATA_WIDTH),
        .TWIDDLE_WIDTH(TWIDDLE_WIDTH),
        .TWIDDLE_SCALE_SHIFT(TWIDDLE_SCALE_SHIFT)
    ) s7_sdf_unit (
        .clk       (clk),
        .rstn      (rstn),
        .data_i_en (en_s6),
        .data_i    (data_o_s6),
        .mul_o_en  (en_s7),
        .mul_o     (data_o_s7)
    );

    sdf_unit #(
        .DATA_NUM(DATA_NUM),
        .STAGE_ID(8),
        .DATA_WIDTH(DATA_WIDTH),
        .TWIDDLE_WIDTH(TWIDDLE_WIDTH),
        .TWIDDLE_SCALE_SHIFT(TWIDDLE_SCALE_SHIFT)
    ) s8_sdf_unit (
        .clk       (clk),
        .rstn      (rstn),
        .data_i_en (en_s7),
        .data_i    (data_o_s7),
        .mul_o_en  (en_s8),
        .mul_o     (data_o_s8)
    );

    sdf_unit #(
        .DATA_NUM(DATA_NUM),
        .STAGE_ID(9),
        .DATA_WIDTH(DATA_WIDTH),
        .TWIDDLE_WIDTH(TWIDDLE_WIDTH),
        .TWIDDLE_SCALE_SHIFT(TWIDDLE_SCALE_SHIFT)
    ) s9_sdf_unit (
        .clk       (clk),
        .rstn      (rstn),
        .data_i_en (en_s8),
        .data_i    (data_o_s8),
        .mul_o_en  (en_s9),
        .mul_o     (data_o_s9)
    );

    sdf_unit #(
        .DATA_NUM(DATA_NUM),
        .STAGE_ID(10),
        .DATA_WIDTH(DATA_WIDTH),
        .TWIDDLE_WIDTH(TWIDDLE_WIDTH),
        .TWIDDLE_SCALE_SHIFT(TWIDDLE_SCALE_SHIFT)
    ) s10_sdf_unit (
        .clk       (clk),
        .rstn      (rstn),
        .data_i_en (en_s9),
        .data_i    (data_o_s9),
        .mul_o_en  (data_o_en),
        .mul_o     (data_o)
    );

endmodule
