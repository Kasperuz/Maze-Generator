extends Node

@export var Width: int
@export var Height: int
	
var rng := RandomNumberGenerator.new()
@onready var tileMap = $"../TileMap"

func ritaKarta(karta):
	for x in range(len(karta)):
		for y in range(len(karta[x])):
			tileMap.set_cell(0, Vector2i(x, y), 0, Vector2i(0,karta[x][y]))

func checka(map:Array, position:Vector2) -> bool:
	if position.x <= 0 or position.y <= 0 or position.x >= Width-1 or position.y >= Height-1:
		return false
	if map[position.x][position.y] == 1:
		return false
		
	var nrofGrannar := 0
	if map[position.x-1][position.y] == 1:
		nrofGrannar += 1
		if map[position.x+1][position.y+1] == 1 or map[position.x+1][position.y-1] == 1:
			return false
	if map[position.x+1][position.y] == 1:
		nrofGrannar += 1
		if map[position.x-1][position.y+1] == 1 or map[position.x-1][position.y-1] == 1:
			return false
	if map[position.x][position.y-1] == 1:
		nrofGrannar += 1
		if map[position.x+1][position.y+1] == 1 or map[position.x-1][position.y+1] == 1:
			return false
	if map[position.x][position.y+1] == 1:
		nrofGrannar += 1
		if map[position.x+1][position.y-1] == 1 or map[position.x-1][position.y-1] == 1:
			return false
	
	return nrofGrannar == 1

func blandaLista(lista:Array) -> Array:
	for i in range(len(lista)):
		var index1 = i
		var index2 = rng.randi_range(0,len(lista)-1)
		var t = lista[index1]
		lista[index1] = lista[index2]
		lista[index2] = t
	return lista
	
func generate(width:int, height:int) -> Array:
	var map := []
	# Skapar en 2D lista
	for x in range(width):
		map.append([])
		for y in range(height):
			map[x].append(0)
	
	var riktningar := [Vector2(1,0),Vector2(-1,0),Vector2(0,1),Vector2(0,-1)]
	var riktning := 0
	
	var startPosition := Vector2(2,2)
	var position := startPosition
	var grenKandidater = []
	
	map[position.x][position.y] = 1	
	for i in riktningar:
		if checka(map, position + i):
			grenKandidater.append(position + i)
	
	var i2c = 0
	var nroff = 0
	
	for i in range(width * height):
		var nrofFail = 0
		while nrofFail < 4:
			if rng.randf() < 0.10:
				riktningar = blandaLista(riktningar)
				nrofFail = 0
			if checka(map, position + riktningar[riktning]):
				position += riktningar[riktning]
				map[position.x][position.y] = 1	
				for i2 in riktningar:
					if checka(map, position + i2):
						grenKandidater.append(position + i2)
				nrofFail = 0
			else:
				riktning += 1
				if riktning > 3:
					riktning = 0
				nrofFail += 1
		nroff += nrofFail
		var didNotFind = true
		for i2 in range(20 * width * height):
			position = Vector2(rng.randi_range(0,width),rng.randi_range(0,height))
			if checka(map,position):
				didNotFind = false
				break
		if didNotFind:
			break
	print(i2c," ",nroff)
	
	# Kod för ett steg:
	# Sök ett varv runt nuvarande position, spara möjliga alternativ i en lista
	# Det behövs en funktion som talar om ifall en punkt är ett möjligt alternativ
	# Välj ett slumptal av möjliga alternativ, gå dit, 
	# Loopa tills det inte finns något mer alternativ
	return map


	
#func _ready():
	#rng.randomize()
	#var bm = generate(Width,Height)
	#ritaKarta(bm)

