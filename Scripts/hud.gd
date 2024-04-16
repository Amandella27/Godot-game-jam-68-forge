extends CanvasLayer

const ARMORBROKEN = preload("res://Scenes/UI/armorbroken.tscn")
const HEATINGUP = preload("res://Scenes/UI/heatingup.tscn")
const SWELTERING = preload("res://Scenes/UI/sweltering.tscn")
const TEMPRISING = preload("res://Scenes/UI/temprising.tscn")

@onready var armor_bar = %ArmorBar
@onready var health_bar = %HealthBar
@onready var heat_bar = %HeatBar
@onready var ui_warnings = %UIWarnings

var health_color: Color = Color(0.38, 0.031, 0)
var armor_color: Color = Color(0.769, 0.745, 0)
var heat_color: Color = Color(0.949, 0.427, 0)

var current_heat: int = 0
var heat_warning:bool = false

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
	
func update_heat(adjustment):
	var heat_tween = create_tween()
	var new_heat_total = current_heat + adjustment
	heat_warnings(current_heat, new_heat_total)
	current_heat += adjustment
	heat_tween.set_parallel()
	heat_tween.tween_property(heat_bar, "value", new_heat_total, 1).set_ease(Tween.EASE_IN_OUT)
	
	
func armor_warning():
	var warning = ARMORBROKEN.instantiate()
	ui_warnings.add_child((warning))
	await get_tree().create_timer(3).timeout
	warning.queue_free()

func heat_warnings(old_heat_total, new_heat_total):
	if old_heat_total < 50 and new_heat_total >= 50:
		var warning = TEMPRISING.instantiate()
		ui_warnings.add_child((warning))
		await get_tree().create_timer(3).timeout
		warning.queue_free()
	if old_heat_total < 100 and new_heat_total >= 100:
		var warning = HEATINGUP.instantiate()
		ui_warnings.add_child((warning))
		await get_tree().create_timer(3).timeout
		warning.queue_free()
	if old_heat_total < 150 and new_heat_total >= 150:
		var warning = SWELTERING.instantiate()
		ui_warnings.add_child((warning))
		await get_tree().create_timer(3).timeout
		warning.queue_free()
