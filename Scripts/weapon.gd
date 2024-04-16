extends Area3D

@onready var collision_shape_3d = $CollisionShape3D
@onready var attach_tip = $AttachTip

@export var damage: int

func _on_area_entered(area):
	if area.is_in_group("Enemy") and area.has_method("take_damage"):
		area.take_damage(damage)
