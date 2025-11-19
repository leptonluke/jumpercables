extends Control

var grabbed_slot_data: SlotData


@onready var playerinventory: PanelContainer = $playerinventory
@onready var grabbedslot: PanelContainer = $grabbedslot

func _physics_process(delta: float) -> void:
	if grabbedslot.visible:
		grabbedslot.global_position = get_global_mouse_position() + Vector2(5, 5)

func set_player_inventory_data(inventory_data: InventoryData) ->void:
	inventory_data.inventory_interact.connect(on_inventory_interact)
	playerinventory.set_inventory_data(inventory_data)

func on_inventory_interact(inventory_data: InventoryData, 
		index: int, button: int) ->void:
	
	match [grabbed_slot_data, button]:
		[null, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.grab_slot_data(index)
		[_, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.drop_slot_data(grabbed_slot_data, index)
		[null, MOUSE_BUTTON_RIGHT]:
			pass
		[_, MOUSE_BUTTON_RIGHT]:
			grabbed_slot_data = inventory_data.drop_single_slot_data(grabbed_slot_data, index)
	print(grabbed_slot_data)
 
	update_grabbed_slot()
	
	
func update_grabbed_slot() -> void:
	if grabbed_slot_data:
		grabbedslot.show()
		grabbedslot.set_slot_data(grabbed_slot_data)
	else:
		grabbedslot.hide()
