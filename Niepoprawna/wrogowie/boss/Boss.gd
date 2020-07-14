extends KinematicBody2D

export var EnemySpeed = 40
export var Gravity = 8

var EnemyMotion = Vector2( )
var EnemyDirection = 1
var UP = Vector2(0,-1)
var OpositeDirection = -1
var zabity = false
onready var czasomierz_smierci = get_node("czas_smierci")
var czas_smierci = 0.3
var czasomierz_krzywdy = true
var health = 2

func _ready():
	set_physics_process(true)
	czasomierz_smierci.set_wait_time(czas_smierci)
	
func _physics_process(delta):
	
	if is_on_wall() or $RayCast_floor.is_colliding() == false:
		EnemyDirection = EnemyDirection * OpositeDirection
	
	if EnemyDirection == 1:
		$AnimatedSprite.flip_h = true
		$RayCast_floor.position.x *= -1
		$RayCast_enemy.scale.x *= -1
	else:
		$AnimatedSprite.flip_h = false
		$RayCast_floor.position.x *= -1
		$RayCast_enemy.scale.x *= -1
	
	if zabity == false:
		if $RayCast_enemy.is_colliding():
			var collider = $RayCast_enemy.get_collider()
			var player = get_parent().get_parent().get_node("Player")
			if collider == player and czasomierz_krzywdy == true:
				czasomierz_krzywdy = false
				player.health -= 1
				player.Take_damage()
				yield(get_tree().create_timer(0.5), "timeout")
				czasomierz_krzywdy = true
		$AnimatedSprite.play("idzie")
		EnemyMotion.x = EnemyDirection * EnemySpeed
		move_and_slide(EnemyMotion, UP)
	pass

func zestrzelony():
	$AnimatedSprite.play("wywrotka")
	health -= 1
	zabity = true
	czasomierz_smierci.start()
	if health <= 0:
		var player = get_parent().get_parent().get_node("Player")
		player.score_enemy += 1
		queue_free()
	yield(czasomierz_smierci, "timeout")
	zabity = false