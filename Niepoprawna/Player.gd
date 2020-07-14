extends KinematicBody2D

const UP = Vector2(0,-1)
const GRAVITY = 20
const SPEED = 100
const JUMP = -300
var screen_size
var velocity = Vector2()
var once = false
var right
var pozycja_strzalu

var score_money = 0
var score_enemy = 0
var health = 11

var strzal = preload("res://strzał.tscn")
var can_fire = true
var rate_of_fire = 0.4

func _ready():
	screen_size = get_viewport_rect().size
	pozycja_strzalu = get_node("pozycja strzału").position

func _reload_position():
	position = get_parent().get_node("pozycja startowa").position

func _process(delta):
	var ScoreText = get_parent().get_node("punkty/Control/RichTextLabel")
	ScoreText.text = str("Monety: ",score_money,"/100")

func _physics_process(delta):
	if Input.is_action_pressed("ui_right"):
        velocity.x = SPEED
        $PlayerAnimation.play("idzie_prawo")
        right = true
        get_node("pozycja strzału").position.x = - pozycja_strzalu.x
	elif Input.is_action_pressed("ui_left"):
        velocity.x = -SPEED
        $PlayerAnimation.play("idzie_lewo")
        right = false
        get_node("pozycja strzału").position.x = pozycja_strzalu.x
	else:
        velocity.x = 0
        $PlayerAnimation.play("stoi")
	if is_on_floor():
	    if Input.is_action_just_pressed("ui_up"):
	        velocity.y = JUMP
	        once = true
	        if right == true:
	            $PlayerAnimation.play("skok_prawo")
	        else:
	            $PlayerAnimation.play("skok_lewo")
	else:
	    if once == true:
		    if Input.is_action_just_pressed("ui_up"):
		        velocity.y = JUMP
		        once = false
		        if right == true:
		            $PlayerAnimation.play("skok_prawo")
		        else:
		            $PlayerAnimation.play("skok_lewo")
	    velocity.y += GRAVITY
	    $PlayerAnimation.play("stoi");
	
	if Input.is_action_just_pressed("shoot") and can_fire == true:
		can_fire = false
		var shoot_instance = strzal.instance()
		if right == true:
			shoot_instance.direction = 1
		shoot_instance.position = get_node("pozycja strzału").get_global_position()
		get_parent().add_child(shoot_instance)
		yield(get_tree().create_timer(rate_of_fire), "timeout")
		can_fire = true    
	
	move_and_slide(velocity, UP)
	pass

func Take_damage():
	var pol = get_parent().get_node("życie/CanvasLayer/Życia/pół")
	var puste = get_parent().get_node("życie/CanvasLayer/Życia/puste")
	var serduszko5 = get_parent().get_node("życie/CanvasLayer/Życia/5")
	var serduszko4 = get_parent().get_node("życie/CanvasLayer/Życia/4")
	var serduszko3 = get_parent().get_node("życie/CanvasLayer/Życia/3")
	var serduszko2 = get_parent().get_node("życie/CanvasLayer/Życia/2")
	var serduszko1 = get_parent().get_node("życie/CanvasLayer/Życia/1")
	if health == 10:
		serduszko5.texture = pol.texture
	if health <= 9:
		serduszko5.texture = puste.texture
	if health == 8:
		serduszko4.texture = pol.texture
	if health <= 7:
		serduszko4.texture = puste.texture
	if health == 6:
		serduszko3.texture = pol.texture
	if health <= 5:
		serduszko3.texture = puste.texture
	if health == 4:
		serduszko2.texture = pol.texture
	if health <= 3:
		serduszko2.texture = puste.texture
	if health == 2:
		serduszko1.texture = pol.texture
	if health == 1:
		queue_free()
		get_tree().reload_current_scene()
	pass

func _on_zota_moneta_body_entered(body):
	score_money += 1
	pass
	
func _on_czerwona_body_entered(body):
	score_money += 5
	pass

func _on_zielona_body_entered(body):
	score_money += 10
	pass


func _on_koniec_gry_body_entered(body):
	var wynik
	if score_money < 10 :
		 wynik= "res://poziomy/wynik_A.tscn"
	elif score_money < 50 :
		wynik = "res://poziomy/wynik_B.tscn"
	else:
		wynik = "res://poziomy/wynik_C.tscn"
	get_tree().change_scene(wynik)
