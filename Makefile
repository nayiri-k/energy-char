vlsi_dir=$(abspath .)



# minimal flow configuration variables
design              ?= sramtest
pdk                 ?= sky130
tools               ?= cm
env                 ?= bwrc

extra               ?=  # extra configs
args                ?=  # command-line args (including step flow control)


OBJ_DIR             ?= $(vlsi_dir)/build-$(pdk)-$(tools)/$(design)

# non-overlapping default configs
ENV_YML             ?= configs-env/$(env)-env.yml
PDK_CONF            ?= configs-pdk/$(pdk).yml
TOOLS_CONF          ?= configs-tool/$(tools).yml

# generated dirs
GEN_SRC_DIR         ?= $(vlsi_dir)/generated-src
GEN_CONFIGS_DIR        ?= $(vlsi_dir)/generated-configs

# design-specific overrides of default configs
DESIGN_CONF         ?= configs-design/$(design)/common.yml
DESIGN_PDK_CONF     ?= configs-design/$(design)/$(pdk).yml
SIM_CONF            ?= $(if $(findstring -rtl,$(MAKECMDGOALS)), configs-design/$(design)/sim-rtl.yml, \
                       $(if $(findstring -syn,$(MAKECMDGOALS)), configs-design/$(design)/sim-syn.yml, \
                       $(if $(findstring -par,$(MAKECMDGOALS)), configs-design/$(design)/sim-par.yml, )))
POWER_CONF          ?= $(if $(findstring power-rtl,$(MAKECMDGOALS)), configs-design/$(design)/power-rtl-$(pdk).yml, \
                       $(if $(findstring power-syn,$(MAKECMDGOALS)), configs-design/$(design)/power-syn-$(pdk).yml, \
                       $(if $(findstring power-par,$(MAKECMDGOALS)), configs-design/$(design)/power-par-$(pdk).yml, )))
SRAM_CONF           ?= $(OBJ_DIR)/sram_generator-output.json

PROJ_YMLS           ?= $(PDK_CONF) $(TOOLS_CONF) $(DESIGN_CONF) $(DESIGN_PDK_CONF) $(SIM_CONF) $(POWER_CONF) $(extra)
HAMMER_EXTRA_ARGS   ?= $(foreach conf, $(PROJ_YMLS), -p $(conf)) -p $(SRAM_CONF) $(args)




HAMMER_D_MK = $(OBJ_DIR)/hammer.d

build: $(HAMMER_D_MK)

$(HAMMER_D_MK): $(SRAM_CONF)
	hammer-vlsi --obj_dir $(OBJ_DIR) -e $(ENV_YML) $(HAMMER_EXTRA_ARGS) build

-include $(HAMMER_D_MK)

$(SRAM_CONF) srams:
	hammer-vlsi --obj_dir $(OBJ_DIR) -e $(ENV_YML) $(foreach conf, $(PROJ_YMLS), -p $(conf)) sram_generator
	cp output.json $(SRAM_CONF)

clean-log:
	rm *.log

clean-generated:
	rm -rf $(GEN_SRC_DIR) $(GEN_CONFIGS_DIR)
