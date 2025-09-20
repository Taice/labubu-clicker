package main

import "core:fmt"
import "core:math"
import "core:strings"
import rl "vendor:raylib"

labubu_counter: int = 0

screen_size: [2]f32

sb: strings.Builder

main :: proc() {
	sb = strings.builder_make()
	defer strings.builder_destroy(&sb)

	rl.SetConfigFlags({.WINDOW_RESIZABLE})
	rl.InitWindow(500, 500, "labubu clicker")
	defer rl.CloseWindow()

	rl.SetTargetFPS(60)

	labubu := make_labubu(rl.LoadTexture("assets/labubu.png"))

	for !rl.WindowShouldClose() {
		screen_size = {f32(rl.GetScreenWidth()), f32(rl.GetScreenHeight())}

		upd_labubu(&labubu)

		rl.BeginDrawing()
		defer rl.EndDrawing()
		rl.ClearBackground(rl.BLACK)

		draw_labubu(&labubu)

		clear(&sb.buf)
		strings.write_int(&sb, labubu_counter)
		labubu_count := strings.to_cstring(&sb)

		draw_text_centered(
			rl.GetFontDefault(),
			labubu_count,
			20,
			{0, 0, f32(rl.GetScreenWidth()), 40},
			rl.WHITE,
		)

		draw_upgrades({0, 0, labubu_pos.x, screen_size.y})
	}
}

draw_text_centered :: proc(
	font: rl.Font,
	text: cstring,
	font_size: f32,
	bounds: rl.Rectangle,
	color: rl.Color,
) {
	bs := [2]f32{bounds.width, bounds.height}
	size := rl.MeasureTextEx(font, text, font_size, f32(font.glyphPadding) + 1)

	top_left := (bs - size) / 2

	rl.DrawTextEx(font, text, top_left, font_size, f32(font.glyphPadding) + 1, color)
}
