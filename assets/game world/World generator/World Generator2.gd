extends Node


@export var Storlek: Vector2
@export_range(0,1) var SvängChans: float
@export var tileMap: TileMap

var krysset := [Vector2i(0,-1),Vector2i(1,0),Vector2i(0,1),Vector2i(-1,0)]
var hörnen := [Vector2i(1,1),Vector2i(-1,1),Vector2i(1,-1),Vector2i(-1,-1)]

var rng := RandomNumberGenerator.new()


func ritaKarta(karta):
	for x in range(len(karta)):
		for y in range(len(karta[x])):
			tileMap.set_cell(0, Vector2i(x, y), 0, Vector2i(0,karta[x][y]))

func checka(map:Array, position:Vector2i) -> bool:
	return map[position.x][position.y] == 3

func blandaLista(lista:Array):
	for i in range(len(lista)):
		var index1 = i
		var index2 = rng.randi_range(0,len(lista)-1)
		var t = lista[index1]
		lista[index1] = lista[index2]
		lista[index2] = t

func sättPixel(map:Array, position:Vector2, värde:int):
	map[position.x][position.y] = värde

func ritaUtPixel(map:Array, position:Vector2i, riktning:int, värde:int):
	map[position.x][position.y] = värde
	var positionB = position + krysset[riktning]
	var mapPositionB = map[positionB.x][positionB.y]
		
	if mapPositionB == 0:
		sättPixel(map, positionB, 3)
	elif mapPositionB == 2 or mapPositionB == 3:
		sättPixel(map, positionB, 4)
	var krC = Vector2i(krysset[riktning].y, krysset[riktning].x)
	var positionC = position + krC
	var mapPositionC = map[positionC.x][positionC.y]		
	if mapPositionC == 2:
		sättPixel(map, positionC, 3)
	elif mapPositionC == 3:
		sättPixel(map, positionC, 4)

	positionC = position - krC
	mapPositionC = map[positionC.x][positionC.y]
	if mapPositionC == 2:
		sättPixel(map, positionC, 3)
	elif mapPositionC == 3:
		sättPixel(map, positionC, 4)

	positionC = position + krC + krysset[riktning]
	mapPositionC = map[positionC.x][positionC.y]
	if mapPositionC == 0:
		sättPixel(map, positionC, 2)
	elif mapPositionC == 2 or mapPositionC == 3:
		sättPixel(map, positionC, 4)

	positionC = position - krC + krysset[riktning]
	mapPositionC = map[positionC.x][positionC.y]
	if mapPositionC == 0:
		sättPixel(map, positionC, 2)
	elif mapPositionC == 2 or mapPositionC == 3:
		sättPixel(map, positionC, 4)


func generate(storlek:Vector2i, startPosition:Vector2i,) -> Array:
	var map := []
	for x in range(storlek.x):
		map.append([])
		for y in range(storlek.y):
			if x == 0 or x == storlek.x - 1 or y == 0 or y == storlek.y - 1:
				map[x].append(4)
			else:
				map[x].append(0)
			
			
	var riktning = 0
	
	var position := startPosition
	map[position.x][position.y] = 1
	for i in krysset:
		sättPixel(map, position + i, 3)
	for i in hörnen:
		sättPixel(map, position + i, 2)
	
#	for aa in range(3):
	while true:
		while true:
			if rng.randf_range(0.0,1.0) < SvängChans:
				#Om man ska byta riktning
				blandaLista(krysset)
				var hittade := false
				for riktningAttTesta in range(len(krysset)):
					if checka(map, position + krysset[riktningAttTesta]):
						riktning = riktningAttTesta
						hittade = true
						break
				if !hittade:
					break
			else:
				if !checka(map,position+krysset[riktning]):
					#Om man ska byta riktning
					blandaLista(krysset)
					var hittade := false
					for riktningAttTesta in range(len(krysset)):
						if checka(map, position + krysset[riktningAttTesta]):
							riktning = riktningAttTesta
							hittade = true
							break
					if !hittade:
						break
			position += krysset[riktning]
			ritaUtPixel(map, position, riktning, 1)
		
		var grenKandidater := []
		for x in range(len(map)):
			for y in range(len(map[x])):
				if map[x][y] == 3:
					grenKandidater.append(Vector2i(x,y))
					
		if len(grenKandidater) <= 0:
			return map
			
		position = grenKandidater[rng.randi_range(0, len(grenKandidater) - 1)]
		for i in range(len(krysset)):
			if map[krysset[i].x + position.x][krysset[i].y + position.y] == 0:
				riktning = i
		ritaUtPixel(map,position,riktning,1)
			
	return map

func _ready():
	rng.randomize()
	var bm = generate(Storlek,Vector2i(5,5))
	ritaKarta(bm)
