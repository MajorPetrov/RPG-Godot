extends Node2D


func _on_Hurtbox_area_entered(_area):
	create_grass_effect()
	queue_free()  # supprime à la fin de la frame, contrairement à free() qui supprime immédiatement 

func create_grass_effect():
	var GrassEffect = load("res://Effects/GrassEffect.tscn")  # ressource
	var grassEffect = GrassEffect.instance()  # instance
	var world = get_tree().current_scene
		
	world.add_child(grassEffect)
	grassEffect.global_position = global_position  # la global_position de la grass du script 
