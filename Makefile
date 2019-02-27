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
IMAGES_DIR             := images
LOGS_DIR			         := logs
SRC_DIR                := src

INPUT_FILES            := $(wildcard $(IN_DIR)/*.in)

OUTPUT_FILES           := $(patsubst $(IN_DIR)/%.in, \
                             				 $(OUT_DIR)/%.out, \
                                     $(INPUT_FILES))

IMAGE_SUBDIRS          := $(patsubst $(IN_DIR)/%.in, \
                             				 $(IMAGES_DIR)/%, \
                                     $(INPUT_FILES))

MAIN_FILE              := $(SRC_DIR)/leader.py
R_SCRIPT               := $(SRC_DIR)/profile.R

# asciidoctor command
define run-main
python $(MAIN_FILE) $< $@
endef

define profile-datasets
Rscript $(R_SCRIPT) $< $@
endef

# Run python src/leader.py for every input dataset
$(OUT_DIR)/%.out : $(IN_DIR)/%.in
	$(run-main)

# Run Rscript src/profile.R for every input dataset
$(IMAGES_DIR)/% : $(IN_DIR)/%.in
	$(profile-datasets)

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
	mkdir -p $(IN_DIR) $(OUT_DIR) $(IMAGES_DIR) $(LOGS_DIR)

out: dirs $(OUTPUT_FILES)

images: dirs $(IMAGE_SUBDIRS)

debug:
	@echo "input files:\n\t$(INPUT_FILES)" && \
	echo "output files:\n\t$(OUTPUT_FILES)" && \
	echo "image subdirs:\n\t$(IMAGES_SUBDIRS)" && \
	echo "command:\n\t$(run-main) FILENAME" && \
	echo "command:\n\t$(profile-datasets) FILENAME"

clean :
	@echo "Cleaning up....."; \
	rm -rf $(OUT_DIR) $(IMAGES_DIR) $(LOGS_DIR)

.PHONY: all install dirs out images clean
