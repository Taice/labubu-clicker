package main

import "core:math"
import rl "vendor:raylib"

click_upgrade: Upgrade = {
	count       = 0,
	price       = 300,
	lps         = 0,
	on_click    = buy_click,
	condition   = click_condition,
	update      = click_update,
	name        = "Click",
	description = "Multiplies labubus-per-click by 2 and a half",
}

click_upgrade_price :: proc(cu: ^Upgrade) -> int {
	return int(math.pow_f32(3, f32(cu.count) - 1) * 300)
}

buy_click :: proc(cu: ^Upgrade) {
	labubu_counter -= f32(cu.price)
	cu.count += 1
	labubus_per_click *= 2
	cu.price = click_upgrade_price(cu)
}

get_click_lps :: proc(cu: ^Upgrade) -> int {
	return int(math.pow_f32(f32(cu.count), 1.3) * 10)
}

click_condition :: proc(cu: ^Upgrade) -> bool {
	return cu.price <= int(labubu_counter)
}

click_update :: proc(cu: ^Upgrade) {
	labubu_counter += f32(cu.lps) * rl.GetFrameTime()
}
