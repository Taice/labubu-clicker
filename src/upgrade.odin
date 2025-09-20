package main

import "core:fmt"
import "core:math"
import "core:strings"

import rl "vendor:raylib"

click_upgrade := 1

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

draw_upgrades :: proc(bounds: rl.Rectangle) {
	rl.DrawRectangleLinesEx(bounds, 1, rl.WHITE)

	click_pos: [2]f32

	click_size := [2]f32{100, 20}

	color: rl.Color = rl.RED
	u := click_upgrade_f(click_upgrade)
	fmt.println(u)
	if (labubu_counter >= u) {
		color = rl.GREEN
	}
	rl.DrawRectangleV(click_pos, click_size, color)
	buf: [len("Upgrade Click ()") + 5]u8
	s := cstring(raw_data(fmt.bprintf(buf[:], "Upgrade Click(%d)", click_upgrade)))
	rl.DrawTextEx(rl.GetFontDefault(), s, 20, {0, 0, click_size.x, click_size.y}, rl.WHITE)
}

upd_upgrades :: proc() {
}

abs_diff :: proc(a: $T, b: T) -> T {
	if a > b {
		return a - b
	} else {
		return b - a
	}
}
