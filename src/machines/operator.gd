extends RefCounted
class_name Operator

var desc: String = ""
var op: Callable

func _init(desc: String, op: Callable):
	self.desc = desc
	self.op = op
