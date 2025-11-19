extends Node3D

@onready var player = $player
@onready var settings = $UI/settings
@onready var playerinterface: Control = $UInv/playerinterface

func  _ready() -> void:
	player.toggle_inventory.connect(toggle_inventory_interface)
	playerinterface.set_player_inventory_data(player.inventory_data)

func toggle_inventory_interface(external_inventory_owner = null)->void:
	playerinterface.visible = not playerinterface.visible
	
	if playerinterface.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
	if external_inventory_owner:
		playerinterface.set_external_inventory(external_inventory_owner)
