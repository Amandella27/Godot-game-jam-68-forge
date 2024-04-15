extends Node

class_name ArmorComponent

signal armor_changed(new_armor)
signal armor_broken()

@export var max_armor: int

var current_armor
var actor: Node3D
var invincible: bool = false

func _ready():
	current_armor = max_armor
	actor = get_parent()
	armor_changed.emit(current_armor)
	
func get_armor() -> int:
	return current_armor

func adjust_armor(adjustment: int):
	
	if adjustment > 0:
		current_armor += adjustment
		emit_signal("armor_changed", current_armor)
	elif !invincible:

		if actor.is_in_group("Player") or actor.is_in_group("Enemy"):
			invincible = true
			#hurt_sound.play()
			current_armor += adjustment
			emit_signal("armor_changed", current_armor)
			if current_armor <= 0:
				armor_broken.emit()
			
			#Timer to prevent overlapping instances of damage
			await get_tree().create_timer(1).timeout

			invincible = false
