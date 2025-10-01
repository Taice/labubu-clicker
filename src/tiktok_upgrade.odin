package main

import "core:math"
import rl "vendor:raylib"

tiktok_upgrade: Upgrade = {
	count       = 0,
	price       = 1000,
	lps         = 0,
	on_click    = buy_tiktok,
	condition   = tiktok_condition,
	update      = tiktok_update,
	name        = "Tiktok",
	description = "Make a Tiktok page",
}

tiktok_upgrade_price :: proc(tt: ^Upgrade) -> int {
	return int((math.pow(max(1, f32(tt.count)), 1.5) * 1000))
}

buy_tiktok :: proc(tt: ^Upgrade) {
	if int(labubu_counter) >= tt.price {
		labubu_counter -= f32(tt.price)
		tt.count += 1
		tt.price = tiktok_upgrade_price(tt)
		tt.lps = get_tiktok_lps(tt)
	}
}

get_tiktok_lps :: proc(tt: ^Upgrade) -> int {
	return int(math.pow_f32(f32(tt.count), 1.3) * 10)
}

tiktok_condition :: proc(tt: ^Upgrade) -> bool {
	return tt.price <= int(labubu_counter)
}

tiktok_update :: proc(tt: ^Upgrade) {
	labubu_counter += f32(tt.lps) * rl.GetFrameTime()
}
