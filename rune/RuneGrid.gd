extends GridContainer



# Called when the node enters the scene tree for the first time.
func _ready():
	var n_child = get_child_count()
	for n in n_child:
		var rune = get_child(n) as Runestone
		rune.button_up.connect(_on_rune_click.bind(n, rune))

func _on_rune_click(order: int, rune: Runestone):
	var above = order - columns
	above = above if above >= 0. else -1
	var below = order + columns
	below = below if below < get_child_count() else -1
	var row = order/columns
	var left = (order - 1)
	left = left if left/columns == row else -1
	var right = (order + 1)
	right = right if right/columns == row else -1
	
	if right >= 0:
		(get_child(right) as Runestone).side_glow()
	if left >= 0:
		(get_child(left) as Runestone).side_glow()
	
#	print("clicking " + str(order) + " on row " + str(row))
#	print(str("   ", above, "   "))
#	print(str(left ,"  ", order, "  ", right))
#	print(str("   ", below, "   "))
