# Makefile to generate blurred placeholders for .webp images

# Find all .webp files excluding cover.webp
WEBP_IMAGES := $(shell find content -type f -name "*.webp" ! -name "cover.webp" ! -name "*-placeholder.webp")

# Generate placeholder names (replace .webp with -placeholder.webp)
PLACEHOLDERS := $(WEBP_IMAGES:.webp=-placeholder.webp)

# Default target
all: $(PLACEHOLDERS)

# Rule to convert image.webp to image-placeholder.webp
%-placeholder.webp: %.webp
	magick "$<" -resize 400x -blur 0x6 "$@"

# Clean up all generated placeholders
clean:
	rm -f $(PLACEHOLDERS)
