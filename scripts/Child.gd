extends KinematicBody2D


export var gravity: float

var velocity = Vector2.ZERO


func _physics_process(delta):
	velocity.y += gravity * delta
	
	velocity = move_and_slide(velocity, Vector2.UP)
