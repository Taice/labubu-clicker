package main

import "core:fmt"
import "core:strings"
import rl "vendor:raylib"

UpgradeKind :: enum {
	Click,
	Tiktok,
}

Upgrade :: struct {
	count:       int,
	price:       int,
	lps:         int,
	description: string,
	name:        cstring,
	kind:        UpgradeKind,
}

upgrades: []Upgrade = {click_upgrade, tiktok_upgrade}

do_upgrades :: proc() {
	bounds := rl.Rectangle{0, 0, 200, 30}

	for &upg in upgrades {
		do_upgrade(&upg, bounds)
		bounds.y += bounds.height + 2
	}

	bounds = rl.Rectangle{0, 0, 200, 30}
	for &upg in upgrades {
		mpos := rl.GetMousePosition()
		if rl.CheckCollisionPointRec(mpos, bounds) {
			desc_rec := rl.Rectangle{mpos.x, mpos.y, 350, 0}
			desc_rec.height = measure_text_height(rl.GetFontDefault(), 20, 2, upg.description, 350)
			desc_rec.width += 8
			desc_rec.height += 4
			draw_description(upg.description, desc_rec)
		}
		bounds.y += bounds.height + 2
	}
}

button :: proc(cond: bool, text: cstring, price: int, bounds: rl.Rectangle) -> (clicked: bool) {
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

	text_rec := bounds
	text_rec.width = bounds.width / 2

	draw_text_centered(rl.GetFontDefault(), text, 20, text_rec, rl.WHITE)

	price_rec := text_rec
	price_rec.x += price_rec.width

	buf: [20]u8

	s := fmt.bprintf(buf[:], "[%d]", price)

	cs := cstring(raw_data(s))

	draw_text_centered(rl.GetFontDefault(), cs, 20, price_rec, rl.WHITE)

	mouse_pos := rl.GetMousePosition()

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

measure_text_height :: proc(
	font: rl.Font,
	font_size, spacing: f32,
	text: string,
	max_x: f32,
) -> (
	height: f32,
) {
	pos: [2]f32
	scale := font_size / f32(font.baseSize)

	words := strings.split(text, " ")
	defer delete(words)

	for word in words {
		w := measure_string(font, font_size, spacing, word)
		if pos.x + w > max_x {
			pos.y += font_size + 1
			pos.x = 0
		}
		SPACE_SIZE :: 10
		pos.x += w + spacing + SPACE_SIZE
	}
	return pos.y + font_size
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

do_upgrade :: proc(upgrade: ^Upgrade, button_bounds: rl.Rectangle) {
	switch upgrade.kind {
	case .Tiktok:
		tiktok_update(upgrade)
		if button(tiktok_condition(upgrade), upgrade.name, upgrade.price, button_bounds) {
			buy_tiktok(upgrade)
		}
	case .Click:
		click_update(upgrade)
		if button(tiktok_condition(upgrade), upgrade.name, upgrade.price, button_bounds) {
			buy_click(upgrade)
		}
	}

}
