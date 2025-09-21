package main

import "core:fmt"
import "core:math/rand"
import "core:strings"
import "core:time"
import rl "vendor:raylib"

screen_center := [2]f32{}
labubu_pos := [2]f32{}

particles: [dynamic]Particle

Particle :: struct {
	pos:   [2]f32,
	val:   int,
	alpha: f32,
}

draw_particles :: proc() {
	for particle in particles {
		sb := strings.builder_make()
		defer strings.builder_destroy(&sb)

		strings.write_int(&sb, particle.val)
		cstr := strings.to_cstring(&sb)

		color := rl.WHITE
		color.a = u8(particle.alpha)
		black := rl.BLACK
		black.a = color.a
		rl.DrawTextEx(rl.GetFontDefault(), cstr, particle.pos, 20, 2, color)
	}
}

PARTICLE_LIFE :: 0.5

upd_particles :: proc() {
	#reverse for &particle, i in particles {
		particle.alpha -= 255 / PARTICLE_LIFE * rl.GetFrameTime()
		if particle.alpha < 0 {
			unordered_remove(&particles, i)
		}
		particle.pos.y -= 50 * rl.GetFrameTime()
	}
}

make_particle :: proc(pos: [2]f32) -> Particle {
	pos := pos
	pos.y -= 10
	pos.x -= 2
	pos += rand.float32_range(-5, 5)
	return {alpha = 255, val = labubus_per_click, pos = pos}
}

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

labubu_on_click :: proc(labubu: ^Labubu, mouse_pos: [2]f32) {
	labubu.src_size = BASE_SIZE
	labubu.dst_size = CLICKED_SIZE

	labubu_counter += labubus_per_click

	append(&particles, make_particle(mouse_pos))
}

upd_labubu :: proc(labubu: ^Labubu) {
	screen_center = {f32(rl.GetScreenWidth()) / 2, f32(rl.GetScreenHeight()) / 2}
	labubu_pos = screen_center - labubu.size / 2

	mouse_pos := rl.GetMousePosition()

	if rl.IsKeyPressed(.SPACE) {
		labubu_on_click(labubu, mouse_pos)
	}
	if rl.IsKeyReleased(.SPACE) {
		labubu.src_size = CLICKED_SIZE
		labubu.dst_size = BASE_SIZE
	}
	if rl.IsMouseButtonPressed(.LEFT) {

		labubu_rec := rl.Rectangle{labubu_pos.x, labubu_pos.y, labubu.size.x, labubu.size.y}
		if rl.CheckCollisionPointRec(mouse_pos, labubu_rec) {
			labubu_on_click(labubu, mouse_pos)
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

	upd_particles()
}

draw_labubu :: proc(labubu: ^Labubu) {
	src := rl.Rectangle{0, 0, f32(labubu.texture.width), f32(labubu.texture.height)}

	dst := rl.Rectangle{labubu_pos.x, labubu_pos.y, labubu.size.x, labubu.size.y}
	rl.DrawTexturePro(labubu.texture, src, dst, {}, 0.0, rl.WHITE)

	draw_particles()
}
