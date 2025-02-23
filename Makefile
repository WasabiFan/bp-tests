
include Makefile.frag

RISCV_GCC           = $(CROSS_COMPILE)gcc
RISCV_GPP           = $(CROSS_COMPILE)g++
RISCV_GCC_OPTS      = -march=rv64imafd -mabi=lp64 -mcmodel=medany -I $(BP_INCLUDE_DIR)
RISCV_LINK_OPTS     = -T $(BP_LINKER_DIR)/riscv.ld -L$(BP_LIB_DIR) -Wl,--whole-archive -lperch -Wl,--no-whole-archive

.PHONY: all

vpath %.c   ./src
vpath %.cpp ./src
vpath %.S   ./src

all: $(foreach x,$(subst -,_,$(BP_TESTS)),$(x).riscv)

%.riscv: %.c
	$(RISCV_GCC) -o $@ $^ $(RISCV_GCC_OPTS) $(RISCV_LINK_OPTS)

%.riscv: %.S
	$(RISCV_GCC) -o $@ $^ $(RISCV_GCC_OPTS) $(RISCV_LINK_OPTS)

%.riscv: %.cpp
	$(RISCV_GPP) -o $@ $^ $(RISCV_GCC_OPTS) $(RISCV_LINK_OPTS)

paging.riscv: vm_start.S paging.c
	$(RISCV_GCC) -o $@ $^ $(RISCV_GCC_OPTS) $(RISCV_LINK_OPTS) -nostartfiles

mapping.riscv: vm_start.S mapping.c
	$(RISCV_GCC) -o $@ $^ $(RISCV_GCC_OPTS) $(RISCV_LINK_OPTS) -nostartfiles

mc_sanity_%.riscv: mc_sanity.c
	$(RISCV_GCC) -DNUM_CORES=$(notdir $*) -o $@ $^ $(RISCV_GCC_OPTS) $(RISCV_LINK_OPTS)

mc_template_%.riscv: mc_template.c
	$(RISCV_GCC) -DNUM_CORES=$(notdir $*) -o $@ $^ $(RISCV_GCC_OPTS) $(RISCV_LINK_OPTS)

mc_rand_walk_%.riscv: mc_rand_walk.c
	$(RISCV_GCC) -DNUM_CORES=$(notdir $*) -o $@ $^ $(RISCV_GCC_OPTS) $(RISCV_LINK_OPTS)

mc_work_share_sort_%.riscv: mc_work_share_sort.c
	$(RISCV_GCC) -DNUM_CORES=$(notdir $*) -o $@ $^ $(RISCV_GCC_OPTS) $(RISCV_LINK_OPTS)

clean:
	rm -f *.riscv
