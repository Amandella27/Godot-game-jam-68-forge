extends Area3D

class_name HurtboxComponent

var damage: int

func set_damage(passed_damage:int):
	damage = passed_damage

func _on_area_entered(area):
	if area.is_in_group("Player") and area.has_method("take_damage"):
		area.take_damage(damage)
