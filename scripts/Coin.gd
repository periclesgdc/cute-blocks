extends Area2D


func _on_Coin_body_entered(body):
	if body.is_in_group("player"):
		body.spawn_child()
		queue_free()
