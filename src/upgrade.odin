package main

import "core:fmt"
import "core:math"
import "core:strings"

import rl "vendor:raylib"

click_upgrade := 1
labubus_per_click := 1

click_upgrade_f :: proc(x: int) -> int {
	return pow_int(3, x - 1) * 3 // 00
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

	buf: [len("Upgrade Click ()") + 5]u8
	s := cstring(raw_data(fmt.bprintf(buf[:], "Upgrade Click(%d)", click_upgrade)))

	size_x := f32(rl.MeasureText(s, 20))
	click_size.x = size_x + 4

	click_rec := rl.Rectangle{0, 0, click_size.x, click_size.y}

	color: rl.Color = rl.RED
	if (labubu_counter >= price) {
		color = rl.GREEN
	}
	if (rl.CheckCollisionPointRec(rl.GetMousePosition(), click_rec)) {
		if rl.IsMouseButtonPressed(.LEFT) && labubu_counter >= price {
			labubu_counter -= price
			click_upgrade += 1
            labubus_per_click *= 2
		} else {
			color.a -= 50
		}
	}

	rl.DrawRectangleRounded(click_rec, 0.5, 10, color)

	draw_text_centered(rl.GetFontDefault(), s, 20, click_rec, rl.WHITE)
}

abs_diff :: proc(a: $T, b: T) -> T {
	if a > b {
		return a - b
	} else {
		return b - a
	}
}
