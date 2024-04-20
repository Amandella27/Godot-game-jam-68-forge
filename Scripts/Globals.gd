extends Node

const MAIN = preload("res://Scenes/main.tscn")

var currentPlayer: Player
var currentWeapon
var menusOpen: bool
var hud
var current_heat: int = 0
var current_wave: int
var input_mode: String ## Can be "Controller" or "Mouse"
var thorns_upgrades:int = 0

func reset_globals():
	currentPlayer.queue_free()
	currentWeapon.queue_free()
	current_heat = 0
	current_wave = 1
	thorns_upgrades = 0
