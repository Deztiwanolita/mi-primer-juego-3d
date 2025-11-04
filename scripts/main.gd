extends Node

@export var mob_scene: PackedScene

func _ready():
	$UserInterface/Retry.hide()

func _on_MobTimer_timeout():
	var mob = mob_scene.instantiate()
	var mob_spawn_location = $SpawnPath/SpawnLocation
	mob_spawn_location.progress_ratio = randf()
	var player_position = $Player.position
	mob.initialize(mob_spawn_location.position, player_position)
	add_child(mob)
	mob.squashed.connect($UserInterface/ScoreLabel._on_Mob_squashed)

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		get_tree().reload_current_scene()


func _on_player_hit() -> void:
	$MobTimer.stop()
	$UserInterface/Retry.show()


func _on_mob_timer_timeout() -> void:
	var mob = mob_scene.instantiate()
	var mob_spawn_location = $SpawnPath/SpawnLocation
	mob_spawn_location.progress_ratio = randf()
	var player_position = $Player.position
	mob.initialize(mob_spawn_location.position, player_position)
	add_child(mob)
	mob.squashed.connect($UserInterface/ScoreLabel._on_mob_squashed)
