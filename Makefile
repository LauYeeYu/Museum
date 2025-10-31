# --- OS Detection ---
# This logic runs once when 'make' is loaded.
# It sets the OS_NAME variable, which we can use in our rules.

OS_NAME := Unknown

# First, check for Windows (which covers native cmd, PowerShell, and Git Bash)
ifeq ($(OS), Windows_NT)
	OS_NAME := Windows
else
	# If not Windows, use 'uname' (standard on Linux and macOS)
	UNAME_S := $(shell uname -s)
	
	ifeq ($(UNAME_S), Linux)
		OS_NAME := Linux
		# Check if this is Windows Subsystem for Linux (WSL)
		# We check /proc/version for the word "Microsoft" or "WSL"
		ifneq ($(shell cat /proc/version 2>/dev/null | grep -Ei 'Microsoft|WSL'),)
			OS_NAME := Windows_WSL
		endif
	endif

	ifeq ($(UNAME_S), Darwin)
		OS_NAME := macOS
	endif
endif

GREP := grep
ifeq ($(OS_NAME), macOS)
	GREP := ggrep
endif

# Find all .webp files excluding cover.webp
WEBP_IMAGES := $(shell find content/posts -type f -name "*.webp" ! -name "cover.*" ! -name "*-placeholder.webp")

# Generate placeholder names (replace .webp with -placeholder.webp)
PLACEHOLDERS := $(WEBP_IMAGES:.webp=-placeholder.webp)

CHINESE_CHARACTERS := $(shell $(GREP) -P -o -r -h -I "\p{Han}" content/ | sort | uniq | tr -d '\n')

CHINESE_FONTS := static/fonts/chinese-font.woff2

# Default target
.PHONY: all
all: $(PLACEHOLDERS)

# Rule to convert image.webp to image-placeholder.webp
%-placeholder.webp: %.webp
	magick "$<" -resize 400x -blur 0x6 "$@"

.PHONY: fonts
fonts: ${CHINESE_FONTS}

${CHINESE_FONTS}: FORCE
	mkdir -p static/fonts
	@echo "Find Chinese characters: ${CHINESE_CHARACTERS}"
	pyftsubset tmp/SourceHanSerifSC.ttf --text="${CHINESE_CHARACTERS}" --flavor="woff2" --output-file="$@"

.PHONY: FORCE
FORCE:

.PHONY: setup-for-mac
setup-for-mac:
	brew install fonttools imagemagick brotli

.PHONY: download-fonts
download-fonts:
	mkdir -p tmp
	curl -s https://api.github.com/repos/adobe-fonts/source-han-serif/releases/latest \
		| $(GREP) "SourceHanSerifSC.zip" | $(GREP) "browser_download_url" \
		| cut -d '"' -f 4 | wget -O tmp/SourceHanSerifSC.zip -i -
	unzip -p tmp/SourceHanSerifSC.zip OTF/SimplifiedChinese/SourceHanSerifSC-Regular.otf > tmp/SourceHanSerifSC.ttf
	

# Clean up all generated placeholders
.PHONY: clean
clean:
	rm -f $(PLACEHOLDERS)
	rm -rf tmp
	rm -f static/fonts/chinese-font.woff2
