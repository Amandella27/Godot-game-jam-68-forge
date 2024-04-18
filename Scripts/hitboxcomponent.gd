extends Area3D

const ARMOR = preload("res://Assets/Armor.tres")
const HAIR = preload("res://Assets/Hair.tres")
const HELMET = preload("res://Assets/Helmet.tres")
const SKIN = preload("res://Assets/Skin.tres")

const originArmorColor = ARMOR.albedo_color
const originHairColor = HAIR.albedo_color
const originHelmColor = HELMET.albedo_color
const originSkinColor = SKIN.albedo_color

@export var health_component: HealthComponent
@export var armor_component: ArmorComponent

var model_parts = [ARMOR,HAIR,HELMET,SKIN]

func take_damage(amount):
	if armor_component != null and armor_component.current_armor > 0:
		armor_component.adjust_armor(amount)
	elif health_component != null:
		health_component.adjust_health(amount)
	
	if get_parent() is Player:
		damageIndicator()

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

	model_parts[0].albedo_color = originArmorColor
	model_parts[1].albedo_color = originHairColor
	model_parts[2].albedo_color = originHelmColor
	model_parts[3].albedo_color = originSkinColor

	print("Base")
	print(ARMOR.albedo_color)
	print(ARMOR.metallic)
	print(ARMOR.roughness)
	print("Model")
	print(model_parts[0].albedo_color)
	print(model_parts[0].metallic)
	print(model_parts[0].roughness)
