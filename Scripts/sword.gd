extends CollisionShape3D

@onready var attach_tip = %AttachTip

func _ready():
	Globals.next_attach = attach_tip.global_position
