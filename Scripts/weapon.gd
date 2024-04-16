extends Area3D

const SWORD = preload("res://Scenes/sword.tscn")

@export var damage: int

@onready var starting_sword:  = $StartingSword



var attachPoint: Vector3

func _ready():

	##For some reason I need 1.5 here to offset the first sword	
	attachPoint	= starting_sword.tipLocation.position * 1.5 
	
func _on_area_entered(area):
	if area.is_in_group("Enemy") and area.has_method("take_damage"):
		area.take_damage(damage)
		
func _input(event):
	if event.is_action_pressed("debugattach"):
		add_sword()

func add_sword():
	var new_sword = SWORD.instantiate()
	add_child(new_sword)
	new_sword.position = attachPoint + new_sword.tipLocation.position
	attachPoint = attachPoint + new_sword.tipLocation.position


