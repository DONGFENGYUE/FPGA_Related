`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/04/14 15:15:25
// Design Name:
// Module Name: tb_sdf_fft_1024_top
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


module tb_sdf_fft_1024_top();

    parameter   integer     DATA_NUM            = 1024;         //number of fft data
    parameter   integer     DATA_WIDTH          = 64;           //input data width, half real half image
    parameter   integer     TWIDDLE_WIDTH       = 64;           //twiddle width, half real half image
    parameter   integer     TWIDDLE_SCALE_SHIFT = 16;           //left shift tiddle to scale

    parameter   CYC_TIME = 20.0;

    reg                                     clk;
    reg                                     rstn;
    reg                                     data_i_en;
    reg     signed  [DATA_WIDTH-1 : 0]      data_i;
    wire                                    data_o_en;
    wire    signed  [DATA_WIDTH-1 : 0]      data_o;

    integer     i, j, sub_real, sub_imag;
    integer     fo_real, fo_imag;

    reg     signed  [DATA_WIDTH-1 : 0]      mem_data_i  [0 : DATA_NUM-1];
    reg     signed  [DATA_WIDTH/2-1 : 0]    mem_fft_real [0 : DATA_NUM-1];
    reg     signed  [DATA_WIDTH/2-1 : 0]    mem_fft_imag [0 : DATA_NUM-1];

    reg     signed  [DATA_WIDTH/2-1 : 0]    data_o_real;
    reg     signed  [DATA_WIDTH/2-1 : 0]    fft_o_real;
    reg     signed  [DATA_WIDTH/2-1 : 0]    data_o_imag;
    reg     signed  [DATA_WIDTH/2-1 : 0]    fft_o_imag;

    always #(CYC_TIME/2.0) clk = ~clk;

    //-----------------------load data-----------------------//
    initial begin
        clk = 0;
        rstn = 0;
        data_i_en = 0;
        @(posedge clk);
        rstn = 1;
        @(posedge clk);
        $readmemb("./1_SourceCode/vivado2018.3_prj/SDF_FFT_1024.sim/sim_1/behav/xsim/data_before_fft.txt", mem_data_i);
        for(i = 0; i < DATA_NUM; i = i + 1)begin
            @(posedge clk);#1;
            data_i = mem_data_i[i];
            data_i_en = 1;
        end
        @(posedge clk);#1;
        data_i_en = 0;
        #21000;
        $display("Sim finished!");
        $finish();
    end

    //-----------------------compare data and generate file-----------------------//
    initial begin
        fo_real = $fopen("./1_SourceCode/vivado2018.3_prj/SDF_FFT_1024.sim/sim_1/behav/xsim/test_real_out.txt", "w"); //生成real数据输出文件给matlab进行比较
        fo_imag = $fopen("./1_SourceCode/vivado2018.3_prj/SDF_FFT_1024.sim/sim_1/behav/xsim/test_imag_out.txt", "w"); //生成imag数据输出文件给matlab进行比较
        $readmemb("./1_SourceCode/vivado2018.3_prj/SDF_FFT_1024.sim/sim_1/behav/xsim/out_real.txt", mem_fft_real);
        $readmemb("./1_SourceCode/vivado2018.3_prj/SDF_FFT_1024.sim/sim_1/behav/xsim/out_imag.txt", mem_fft_imag);
        @(posedge data_o_en);#1;
        for(j = 0; j < DATA_NUM; j = j + 1)begin
            //--real test
            data_o_real = data_o[63 : 32];
            fft_o_real  = mem_fft_real[j];
            if(data_o_real <= fft_o_real)begin
                sub_real = fft_o_real - data_o_real;
            end
            else begin
                sub_real = data_o_real - fft_o_real;
            end
            if(sub_real >= 200)begin
                $display("num %.2d is warning!true_real = %.2d, mydata_real = %.2d\n", j, fft_o_real, data_o_real);
            end

            //--imag test
            data_o_imag = data_o[31 : 0];
            fft_o_imag  = mem_fft_imag[j];
            if(data_o_imag <= fft_o_imag)begin
                sub_imag = fft_o_imag - data_o_imag;
            end
            else begin
                sub_imag = data_o_imag - fft_o_imag;
            end
            if(sub_imag >= 200)begin
                $display("num %.2d is warning!true_imag = %.2d, mydata_imag = %.2d\n", j, fft_o_imag, data_o_imag);
            end

            //--write file
            $fwrite(fo_real, "%.2d\n", data_o_real);
            $fwrite(fo_imag, "%.2d\n", data_o_imag);

            @(posedge clk);#1;
        end
    end

    sdf_fft_1024_top #(
            .DATA_NUM(DATA_NUM),
            .DATA_WIDTH(DATA_WIDTH),
            .TWIDDLE_WIDTH(TWIDDLE_WIDTH),
            .TWIDDLE_SCALE_SHIFT(TWIDDLE_SCALE_SHIFT)
        ) inst_sdf_fft_1024_top (
            .clk       (clk),
            .rstn      (rstn),
            .data_i_en (data_i_en),
            .data_i    (data_i),
            .data_o_en (data_o_en),
            .data_o    (data_o)
        );

endmodule



