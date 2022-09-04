module main

import snake { Direction, Vec2, Game, Snake }

import gg
import gx

const(
	screen_width = 400
	screen_height = 400
	back_ground_color = gx.rgb(50, 100,100)
)

fn main() {
	mut game := Game{}

	game.ctx = gg.new_context(
		user_data: &game
		bg_color: back_ground_color
		width: screen_width
		height: screen_height
		window_title: 'Vnake'
		frame_fn: frame
	)
	game.spawn_food()

	game.ctx.run()
}



fn frame(mut g Game) {
	g.ctx.begin()

	g.update()
	g.draw()
	
	g.ctx.end()
}
