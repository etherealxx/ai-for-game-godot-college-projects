extends Resource
class_name EnemyProp

@export var color_name : String
@export var scene : PackedScene
@export_range(0,100) var chance : int = 100

@warning_ignore("unused_private_class_variable")
var _weight : float
