extends StaticBody2D

func _on_bounced_on(body : PhysicsBody2D):
	get_parent()._on_bounced_on(body)
