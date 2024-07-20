extends KinematicBody2D


export var gravity: float

onready var child_scene = preload("res://scenes/Child.tscn")

const WALK_SPEED = 400
const WALK_ACCELERATION = 0.8
const WALK_FRICTION = 0.08
const JUMP_SPEED = -800

var velocity = Vector2.ZERO
var direction = Vector2.DOWN
var jumping = false
var current_animation = "idle"


func _physics_process(delta):
	get_inputs()
	handle_animations()
	
	velocity.y += gravity * delta
	
	if direction.x:
		velocity.x = lerp(velocity.x, direction.x * WALK_SPEED, WALK_ACCELERATION)
	else:
		velocity.x = lerp(velocity.x, 0, WALK_FRICTION)
	
	if jumping and is_on_floor():
		velocity.y = JUMP_SPEED
	elif velocity.y >= 0:
		jumping = false
	
	velocity = move_and_slide(velocity, Vector2.UP)

func get_inputs():
	if Input.is_action_pressed("ui_right"):
		direction.x = 1
	elif Input.is_action_pressed("ui_left"):
		direction.x = -1
	else:
		direction.x = 0

	if Input.is_action_just_pressed("ui_select") and is_on_floor():
		jumping = true

func handle_animations():
	if $AnimationPlayer.is_playing():
		if direction.x:
			if direction.x == -1:
				current_animation = "walk_left"
			elif direction.x == 1:
				current_animation = "walk_right"
		else:
			current_animation = "idle"
	
	if $AnimationPlayer.current_animation != current_animation:
		$AnimationPlayer.play((current_animation))

func spawn_child():
	var child = child_scene.instance()
	child.position = $SpawnPoint.position
	child.gravity = gravity
	
	add_child_below_node($Children, child)
