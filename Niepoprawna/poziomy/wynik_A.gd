extends Control

func _ready():
	$VBoxContainer/VBoxContainer/retry.grab_focus()
	for button in $VBoxContainer/VBoxContainer.get_children():
		button.connect("pressed", self, "_on_Button_pressed", [button.scene_to_load])

func _on_Button_pressed(scene_to_load):
	get_tree().change_scene(scene_to_load)

