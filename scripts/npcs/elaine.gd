extends NPC

func _physics_process(delta: float) -> void:
	if id == "shop":
		ShopUi.visible = true
