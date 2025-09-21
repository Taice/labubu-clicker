package main

import "core:fmt"
import "core:math"
import "core:strings"

import rl "vendor:raylib"

click_upgrade := 1
labubus_per_click := 1

click_upgrade_f :: proc(x: int) -> int {
	return pow_int(3, x - 1) * 300
}

pow_int :: proc(base: int, exp: int) -> (ret: int) {
	ret = 1

	for x in 0 ..< exp {
		ret *= base
	}
	return
}

BUTTON_SIZE :: 20.0

upgrades :: proc(bounds: rl.Rectangle) {
	// rl.DrawRectangleLinesEx(bounds, 1, rl.WHITE)

	click_pos: [2]f32

	click_size := [2]f32{100, 20}

	price := click_upgrade_f(click_upgrade)

	buf: [len("Upgrade Click ()") + 15]u8
	s := cstring(raw_data(fmt.bprintf(buf[:], "Upgrade Click(%d)", price)))

	size_x := f32(rl.MeasureText(s, 20))
	click_size.x = size_x + 4

	click_rec := rl.Rectangle{0, 0, click_size.x, click_size.y}

	if button(
		labubu_counter >= click_upgrade_f(click_upgrade),
		s,
		"Multiplies labubus-per-click by 2",
		click_rec,
	) {
		labubu_counter -= price
		click_upgrade += 1
		labubus_per_click *= 2
	}
}

abs_diff :: proc(a: $T, b: T) -> T {
	if a > b {
		return a - b
	} else {
		return b - a
	}
}

button :: proc(
	cond: bool,
	text: cstring,
	description: string,
	bounds: rl.Rectangle,
) -> (
	clicked: bool,
) {
	color: rl.Color = rl.RED
	if (cond) {
		color = rl.GREEN
	}
	if (rl.CheckCollisionPointRec(rl.GetMousePosition(), bounds)) {
		if rl.IsMouseButtonPressed(.LEFT) && cond {
			clicked = true
		} else {
			color.a -= 50
		}
	}

	rl.DrawRectangleRounded(bounds, 0.5, 10, color)

	draw_text_centered(rl.GetFontDefault(), text, 20, bounds, rl.WHITE)

	mouse_pos := rl.GetMousePosition()

	if rl.CheckCollisionPointRec(mouse_pos, bounds) {
		desc_rec := rl.Rectangle{mouse_pos.x, mouse_pos.y, 300, 150}

		draw_description(description, desc_rec)
	}

	return
}

draw_description :: proc(text: string, bounds: rl.Rectangle) {
	rl.DrawRectangleRounded(bounds, 0.15, 10, rl.BLACK)
	rl.DrawRectangleRoundedLinesEx(bounds, 0.15, 10, 2, rl.WHITE)
	text_bounds := bounds
	text_bounds.x += 6
	text_bounds.width -= 12
	text_bounds.y += 2
	text_bounds.height -= 4
	draw_text_in_bounds(rl.GetFontDefault(), text, 20, 2, text_bounds, rl.WHITE)
}

draw_text_in_bounds :: proc(
	font: rl.Font,
	text: string,
	font_size, spacing: f32,
	bounds: rl.Rectangle,
	color: rl.Color,
) {
	pos := [2]f32{bounds.x, bounds.y}
	scale := font_size / f32(font.baseSize)

	words := strings.split(text, " ")
	defer delete(words)

	for word in words {
		w := measure_string(font, font_size, spacing, word)
		if pos.x + w > bounds.x + bounds.width {
			pos.y += font_size + 1
			pos.x = bounds.x

			if pos.y + font_size > bounds.y + bounds.height {
				return
			}
		}
		draw_string(font, font_size, spacing, word, pos, rl.WHITE)
		SPACE_SIZE :: 10
		pos.x += w + spacing + SPACE_SIZE

	}
}

measure_string :: proc(font: rl.Font, font_size, spacing: f32, text: string) -> (width: f32) {
	scale := font_size / f32(font.baseSize)

	for x in text {
		r := rune(x)
		glyph := font.glyphs[rl.GetGlyphIndex(font, r)]

		width += f32(glyph.image.width) * scale + spacing
	}

	return
}

draw_string :: proc(
	font: rl.Font,
	font_size, spacing: f32,
	text: string,
	pos: [2]f32,
	color: rl.Color,
) -> (
	width: f32,
) {
	pos := pos

	scale := font_size / f32(font.baseSize)

	for x in text {
		r := rune(x)
		glyph := font.glyphs[rl.GetGlyphIndex(font, r)]

		rl.DrawTextCodepoint(font, x, pos, font_size, color)

		pos.x += f32(glyph.image.width) * scale + spacing
		width += f32(glyph.image.width) * scale + spacing
	}

	return
}
