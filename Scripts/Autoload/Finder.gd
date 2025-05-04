extends Node

func GetItemGroup():
	return get_tree().get_nodes_in_group("Item")[0]
