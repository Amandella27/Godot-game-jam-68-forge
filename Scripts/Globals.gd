extends Node

var currentPlayer: Player
var currentWeapon
var menusOpen: bool
var hud
var current_heat: int
var current_wave: int
var input_mode: String ## Can be "Controller" or "Mouse"

func reset_globals():
	currentPlayer.queue_free()
	currentWeapon.queue_free()
	current_heat = 0
	current_wave = 1
