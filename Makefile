################################################
#
#
#               Le Makefile
#
#
################################################
#   Author:
#
#          Pedro Pinto da Silva
#           p.pinto-da-silva2@newcastle.ac.uk
#
################################################

IN_DIR                 := in
OUT_DIR                := out
IN_PROFILE_DIR         := in_profile
OUT_PROFILE_DIR        := out_profile
LOGS_DIR			         := logs
SRC_DIR                := src

INPUT_FILES            := $(wildcard $(IN_DIR)/*.in)

OUTPUT_FILES           := $(patsubst $(IN_DIR)/%.in, \
                             				 $(OUT_DIR)/%.out, \
                                     $(INPUT_FILES))

IN_PROFILE_FILES       := $(patsubst $(IN_DIR)/%.in, \
                             				 $(IN_PROFILE_DIR)/%, \
                                     $(INPUT_FILES))

OUT_PROFILE_FILES      := $(patsubst $(OUT_DIR)/%.out, \
                            				 $(OUT_PROFILE_DIR)/%, \
                                     $(OUTPUT_FILES))

MAIN_FILE              := $(SRC_DIR)/leader.py
IN_PROFILE_SCRIPT      := $(SRC_DIR)/in_profile.R
OUT_PROFILE_SCRIPT     := $(SRC_DIR)/out_profile.R

# asciidoctor command
define run-main
python $(MAIN_FILE) $< $@
endef

# Run python src/leader.py for every input dataset
$(OUT_DIR)/%.out : $(IN_DIR)/%.in
	$(run-main)

# Run Rscript src/in_profile.R for every input dataset
$(IN_PROFILE_DIR)/% : $(IN_DIR)/%.in
	Rscript $(IN_PROFILE_SCRIPT) $< $@

# Run Rscript src/out_profile.R for every output dataset
$(OUT_PROFILE_DIR)/% : $(OUT_DIR)/%.out
	Rscript $(OUT_PROFILE_SCRIPT) $< $@

################################################
#
#
#               Phonies
#
#
################################################


all:
	@echo "Nope"

install: requirements.txt
	@echo "Installing requirements"
	pip install -r requirements.txt

dirs:
	mkdir -p $(IN_DIR) $(OUT_DIR) $(IN_PROFILE_DIR) $(LOGS_DIR) $(OUT_PROFILE_DIR)

out: dirs $(OUTPUT_FILES)

iprofile: dirs $(IN_PROFILE_FILES)

oprofile: dirs $(OUT_PROFILE_FILES)

debug:
	@echo "input files:\n\t$(INPUT_FILES)" && \
	echo "output files:\n\t$(OUTPUT_FILES)" && \
	echo "in profile:\n\t$(IN_PROFILE_FILES)" && \
	echo "out profile:\n\t$(OUT_PROFILE_FILES)" && \
	echo "command:\n\t$(run-main) FILENAME" && \
	echo "command:\n\t$(profile-datasets) FILENAME"

clean :
	@echo "Cleaning up....."; \
	rm -rf $(OUT_DIR) $(LOGS_DIR) $(IN_PROFILE_DIR) $(OUT_PROFILE_DIR)

.PHONY: all install dirs out iprofile oprofile debug clean
