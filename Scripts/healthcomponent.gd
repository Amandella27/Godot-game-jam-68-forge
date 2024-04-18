extends Node

class_name HealthComponent

const ARMOR = preload("res://Assets/Armor.tres")
const HAIR = preload("res://Assets/Hair.tres")
const HELMET = preload("res://Assets/Helmet.tres")
const SKIN = preload("res://Assets/Skin.tres")

signal health_changed(new_health)
signal defeated()
signal gameover()

@export var max_health: int
var model_parts = [ARMOR,HAIR,HELMET,SKIN]
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
			
			damageIndicator()
			await get_tree().create_timer(1).timeout

			invincible = false

		if actor.is_in_group("Enemy"):
			current_health += adjustment
			if current_health <= 0:
				defeated.emit()
				actor.queue_free()

func damageIndicator():
	
	var flashColor = Color(1,0,0, 0)
	
	for model in model_parts:
		var originalColor = model.albedo_color
		var tween = create_tween()
		tween.tween_property(model, "albedo_color", flashColor, 0.1)
		tween.tween_property(model, "albedo_color", originalColor, 0.1)
		tween.tween_property(model, "albedo_color", flashColor, 0.1)
		tween.tween_property(model, "albedo_color", originalColor, 0.1)
		tween.tween_property(model, "albedo_color", flashColor, 0.1)
		tween.tween_property(model, "albedo_color", originalColor, 0.1)
		tween.tween_property(model, "albedo_color", flashColor, 0.1)
		tween.tween_property(model, "albedo_color", originalColor, 0.1)
		tween.tween_property(model, "albedo_color", flashColor, 0.1)
		tween.tween_property(model, "albedo_color", originalColor, 0.1)
		tween.tween_property(model, "albedo_color", flashColor, 0.1)
		tween.tween_property(model, "albedo_color", originalColor, 0.1)
		
		model.albedo_color = originalColor
