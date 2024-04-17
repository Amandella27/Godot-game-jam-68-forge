extends Node

class_name HealthComponent

signal health_changed(new_health)
signal defeated()
signal gameover()

@export var max_health: int
var current_health
var actor: Node3D

var invincible: bool = false

func _ready():
	current_health = max_health
	actor = get_parent()
	health_changed.emit(current_health)
	
func get_health() -> int:
	return current_health

func adjust_health(adjustment: int):
	
	if adjustment > 0:
		current_health += adjustment
		emit_signal("health_changed", current_health)

	elif !invincible:

		if actor.is_in_group("Player"):
			invincible = true
			#hurt_sound.play()
			current_health += adjustment
			emit_signal("health_changed", current_health)
			if current_health <= 0:
				gameover.emit()
				
			
			#Timer to prevent overlapping instances of damage
			await get_tree().create_timer(1).timeout

			invincible = false

		if actor.is_in_group("Enemy"):
			current_health += adjustment
			if current_health <= 0:
				defeated.emit()
				actor.queue_free()
