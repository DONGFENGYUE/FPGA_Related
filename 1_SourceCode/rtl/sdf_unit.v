`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/04/13 15:28:50
// Design Name:
// Module Name: sdf_unit
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


module sdf_unit#(
    parameter   integer     DATA_NUM            = 1024,        //number of fft data
    parameter   integer     STAGE_ID            = 1,        //stage id of this BF2
    parameter   integer     DATA_WIDTH          = 64,       //input data width, half real half image
    parameter   integer     TWIDDLE_WIDTH       = 64,       //twiddle width, half real half image
    parameter   integer     TWIDDLE_SCALE_SHIFT = 16        //left shift tiddle to scale
)(
    input   wire                                    clk,
    input   wire                                    rstn,
    input   wire                                    data_i_en,
    input   wire    signed  [DATA_WIDTH-1 : 0]      data_i,
    output  wire                                    mul_o_en,
    output  wire    signed  [DATA_WIDTH-1 : 0]      mul_o
);

    //-----------------------local parameter-----------------------//
    localparam  STAGE_ALL = $clog2(DATA_NUM);               //number of all pipeline stage

    //-----------------------wire define-----------------------//
    wire    signed  [DATA_WIDTH-1 : 0]      bf_data_o;
    wire    signed  [TWIDDLE_WIDTH-1 : 0]   twiddle;
    wire                                    data_sel;

    //-----------------------reg define-----------------------//
    reg             [STAGE_ALL-2 : 0]       twiddle_addr;

    //--------------------bf_data_o/mul_o_en 1 beat------------------//
    reg signed  [DATA_WIDTH-1 : 0]    bf_data_o_reg;
    wire mul_o_en_temp1;
    reg mul_o_en_temp2;

    always @(posedge clk) begin
        bf_data_o_reg <= bf_data_o;
        mul_o_en_temp2 <= mul_o_en_temp1;
    end

    assign mul_o_en = mul_o_en_temp2;
    //-----------------------calculate twiddle addr logic-----------------------//
    always @(posedge clk or negedge rstn)begin
        if(!rstn)begin
            twiddle_addr <= 'd0;
        end
        else if(mul_o_en_temp2 && !data_sel)begin
            twiddle_addr <= twiddle_addr + 2**(STAGE_ID-1);
        end
        else begin
            twiddle_addr <= 'd0;
        end
    end

    //---------instance-----------//

    butterfly #(
        .DATA_NUM(DATA_NUM),
        .STAGE_ID(STAGE_ID),
        .DATA_WIDTH(DATA_WIDTH)
    ) inst_butterfly (
        .clk       (clk),
        .rstn      (rstn),
        .data_i_en (data_i_en),
        .data_i    (data_i),
        .data_o_en (mul_o_en_temp1),
        .data_o    (bf_data_o),
        .data_sel  (data_sel)
    );

    // twiddle_1024 #(
    //     .TWIDDLE_WIDTH(TWIDDLE_WIDTH),
    //     .ADDR_WIDTH(STAGE_ALL-2)
    // ) inst_twiddle_1024(
    //     .addr(twiddle_addr),
    //     .twiddle(twiddle)
    // );

    /*add twiddle_rom_1024*/
    twiddle_rom_1024 #(
        .TWIDDLE_WIDTH    ( TWIDDLE_WIDTH    ),
        .ADDR_WIDTH       ( STAGE_ALL-2      ))
    u_twiddle_rom_1024 (
        .clk              ( clk             ),
        .en               ( 1'b1               ),
        .addr             ( twiddle_addr    ),
        .twiddle          ( twiddle         )
    );

    complex_mul #(
        .DATA_WIDTH(DATA_WIDTH),
        .TWIDDLE_WIDTH(TWIDDLE_WIDTH),
        .TWIDDLE_SCALE_SHIFT(TWIDDLE_SCALE_SHIFT)
    ) inst_complex_mul (
        .data_i    (bf_data_o_reg), /*change bf_data_o_reg*/
        .twiddle_i (twiddle),
        .mul_o     (mul_o)
    );

endmodule
