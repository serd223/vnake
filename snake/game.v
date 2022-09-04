module snake

import gg { Context }
import gx { Color, rgb }
import rand { int_in_range }

pub struct Game {
pub mut:
	ctx        &gg.Context  = 0
	player     Snake        = Snake{}
	food_pos   Vec2         = Vec2{}
	food_color gx.Color     = gx.rgb(255, 0, 0)
	map_size   Vec2         = Vec2{x: 16, y: 16}
	game_over  bool
	high_score u32
	score 	   u32
}

pub fn (mut g Game) update() {
	pressed_keys := g.ctx.pressed_keys
	if pressed_keys[gg.KeyCode.up] {
		g.player.direction = Direction.up
	}
	if pressed_keys[gg.KeyCode.down] {
		g.player.direction = Direction.down
	}
	if pressed_keys[gg.KeyCode.left] {
		g.player.direction = Direction.left
	}
	if pressed_keys[gg.KeyCode.right] {
		g.player.direction = Direction.right
	}
	
	if pressed_keys[gg.KeyCode.r] && g.game_over{
		g.player.reset_pos()
		g.spawn_food()
		g.game_over = false
	}

	if g.game_over {
		if g.score > g.high_score {
			g.high_score = g.score
		}
		g.player.direction = Direction.stopped
	}
	
	g.player.move()
	
	player_head := g.player.pos[0]
	if player_head.compare(g.food_pos) {
		g.player.append()
		g.player.speed += f32(g.player.pos.len * (g.player.pos.len - 1)) * snake_acceleration_multiplier
		if g.player.speed > snake_max_speed {
			g.player.speed = snake_max_speed
		}
		g.spawn_food()
	}

	for pos in g.player.pos[1..] {
		if player_head.compare(pos) {
			g.game_over = true
			break
		}
	}
	
	if player_head.x < 0 || player_head.x >= g.map_size.x || player_head.y < 0 || player_head.y >= g.map_size.y {
		g.game_over = true
	}
	
	g.score = u32(g.player.pos.len - 1)
}

pub fn (g Game) draw() {

	w_size := g.ctx.window_size()
	cell_w, cell_h := f32(w_size.width) / g.map_size.x, f32(w_size.height) / g.map_size.y
	spos := g.player.pos
	for i, pos in spos {
		raw_x, raw_y := pos.x * cell_w, pos.y * cell_h
		mut color := g.player.tail_color
		if i == 0 {
			color = g.player.head_color
		}
		g.ctx.draw_rect_filled(raw_x, raw_y, cell_w, cell_h, color)
	}
	g.ctx.draw_rect_filled(
		g.food_pos.x * cell_w, g.food_pos.y * cell_h,
		cell_w, cell_h, g.food_color
	)

	if g.game_over {
		try_again_text := "Press [R] to try again."
		score_text := "Score: $g.score  |  High Score: $g.high_score"
		ta_text_width, ta_text_height := g.ctx.text_size(try_again_text)
		score_text_width, score_text_height := g.ctx.text_size(score_text)
		g.ctx.draw_text_def(
			g.ctx.window_size().width / 2 - ta_text_width / 2,
			g.ctx.window_size().height / 2 + ta_text_height / 2,
			try_again_text
		)
		g.ctx.draw_text_def(
			g.ctx.window_size().width / 2 - score_text_width / 2,
			g.ctx.window_size().height / 2 + score_text_height * 2,
			score_text
		)
	}
}

pub fn (mut g Game) spawn_food() {
	mut fpos := Vec2{}
	mut done := false
	for !done {
		fpos.x = int_in_range(0, int(g.map_size.x)) or { 0 }
		fpos.y = int_in_range(0, int(g.map_size.y)) or { 0 }
		
		done = true
		for pos in g.player.pos {
			if fpos.compare(pos) {
				done = false
				break
			}
		}
	}
	g.food_pos = fpos
}