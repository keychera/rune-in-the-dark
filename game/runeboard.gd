extends GridContainer
class_name RuneBoard

var symbols : Array = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v"]
var board : Array = []

func _ready():
	var n_child = get_child_count()
	assert(n_child % 2 == 0)
	var rune_idxs = range(n_child)
	rune_idxs.shuffle()
	var symbol_idxs = range(symbols.size())
	symbol_idxs.shuffle()
	for n in n_child:
		var rune = get_child(rune_idxs[n]) as Rune
		var symbol_n = floor(n/2)
		var rand_symbol = symbols[symbol_idxs[symbol_n % symbols.size()]]
		rune.text = rand_symbol
		rune.button_up.connect(_on_rune_click.bind(rune))

var prev: Rune = null
func _on_rune_click(current : Rune):
	print("click " + current.text)
	if (prev != null):
		if (prev.text == current.text):
			prev.disabled = true
			current.disabled = true
	prev = current

func _process(delta):
	pass


