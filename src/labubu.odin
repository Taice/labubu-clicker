package main

import "core:fmt"
import rl "vendor:raylib"

screen_center := [2]f32{}
labubu_pos := [2]f32{}

Labubu :: struct {
	size:     [2]f32,
	src_size: [2]f32,
	dst_size: [2]f32,
	texture:  rl.Texture,
}

BASE_SIZE :: 300.0
CLICKED_SIZE :: 350.0

make_labubu :: proc(texture: rl.Texture) -> (labubu: Labubu) {
	labubu.size = {300, 300}
	labubu.src_size = {300, 300}
	labubu.dst_size = {300, 300}
	labubu.texture = texture
	return
}

upd_labubu :: proc(labubu: ^Labubu) {
	screen_center = {f32(rl.GetScreenWidth()) / 2, f32(rl.GetScreenHeight()) / 2}
	labubu_pos = screen_center - labubu.size / 2

	if rl.IsMouseButtonPressed(.LEFT) {
		mouse_pos := rl.GetMousePosition()

		labubu_rec := rl.Rectangle{labubu_pos.x, labubu_pos.y, labubu.size.x, labubu.size.y}
		if rl.CheckCollisionPointRec(mouse_pos, labubu_rec) {
			labubu.src_size = BASE_SIZE
			labubu.dst_size = CLICKED_SIZE

			labubu_counter += click_upgrade
		}
	}
	if rl.IsMouseButtonReleased(.LEFT) {
		labubu.src_size = CLICKED_SIZE
		labubu.dst_size = BASE_SIZE
	}

	if labubu.size != labubu.dst_size {
		delta := labubu.dst_size - labubu.src_size
		delta *= rl.GetFrameTime() * 30

		labubu.size += delta
		if (labubu.dst_size.x > labubu.src_size.x && labubu.size.x > labubu.dst_size.x) ||
		   (labubu.dst_size.x < labubu.src_size.x && labubu.size.x < labubu.dst_size.x) {
			labubu.size = labubu.dst_size
		}
	}

	labubu_pos = screen_center - labubu.size / 2
}

draw_labubu :: proc(labubu: ^Labubu) {
	src := rl.Rectangle{0, 0, f32(labubu.texture.width), f32(labubu.texture.height)}

	dst := rl.Rectangle{labubu_pos.x, labubu_pos.y, labubu.size.x, labubu.size.y}
	rl.DrawTexturePro(labubu.texture, src, dst, {}, 0.0, rl.WHITE)
}
