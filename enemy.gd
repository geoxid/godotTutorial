extends KinematicBody2D

var velocity = Vector2()
export var direction = -1
export var detect = true
const GRAVITY = 10
var SPEED = 50

func _ready():
	if direction == 1: 
		$AnimatedSprite.flip_h = true
	
	$RayCast2D.position.x = $CollisionShape2D.shape.get_extents().x * direction
	$RayCast2D.enabled = detect
	
	if(not detect):
		set_modulate(Color(1.2, 0.5 , 1))

func _physics_process(delta):

		
	if is_on_wall() or not $RayCast2D.is_colliding() and detect and is_on_floor():
		direction = direction * -1
		$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h
		$RayCast2D.position.x = $CollisionShape2D.shape.get_extents().x * direction
	
	velocity.y += GRAVITY
	velocity.x = SPEED * direction
	velocity = move_and_slide(velocity, Vector2.UP)


func _on_top_checker_body_entered(body):
	
	$AnimatedSprite.play("squashed")
	SPEED = 0
	set_collision_mask_bit(0, false)
	set_collision_layer_bit(4, false)
	$top_checker.set_collision_mask_bit(0, false)
	$top_checker.set_collision_layer_bit(4, false)
	$side_checker.set_collision_mask_bit(0, false)
	$side_checker.set_collision_layer_bit(4, false)
	$Timer.start()
	body.bounce()
	$SoundSquash.play()

func _on_side_checker_body_entered(body):
	if body.name == "Player":
		body.ouch(position.x)

func _on_Timer_timeout():
	queue_free()
