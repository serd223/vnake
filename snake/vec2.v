module snake

pub struct Vec2 {
pub mut:
	x f32
	y f32
}

/// Returns true if both are the same
pub fn (v Vec2) compare(v2 Vec2) bool {
	return (v.x == v2.x && v.y == v2.y)
}