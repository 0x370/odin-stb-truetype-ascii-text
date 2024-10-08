package main

import "core:c"
import "core:fmt"
import "core:os"

import tt "vendor:stb/truetype"

main :: proc() {
	font_data, err := os.read_entire_file_from_filename_or_err("C:/Windows/Fonts/arial.ttf")
    
    if err != nil {
		fmt.eprintf("Failed to load font:", err)
		return
    }

	font: tt.fontinfo
	if !tt.InitFont(&font, &font_data[0], 0) {
		fmt.eprintf("Failed to initialize font")
		return
	}

	scale := tt.ScaleForPixelHeight(&font, 12.0)
	glyph_index := tt.FindGlyphIndex(&font, 'a')

	width, height, x_off, y_off: c.int
	result := tt.GetGlyphBitmap(&font, scale, scale, glyph_index, &width, &height, &x_off, &y_off)

	for y: c.int = 0; y < height; y += 1 {
		for x: c.int = 0; x < width; x += 1 {
			pixel := result[y * width + x]
			if pixel > 128 {
				fmt.print("#")
			} else {
				fmt.print(" ")
			}
		}

		fmt.println("")
	}
}
