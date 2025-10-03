package main

labubu_file := #load("../assets/labubu.png", []u8)

import "core:fmt"
import "core:math"
import "core:strings"
import rl "vendor:raylib"

labubu_counter: f32 = 0

labubus_per_click: int = 1

screen_size: [2]f32

sb: strings.Builder

main :: proc() {
	sb = strings.builder_make()
	defer strings.builder_destroy(&sb)

	particles = make([dynamic]Particle)
	defer delete(particles)

	rl.SetConfigFlags({.WINDOW_RESIZABLE})
	rl.InitWindow(500, 500, "labubu clicker")
	defer rl.CloseWindow()

	rl.SetTargetFPS(240)

	img := rl.LoadImageFromMemory(".png", raw_data(labubu_file), i32(len(labubu_file)))
	defer rl.UnloadImage(img)
	labubu := make_labubu(rl.LoadTextureFromImage(img))
	defer rl.UnloadTexture(labubu.texture)

	for !rl.WindowShouldClose() {
		screen_size = {f32(rl.GetScreenWidth()), f32(rl.GetScreenHeight())}

		upd_labubu(&labubu)

		rl.BeginDrawing()
		defer rl.EndDrawing()
		rl.ClearBackground(rl.BLACK)


		draw_labubu(&labubu)

		buf: [20]u8
		labubu_count := cstring(raw_data(fmt.bprint(buf[:], labubu_counter)))

		draw_text_centered(
			rl.GetFontDefault(),
			labubu_count,
			20,
			{0, 0, f32(rl.GetScreenWidth()), 40},
			rl.WHITE,
		)

		do_upgrades()
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
	top_left += {bounds.x, bounds.y}
	top_left.x = math.round(top_left.x)
	top_left.y = math.round(top_left.y)

	rl.DrawTextEx(font, text, top_left, font_size, f32(font.glyphPadding) + 1, color)
}
