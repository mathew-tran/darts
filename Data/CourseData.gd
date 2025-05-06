extends Resource

class_name CourseData

@export var CourseName = "Basic"
@export var Levels : Array[LevelData]

func GetLevel(index):
	if Levels.size() > index:
		return Levels[index]
	return null
