package main

import "core:fmt"
import "core:io"
import "core:os"
import "core:strings"
import "core:testing"
import rl "vendor:raylib"

Settings :: [2]rl.KeyboardKey

default_settings :: Settings{.X, .Z}

load_settings :: proc(filename: string) -> (settings: Settings, ok: bool) {
	file, o := os.read_entire_file(filename)
	if !o {
		ok = false
		return
	}
	defer delete(file)

	return parse_settings(string(file))
}

parse_settings :: proc(s: string) -> (settings: Settings = default_settings, ok: bool) {
	lines := strings.split(s, "\n")
	defer delete(lines)

	for line in lines {
		k, v, o := parse_line(line)
		if !o {
			continue
		}

		switch k {
		case "key1", "k1":
			val := v[0]
			if val >= 'a' && val <= 'z' {
				val -= 32
			}
			if val < 'A' || val > 'Z' {
				fmt.eprintln("Value out of bounds", rune(val))
				return
			}
			settings[0] = cast(rl.KeyboardKey)val
		case "key2", "k2":
			val := v[0]
			if val >= 'a' && val <= 'z' {
				val -= 32
			}
			if val < 'A' || val > 'Z' {
				fmt.eprintln("Value out of bounds", rune(val))
				return
			}
			settings[1] = cast(rl.KeyboardKey)val
		case:
			fmt.eprintln("Invalid token", k)
			return
		}
	}

	ok = true
	return
}

@(test)
odin_parse_test :: proc(T: ^testing.T) {
	res, ok := parse_settings("key1 = a\nk2 = b")
	testing.expect(T, ok)
	testing.expect(T, res == Settings{.A, .B})
}

parse_line :: proc(line: string) -> (token: string, value: string, ok: bool) {
	for ch, i in line {
		if ch == '=' {
			token = strings.trim_space(line[:i])
			value = strings.trim_space(line[i + 1:])
			fmt.println(token)
			fmt.println(value)
			ok = true
			return
		}
	}
	return
}
