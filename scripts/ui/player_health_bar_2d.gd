extends HealthBar2D


func _on_damaged(amount: float) -> void:
	$"../..".add_trauma(0.8)
