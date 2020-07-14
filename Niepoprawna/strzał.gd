extends Area2D

var SPEED = 200
var velocity = Vector2(0,0)
var direction = -1

func _ready():
	pass

func _physics_process(delta):
	velocity.x = direction * SPEED * delta
	translate(velocity)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_strza_body_entered(body):
	if body is KinematicBody2D:
		body.zestrzelony()
	queue_free()
