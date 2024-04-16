extends CanvasLayer

const ARMORBROKEN = preload("res://Scenes/UI/armorbroken.tscn")

@onready var armor_bar = %ArmorBar
@onready var health_bar = %HealthBar
@onready var heat_bar = %HeatBar
@onready var ui_warnings = %UIWarnings

var health_color: Color = Color(0.38, 0.031, 0)
var armor_color: Color = Color(0.769, 0.745, 0)
var heat_color: Color = Color(0.949, 0.427, 0)

func _ready():
	Globals.hud = self

func update_health(new_value):
	var health_tween = create_tween()
	health_tween.set_parallel()
	health_tween.tween_property(health_bar, "value", new_value, 1).set_ease(Tween.EASE_IN_OUT)
	health_tween.tween_property(health_bar, "theme_override_styles/fill:bg_color", Color.INDIAN_RED, 0.3).set_ease(Tween.EASE_IN_OUT)
	health_tween.tween_property(health_bar, "theme_override_styles/fill:bg_color", health_color, 0.3).set_ease(Tween.EASE_IN_OUT).set_delay(0.3)

func update_armor(new_value):
	var armor_tween = create_tween()
	armor_tween.set_parallel()
	armor_tween.tween_property(armor_bar, "value", new_value, 1).set_ease(Tween.EASE_IN_OUT)
	armor_tween.tween_property(armor_bar, "theme_override_styles/fill:bg_color", Color.GOLDENROD, 0.3).set_ease(Tween.EASE_IN_OUT)
	armor_tween.tween_property(armor_bar, "theme_override_styles/fill:bg_color", armor_color, 0.3).set_ease(Tween.EASE_IN_OUT).set_delay(0.3)
	
func update_heat(new_value):
	var heat_tween = create_tween()
	heat_tween.set_parallel()
	heat_tween.tween_property(heat_bar, "value", new_value, 1).set_ease(Tween.EASE_IN_OUT)
	#heat_tween.tween_property(heat_bar, "theme_override_styles/fill:bg_color", Color.ORANGE, 0.3).set_ease(Tween.EASE_IN_OUT)
	#heat_tween.tween_property(heat_bar, "theme_override_styles/fill:bg_color", heat_color, 0.3).set_ease(Tween.EASE_IN_OUT).set_delay(0.3)
	
func armor_warning():
	var warning = ARMORBROKEN.instantiate()
	ui_warnings.add_child((warning))
	await get_tree().create_timer(3).timeout
	warning.queue_free()
