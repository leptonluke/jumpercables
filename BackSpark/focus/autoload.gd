extends Node3D

@onready var settings = $"../UI/settings"
@onready var player = $"../player"

var headbob = true
var fovtoggle = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
