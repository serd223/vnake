module snake

import gx { Color, rgb }
import math { round }

const (
	snake_default_speed = 0.1
	snake_max_speed = 0.8
	snake_acceleration_multiplier = 0.000008
)

pub struct Snake {
mut:
	head_raw        Vec2 = Vec2{}
	head_last_frame Vec2 = Vec2{}
pub mut:
	speed	   f32       = snake_default_speed
	pos        []Vec2    = [Vec2{}]
	direction  Direction = Direction.stopped
	head_color Color     = gx.rgb(0, 255, 0)
	tail_color Color     = gx.rgb(0, 125, 0)
}

pub fn (mut s Snake) reset_pos() {
	s.head_raw = Vec2{}
	s.head_last_frame = Vec2{}
	s.pos.clear()
	s.pos << Vec2{}
	s.speed = snake_default_speed
	s.direction = Direction.stopped
}

fn (mut s Snake) move_tail() {
	if s.pos.len <= 1 { return }
	for i := s.pos.len - 1; i > 0; i-- {
		s.pos[i] = s.pos[i - 1]
	}
}

pub fn (mut s Snake) move() {
	mut moving := true
	rounded_x, rounded_y := f32(math.round(s.head_raw.x)), f32(math.round(s.head_raw.y))
	if s.head_last_frame.x == rounded_x && s.head_last_frame.y == rounded_y {
		moving = false
	} 
	s.head_last_frame.x = rounded_x
	s.head_last_frame.y = rounded_y

	match s.direction {
		.up    { s.head_raw.y -= s.speed }
		.down  { s.head_raw.y += s.speed }
		.left  { s.head_raw.x -= s.speed }
		.right { s.head_raw.x += s.speed }
		else{}
	}
	if moving {
		s.move_tail()
	}
	s.pos[0].x = rounded_x
	s.pos[0].y = rounded_y
}

pub fn (mut s Snake) append() {
	if s.pos.len < 1 {
		s.pos[0] = Vec2{}
		return
	}
	if s.pos.len == 1 {
		s.pos << match s.direction {
			.up      { Vec2{ x: s.pos[0].x, y: s.pos[0].y + 1} }
			.down    { Vec2{ x: s.pos[0].x, y: s.pos[0].y - 1} }
			.left    { Vec2{ x: s.pos[0].x + 1, y: s.pos[0].y} }
			.right   { Vec2{ x: s.pos[0].x - 1, y: s.pos[0].y} }
			.stopped { s.pos[0] }
		}
		return
	}

	s.pos << s.pos.last()
}