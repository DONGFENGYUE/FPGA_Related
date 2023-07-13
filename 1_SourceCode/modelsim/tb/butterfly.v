`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/04/12 16:07:21
// Design Name:
// Module Name: butterfly
// Project Name: SDF_FFT_1024
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


module butterfly #(
    parameter   integer     DATA_NUM   = 8,                 //number of fft data
    parameter   integer     STAGE_ID   = 1,                 //stage id of this BF2
    parameter   integer     DATA_WIDTH = 64                 //input data width, half real half image
)(
    input   wire                                    clk,
    input   wire                                    rstn,
    input   wire                                    data_i_en,
    input   wire    signed  [DATA_WIDTH-1 : 0]      data_i,
    output  wire                                    data_o_en,
    output  wire    signed  [DATA_WIDTH-1 : 0]      data_o,
    output  wire                                    data_sel
);

    //-----------------------local parameter-----------------------//
    localparam  STAGE_ALL = $clog2(DATA_NUM);               //number of all pipeline stage
    localparam  DELAY_N = 2**(STAGE_ALL-STAGE_ID);          //delay depth

    //-----------------------inner define-----------------------//


    //-----------------------wire define-----------------------//
    wire    signed  [DATA_WIDTH-1 : 0]  x0;                 //butterfly in0
    wire    signed  [DATA_WIDTH-1 : 0]  x1;                 //butterfly in1
    wire    signed  [DATA_WIDTH-1 : 0]  y0;                 //butterfly out0
    wire    signed  [DATA_WIDTH-1 : 0]  y1;                 //butterfly out1
    wire    signed  [DATA_WIDTH   : 0]  add;                //butterfly add
    wire    signed  [DATA_WIDTH   : 0]  sub;                //butterfly sub

    //-----------------------reg define-----------------------//
    reg     [STAGE_ALL-STAGE_ID : 0]   data_i_cnt;
    reg                                wr_en;
    reg                                rd_en;

    assign data_o = y1;

    //-----------------------data_sel logic-----------------------//
    always @(posedge clk or negedge rstn)begin
        if(!rstn)begin
            data_i_cnt <= 'd0;
        end
        else if(data_i_en)begin
            data_i_cnt <= data_i_cnt + 1'b1;
        end
        else begin
            data_i_cnt <= data_i_cnt;
        end
    end
    assign data_sel = data_i_cnt[STAGE_ALL-STAGE_ID];

    //-----------------------butterfly logic-----------------------//
    assign x1  = data_i_en ? data_i : {DATA_WIDTH{1'bx}};
    assign add = x0 + x1;
    assign sub = x0 - x1;
    assign y0  = data_sel ? sub : x1;
    assign y1  = data_sel ? add : x0;
    delay_buffer #(
        .DEPTH(DELAY_N),
        .DATA_WIDTH(DATA_WIDTH)
    ) inst_data_delay_buffer(
        .clk(clk),
        .data_i(y0),
        .data_o(x0)
    );

    //-----------------------data_o_en logic-----------------------//
    delay_buffer #(
        .DEPTH(DELAY_N),
        .DATA_WIDTH(1)
    ) inst_en_delay_buffer(
        .clk(clk),
        .data_i(data_i_en),
        .data_o(data_o_en)
    );

endmodule
