extends Area3D

const SWORD = preload("res://Scenes/sword.tscn")

@export var damage: int

var sword

func _ready():
	sword = SWORD.instantiate()
	add_child(sword)

func _on_area_entered(area):
	if area.is_in_group("Enemy") and area.has_method("take_damage"):
		area.take_damage(damage)
		
func _input(event):
	if event.is_action_pressed("debugattach"):
		var add_sword = SWORD.instantiate()
		add_child(add_sword)
		add_sword.position = Globals.next_attach.global_position
		
