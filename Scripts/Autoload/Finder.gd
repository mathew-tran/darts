extends Node

func GetItemGroup():
	return get_tree().get_nodes_in_group("Item")[0]

func GetCamera() -> GameCamera:
	return get_tree().get_nodes_in_group("Camera")[0]

func GetBow() -> Bow:
	return get_tree().get_nodes_in_group("Bow")[0]
	
func GetGame() -> Game:
	return get_tree().get_nodes_in_group("Game")[0]
	
