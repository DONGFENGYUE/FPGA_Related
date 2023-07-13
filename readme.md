**一键自动仿真：**

通过TestData中的matlab文件生成输入数据后，在工程根目录下打开cmd，输入make，回车即可进行仿真，可再次运行matlab文件观察频谱对比图。若需要测试其他数据，只需重新通过matlab生成数据即可。



**手动仿真步骤：**

(1) 1_SourceCode\twiddle_rom文件夹中的tw_imag_ary.txt和tw_real_ary.txt为旋转因子，若自行创建工程，需要在twiddle_rom_1024.v中修改TW_REAL_ARY_PATH和TW_IMAG_ARY_PATH至相应路径（直接使用提供的vivado2018.3_prj则不需要修改）。

(2) 打开2_TestData，用matlab运行其中一组数据的dif_fft.m，程序会自动在vivado仿真目录中生成仿真激励和仿真对比文件，若自行创建工程，需在tb_sdf_fft_1024_top.v中修改相应文件的路径（直接使用提供的vivado2018.3_prj则不需要修改）。

(3) 打开vivado2018.3_prj工程，联合Modelsim进行仿真，测试对比结果可在输出栏显示，同时会在vivado仿真目录下生成两个输出结果文件，可再次运行dif_fft.m在matlab中观察频谱对比图。

