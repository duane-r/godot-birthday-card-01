extends Node2D


onready var cak := get_node('cake')
onready var grid := get_node('cake/TileMap')
onready var timer := get_node('cake/Timer')
onready var flash := get_node('flash')


const EXTRA_TICKS := 50.0


var can_cells := {}
var disconn := false
var extra_ticks := 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#	var cct := 0
	for y in range(-20, 21):
		for x in range(-20, 21):
			if grid.get_cell(x, y) == 0:
#				cct += 1
				can_cells[Vector2(x, y)] = true
				grid.set_cell(x, y, -1)
#	printt('count', cct)

	timer.connect('timeout', self, 'place_candle')
	timer.wait_time = 2
	timer.one_shot = false
	timer.start()


func blow_up():
	get_tree().change_scene("res://Satellite.tscn")


func place_candle():
	if disconn:
		return

	if can_cells.empty() and extra_ticks > 100:
		disconn = true
		timer.disconnect('timeout', self, 'place_candle')
		timer.stop()
		timer.connect('timeout', self, 'blow_up')
		timer.wait_time = 0.5
		timer.one_shot = true
		timer.start()
	elif can_cells.empty():
		extra_ticks += 1
		flash.modulate = Color(1, 1, 1, (98.0 + extra_ticks) / (98.0 + EXTRA_TICKS))
	else:
		var k := can_cells.keys()
		var p: Vector2 = k[randi() % len(k)]
		can_cells.erase(p)
		grid.set_cellv(p, 0)
		timer.wait_time *= 0.9
		flash.modulate = Color(1, 1, 1, (98.0 - len(k)) / (98.0 + EXTRA_TICKS))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
