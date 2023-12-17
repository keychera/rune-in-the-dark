extends GridContainer

const symbols : Array = [1, 2, 3, 4, 5, 6, 7, 8]

func _ready():
	var n_child = get_child_count()
	assert(n_child % 2 == 0)
	var rune_idxs = range(n_child)
	rune_idxs.shuffle()
	var symbol_idxs = range(symbols.size())
	symbol_idxs.shuffle()
	for n in n_child:
		var idx = rune_idxs[n]
		var rune = get_child(idx) as Runestone
		var symbol_n = floor(n/2)
		var rand_symbol = symbols[symbol_idxs[symbol_n % symbols.size()]]
		rune.order = idx
		rune.set_symbol(rand_symbol)
		rune.button_up.connect(_on_rune_click.bind(rune))

func _modify_dark_grid():
	var dark_grid = get_node("/root/game2/dark_grid")
	await get_tree().create_timer(0.1).timeout # why
	dark_grid.size = size
	dark_grid.size.y += 8
	dark_grid.position = position
	dark_grid.position.y -= 4
	
var prev: Runestone = null

func toggle_rune_neighbor(rune: Runestone, active: bool):
	var order = rune.order
	var above = order - columns
	above = above if above >= 0. else -1
	var below = order + columns
	below = below if below < get_child_count() else -1
	var row = order/columns
	var left = (order - 1)
	left = left if left/columns == row else -1
	var right = (order + 1)
	right = right if right/columns == row else -1
	
#	print("toggling " + str(order) + " on row " + str(row))
#	print(str("   ", above, "   "))
#	print(str(left ,"  ", order, "  ", right))
#	print(str("   ", below, "   "))

	var id = rune.get_instance_id()
	if active:
		if above >= 0:
			(get_child(above) as Runestone).side_glow(id, Vector2(0., 1.))
		if below >= 0:
			(get_child(below) as Runestone).side_glow(id, Vector2(0., -1.))
		if right >= 0:
			(get_child(right) as Runestone).side_glow(id, Vector2(-1., 0.))
		if left >= 0:
			(get_child(left) as Runestone).side_glow(id, Vector2(1., 0.))
	else:
		if above >= 0:
			(get_child(above) as Runestone).deglow(id)
		if below >= 0:
			(get_child(below) as Runestone).deglow(id)
		if right >= 0:
			(get_child(right) as Runestone).deglow(id)
		if left >= 0:
			(get_child(left) as Runestone).deglow(id)

func _on_rune_click(rune: Runestone):
	rune.toggle_active()
	toggle_rune_neighbor(rune, rune.active)

	if (prev != null):
		if(prev.get_instance_id() != rune.get_instance_id()):
			if (prev.symbol_n == rune.symbol_n):
				prev.toggle_done()
				rune.toggle_done()
			else:
				prev.toggle_active()
				rune.toggle_active()
				toggle_rune_neighbor(prev, false)
				toggle_rune_neighbor(rune, false)
			prev = null
		else:
			if !prev.active:
				prev = null
	else:
		prev = rune

func _on_restart_button_button_up():
	var n_child = get_child_count()
	assert(n_child % 2 == 0)
	var rune_idxs = range(n_child)
	rune_idxs.shuffle()
	var symbol_idxs = range(symbols.size())
	symbol_idxs.shuffle()
	for n in n_child:
		var idx = rune_idxs[n]
		var rune = get_child(idx) as Runestone
		var symbol_n = floor(n/2)
		var rand_symbol = symbols[symbol_idxs[symbol_n % symbols.size()]]
		rune.set_symbol(rand_symbol)
		if(rune.active):
			rune.toggle_active()
			toggle_rune_neighbor(rune, false)
		else:
			rune.toggle_active(false)
		rune.toggle_done(false)
	
	prev = null
	
