extends KinematicBody2D

var velocity = Vector2(0, 0)
const SPEED = 180
const GRAVITY = 35
const JUMPFORCE = -1000

func _physics_process(delta):
	if Input.is_action_pressed("right"):
		velocity.x = SPEED
		$AnimatedSprite.play("walk")
		$AnimatedSprite.flip_h = false
	elif Input.is_action_pressed("left"):
		velocity.x = -SPEED
		$AnimatedSprite.play("walk")
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.play("idle")
		
	if not is_on_floor():
		$AnimatedSprite.play("air")
		
	velocity.y = velocity.y + GRAVITY
	
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = JUMPFORCE
		$SoundJump.play()
	
	velocity = move_and_slide(velocity, Vector2.UP)	
	
	velocity.x = lerp(velocity.x, 0, 0.2)


func _on_Area2D_body_entered(body):
	get_tree().change_scene("res://Level1.tscn")

func bounce():
	velocity.y = JUMPFORCE * 0.6
	
func ouch(var enemyposx):
	set_modulate(Color(1, 0.3, 0.3, 0.3))
	velocity.y = JUMPFORCE * 0.4
	
	if position.x < enemyposx:
		velocity.x = -800
	elif position.x > enemyposx:
		velocity.x = 800
		
	Input.action_release("left")
	Input.action_release("right")
	$Timer.start()

func _on_Timer_timeout():
	get_tree().change_scene("res://Level1.tscn")
