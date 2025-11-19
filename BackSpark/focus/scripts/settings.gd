extends Control


var gammavalue = 1
var base_fov = 75.0
var fov_change = 2.25
var menu_up = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
@onready var basemenu = $basemenu
@onready var camslider = $basemenu/VSlider
@onready var quit = $basemenu/Button
@onready var textest = $TextEdit
@onready var menuselection = 1
@onready var slidemenu = $slidemenu
@onready var Visuals = $visualscroll
@onready var audio = $audioscroll
@onready var graphics = $graphicscroll
@onready var control = $controlscroll
# Called when the node enters the scene tree for the first time.
func _ready():
	DisplayServer.window_set_size(Vector2i(1152, 684))
	DisplayServer.window_set_position(Vector2i(50,50))
	menu_up = false
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
 # or any node with visibility, such as a Sprite


func _process(_delta):
	if Input.is_action_just_pressed("escape"):
		if menu_up == true:
			hide()
			menu_up = false
		else:
			menu_up = true
			show()




func _on_volume_slider_value_changed(value):
	AudioServer. set_bus_volume_db(0, value)



func _on_resolution_item_selected(index):
	match index:
		0: DisplayServer.window_set_size(Vector2i(1920, 1080))

		1: DisplayServer.window_set_size(Vector2i(1600, 900))

		2: DisplayServer.window_set_size(Vector2i(1152, 648))

		3: DisplayServer.window_set_size(Vector2i(720, 600))

		4: DisplayServer.window_set_size(Vector2i(600, 540))

		5: DisplayServer.window_set_size(Vector2i(100, 50))


func _on_quit_pressed():
	get_tree().quit()

func _on_audio_pressed():
	settingsloop(true, false, false, false)

func _on_graphics_pressed():
	settingsloop(false, true, false, false)

func _on_visual_pressed():
	settingsloop(false, false, true, false)

func _on_controls_pressed():
	settingsloop(false, true, false, false)

func _on_fovtoggle_toggled(_toggled_on):
	if Autoload.fovtoggle == false:
		Autoload.fovtoggle =true
	else: Autoload.fovtoggle = false


func settingsloop(Aa, Bb, Cc, Dd):
	audio.visible = Aa
	graphics.visible = Bb
	Visuals.visible = Cc
	control.visible = Dd

func _on_headbobtoggle_toggled(_toggled_on):
	if Autoload.headbob == false:
		Autoload.headbob =true
	else: Autoload.headbob = false



func _on_fullscreen_toggled(toggled_on):
	if  toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_position(Vector2i(200,200))

func game_quality():
	pass
