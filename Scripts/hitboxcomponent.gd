extends Area3D

const ARMOR = preload("res://Assets/Armor.tres")
const HAIR = preload("res://Assets/Hair.tres")
const HELMET = preload("res://Assets/Helmet.tres")
const SKIN = preload("res://Assets/Skin.tres")

const originArmorColor = Color(0.188, 0.059, 0.047)
const originHairColor = Color(0.906, 0.114, 0.102)
const originHelmColor = Color(0.027, 0.027, 0.02)
const originSkinColor = Color(0.761, 0.49, 0.357)

@export var health_component: HealthComponent
@export var armor_component: ArmorComponent

var model_parts = {ARMOR:originArmorColor,HAIR:originHairColor,HELMET:originHelmColor,SKIN:originSkinColor}

func take_damage(amount):
	if armor_component != null and armor_component.current_armor > 0:
		armor_component.adjust_armor(amount)
	elif health_component != null:
		health_component.adjust_health(amount)
	
	if get_parent() is Player:
		damageIndicator()

func damageIndicator():
	
	var flashColor = Color(1,0,0, 1)
	
	for model in model_parts:
		var originalColor = model_parts[model]
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

func reset_colors():
	model_parts[0].albedo_color = originArmorColor
	model_parts[1].albedo_color = originHairColor
	model_parts[2].albedo_color = originHelmColor
	model_parts[3].albedo_color = originSkinColor
