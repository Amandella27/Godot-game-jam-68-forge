extends Area3D

class_name HurtboxComponent

@onready var damage_timer = $DamageTimer

var damage: int
var currentArea


func set_damage(passed_damage:int):
	damage = passed_damage

func _on_area_entered(area):
	if area.is_in_group("Player") and area.has_method("take_damage"):
		area.take_damage(damage)
		currentArea = area
		damage_timer.start(1)
		
func _on_damage_timer_timeout():
	currentArea.take_damage(damage)
	
func _on_area_exited(area):
	if area.is_in_group("Player"):
		currentArea = null
		damage_timer.stop()
