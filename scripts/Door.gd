extends Node3D

@onready var anim_player = $AnimationPlayer
#@onready var area = $Area3D

var is_open = false

func _ready():
	print("door.gd init")

func toggle_door():
	if is_open:
		anim_player.play("door_close")
	else:
		anim_player.play("door_open")
	is_open = !is_open
