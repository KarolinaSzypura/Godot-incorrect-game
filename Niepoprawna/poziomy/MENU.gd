extends MarginContainer

func _ready():
	$HBoxContainer/VBoxContainer/menu_options/new_game.grab_focus()
	for button in $HBoxContainer/VBoxContainer/menu_options.get_children():
		button.connect("pressed", self, "_on_Button_pressed", [button.scene_to_load])

func _on_Button_pressed(scene_to_load):
	get_tree().change_scene(scene_to_load)
