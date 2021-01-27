extends Node2D


onready var timer := get_node('timer')
onready var nuke := get_node('nuke')
onready var tween: Tween = get_node('tween')
onready var message := get_node('message')
#onready var song := get_node('audio')


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.connect('timeout', self, 'start_nuke')
	timer.wait_time = 7
	timer.one_shot = true
	timer.start()
#	song.play()


func show_message():
	message.visible = true


func start_nuke():
	nuke.visible = true
	tween.interpolate_property(nuke, 'scale', \
		Vector2(0.01, 0.01), Vector2(1.0, 1.0), \
		60, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()

	timer.disconnect('timeout', self, 'start_nuke')
	timer.connect('timeout', self, 'show_message')
	timer.wait_time = 10
	timer.one_shot = true
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
