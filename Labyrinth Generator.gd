extends Node

@export var Size: Vector2i
@export var StartPosition: Vector2i
@export_range(0,1) var TurnChance: float
@export var OutputTilemap: TileMap

var cross := [Vector2i(0,-1),Vector2i(1,0),Vector2i(0,1),Vector2i(-1,0)]
var corners := [Vector2i(1,1),Vector2i(-1,1),Vector2i(1,-1),Vector2i(-1,-1)]

var rng := RandomNumberGenerator.new()


func drawMapToTilemap(map):
	for x in range(len(map)):
		for y in range(len(map[x])):
			OutputTilemap.set_cell(0, Vector2i(x, y), 0, Vector2i(0,map[x][y]))

func check(map:Array, position:Vector2i) -> bool:
	return map[position.x][position.y] == 3

func mixList(list:Array):
	for i in range(len(list)):
		var index1 = i
		var index2 = rng.randi_range(0,len(list)-1)
		var t = list[index1]
		list[index1] = list[index2]
		list[index2] = t

func setPixel(map:Array, position:Vector2, value:int):
	map[position.x][position.y] = value

func drawPixel(map:Array, position:Vector2i, direction:int, value:int):
	map[position.x][position.y] = value
	var positionB = position + cross[direction]
	var mapPositionB = map[positionB.x][positionB.y]
		
	if mapPositionB == 0:
		setPixel(map, positionB, 3)
	elif mapPositionB == 2 or mapPositionB == 3:
		setPixel(map, positionB, 4)
	var krC = Vector2i(cross[direction].y, cross[direction].x)
	var positionC = position + krC
	var mapPositionC = map[positionC.x][positionC.y]		
	if mapPositionC == 2:
		setPixel(map, positionC, 3)
	elif mapPositionC == 3:
		setPixel(map, positionC, 4)

	positionC = position - krC
	mapPositionC = map[positionC.x][positionC.y]
	if mapPositionC == 2:
		setPixel(map, positionC, 3)
	elif mapPositionC == 3:
		setPixel(map, positionC, 4)

	positionC = position + krC + cross[direction]
	mapPositionC = map[positionC.x][positionC.y]
	if mapPositionC == 0:
		setPixel(map, positionC, 2)
	elif mapPositionC == 2 or mapPositionC == 3:
		setPixel(map, positionC, 4)

	positionC = position - krC + cross[direction]
	mapPositionC = map[positionC.x][positionC.y]
	if mapPositionC == 0:
		setPixel(map, positionC, 2)
	elif mapPositionC == 2 or mapPositionC == 3:
		setPixel(map, positionC, 4)


func generate(storlek:Vector2i, startPosition:Vector2i,) -> Array:
	rng.randomize()
	var map := []
	for x in range(storlek.x):
		map.append([])
		for y in range(storlek.y):
			if x == 0 or x == storlek.x - 1 or y == 0 or y == storlek.y - 1:
				map[x].append(4)
			else:
				map[x].append(0)
			
			
	var direction = 0
	
	var position := startPosition
	map[position.x][position.y] = 1
	for i in cross:
		setPixel(map, position + i, 3)
	for i in corners:
		setPixel(map, position + i, 2)

	while true:
		while true:
			if rng.randf_range(0.0,1.0) < TurnChance:
				#Om man ska byta direction
				mixList(cross)
				var found := false
				for directionToTest in range(len(cross)):
					if check(map, position + cross[directionToTest]):
						direction = directionToTest
						found = true
						break
				if !found:
					break
			else:
				if !check(map,position+cross[direction]):
					#Om man ska byta direction
					mixList(cross)
					var found := false
					for directionToTest in range(len(cross)):
						if check(map, position + cross[directionToTest]):
							direction = directionToTest
							found = true
							break
					if !found:
						break
			position += cross[direction]
			drawPixel(map, position, direction, 1)
			drawMapToTilemap(map)

		var found := false
		var branchCandidates := []
		for x in range(len(map)):
			for y in range(len(map[x])):
				if map[x][y] == 3:
					branchCandidates.append(Vector2i(x,y))
					
		if len(branchCandidates) <= 0:
			return map
			
		position = branchCandidates[rng.randi_range(0, len(branchCandidates) - 1)]
		for i in range(len(cross)):
			if map[cross[i].x + position.x][cross[i].y + position.y] == 1:
				direction = i
				found = true
				break
		if !found:
			print("error")
			breakpoint
		for i in range(len(cross)):
			if cross[i].x + cross[direction].x == 0 && cross[i].y + cross[direction].y == 0:
				direction = i
				break
			
		drawPixel(map,position,direction,1)
		drawMapToTilemap(map)
	return map

func _ready():
	drawMapToTilemap(generate(Size,Vector2i(5,5)))
