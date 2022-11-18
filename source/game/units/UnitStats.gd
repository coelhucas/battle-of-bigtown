extends Resource
class_name UnitStats

signal died()
signal aggro()

@export var hp := 10.0:
	set(_hp):
		hp = _hp
		
		if hp <= 0:
			emit_signal("died")
@export var damage := 2.5:
	get:
		var _base_damage: float = damage
		if self.buffs.has(Enums.Buff.TIRED):
			_base_damage = clamp(_base_damage * 0.4, 1.0, 100.0)
			
		if self.buffs.has(Enums.Buff.HEALTHY):
			_base_damage *= 1.75
		
		if role == Enums.Class.RANGED:
			_base_damage *= 1.25
		return _base_damage
@export var price := 1.0
@export var name: String

# Counts for both buffs and debuffs
var buffs: Array[Enums.Buff]
var defending := false
var max_hp := hp
var role: Enums.Class = Enums.Class.MELEE

func make_a_name() -> void:
	randomize()
	if name: return
	
	var _names: Array[String] = ['Adam', 'Ailwin', 'Alan', 'Alard', 'Aldred', 'Alexander', 'Alured', 'Amaury', 'Amalric', 'Anselm', 'Arnald', 'Asa', 'Aubrey', 'Baldric', 'Baldwin', 'Bartholomew', 'Bennet', 'Bertram', 'Blacwin', 'Colin', 'Constantine', 'David', 'Edwin', 'Elias', 'Helyas', 'Engeram', 'Ernald', 'Eustace', 'Fabian', 'Fordwin', 'Forwin', 'Fulk', 'Gamel', 'Geoffrey', 'Gerard', 'Gervase', 'Gilbert', 'Giles', 'Gladwin', 'Godwin', 'Guy', 'Hamo', 'Hamond', 'Harding', 'Henry', 'Herlewin', 'Hervey', 'Hugh', 'James', 'Jocelin', 'John', 'Jordan', 'Lawrence', 'Leofwin', 'Luke', 'Martin', 'Masci', 'Matthew', 'Maurice', 'Michael', 'Nigel', 'Odo', 'Oliva', 'Osbert', 'Norman', 'Nicholas', 'Peter', 'Philip', 'Ralph', 'Ranulf', 'Richard', 'Robert', 'Roger', 'Saer', 'Samer', 'Savaric', 'Silvester', 'Simon', 'Stephan', 'Terric', 'Thierry', 'Theobald', 'Thomas', 'Thurstan', 'Umfrey', 'Waleran', 'Walter', 'Warin', 'William', 'Wimarc', 'Ymbert', 'Ada', 'Adelina', 'Agnes', 'Albreda', 'Aldith', 'Aldusa', 'Alice', 'Alina', 'Amanda', 'Amice', 'Amiria', 'Anabel', 'Annora', 'Ascilia', 'Avelina', 'Avoca', 'Avice', 'Beatrice', 'Basilea', 'Bela', 'Berta', 'Celestria', 'Christiana', 'Cecilia', 'Clarice', 'Constance', 'Dionisia', 'Edith', 'Eleanor', 'Elizabeth', 'Emma', 'Estrilda', 'Isabel', 'Eva', 'Felicia', 'Fina', 'Goda', 'Golda', 'Grecia', 'Gundrea', 'Gundred', 'Gunnora', 'Haunild', 'Hawisa', 'Elena', 'Helewise', 'Hilda', 'Ida', 'Idonea', 'Isolda', 'Joan', 'Juliana', 'Katherine', 'Lettice', 'Liecia', 'Linota', 'Lora', 'Amabilia', 'Malota', 'Margaret', 'Margery', 'Marsilia', 'Mary', 'Matilda', 'Mazelina', 'Millicent', 'Muriel', 'Nesta', 'Nicola', 'Philippa', 'Petronilla', 'Primeveire', 'Richenda', 'Richolda', 'Roesia', 'Sabina', 'Sabelina', 'Sarah', 'Susanna', 'Sybilla', 'Wymarc']
	_names.shuffle()
	name = _names[0]


func take_damage(_amount: float) -> void:
	# TODO: Implement real defense system '-'
	hp -= _amount / 2 if  defending else _amount
	
	if defending:
		emit_signal("aggro")

func has_hit() -> bool:
	randomize()
	var _chance := randi() & 100
	
	if _chance <= 25:
		return false
	
	return true

func add_buff(_buff: Enums.Buff):
	if not buffs.has(_buff):
		buffs.append(_buff)
	
	if _buff == Enums.Buff.HUNGRY and hp == max_hp:
		hp = max_hp * 0.5
		
	if _buff == Enums.Buff.HEALTHY and hp == max_hp:
		hp = max_hp * 1.5

func remove_buff(_buff: Enums.Buff):
	buffs.erase(_buff)

func reset() -> void:
	hp = max_hp
