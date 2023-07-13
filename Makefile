TARGET = tb_sdf_fft_1024_top


TB = ./1_SourceCode/modelsim/tb
SIM = ./1_SourceCode/modelsim/sim

TOP_MODULE = $(TARGET)

TMP_LIB_DIR	= $(SIM)/$(TOP_MODULE)

ALL_SRCS = $(TB)/*.v

MODEL_FLAGS = -reportprogress 300 -work $(TMP_LIB_DIR) -lint -hazards

modelsim : $(ALL_SRCS)
	vlib $(TMP_LIB_DIR);\
	vlog $(MODEL_FLAGS) $(ALL_SRCS);\
	vsim -batch -t 10ps -voptargs="+acc -O0 +notimingcheck" $(TMP_LIB_DIR).$(TOP_MODULE) -wlf $(TOP_MODULE).wlf -do "run -all;"

clean:
	@rm -rf $(TMP_LIB_DIR)

re: clean modelsim
