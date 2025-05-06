extends Node2D

func Clear():
	for child in get_children():
		child.queue_free()
		
