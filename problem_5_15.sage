'''by lebedkin Alex
	system of coordinate:
		0X - left to right >						
		0Y - bottom to top ^
		0Z - front to rear .
'''

import pprint
from collections import deque

#size of Rubik's cube NxNxN
N = 2

#3d array correspond to faces of Rubic's cube in the assembled state
cube3D = [[[0 for x in range(N+2)] for y in range(N+2)] for z in range(N+2)]

#each face contain NxN little colored squars
#tatal count of such squars are:
countOfSqrs = 0

#list of easy turns of cube
generators = list()
xTurns = list()
yTurns = list()
zTurns = list()


def faceDoesntContainFixedSqrs(cube3D,x1,y1,z1, x2,y2,z2):
	for x in xrange(x1,x2+1):
		for y in xrange(y1,y2+1):
			for z in xrange(z1,z2+1):
				if cube3D[x][y][z] == -1:
					return False
	return True
	
def faceZIsAbleToRorate(cube3D,Z):
	return faceDoesntContainFixedSqrs(cube3D,0,0,Z, N+1,N+1,Z)
		
def generateAndReturnCubesItem( cube3D, x, y, z ):
	global countOfSqrs
	if cube3D[x][y][z] == 0:
		countOfSqrs += 1
		cube3D[x][y][z] = countOfSqrs
	return cube3D[x][y][z]
	
def numberedAllFaces(cube3D):
	#top face
	y = N+1
	for z in range(N,0,-1):
		for x in range(1,N+1):
			generateAndReturnCubesItem(cube3D,x,y,z)
	
	#left face
	x = 0
	for y in range(N,0,-1):		
		for z in range(N,0,-1):
			generateAndReturnCubesItem(cube3D,x,y,z)
	#front face
	z = 0
	for y in range(N,0,-1):		
		for x in range(1,N+1):
			generateAndReturnCubesItem(cube3D,x,y,z)

	#right face
	x = N+1
	for y in range(N,0,-1):		
		for z in range(1,N+1):
			generateAndReturnCubesItem(cube3D,x,y,z)
	#rear face
	z = N+1
	for y in range(N,0,-1):		
		for x in range(N,0,-1):
			generateAndReturnCubesItem(cube3D,x,y,z)
	
	#bottom face
	y = 0
	for z in range(1,N+1):
		for x in range(1,N+1):
			generateAndReturnCubesItem(cube3D,x,y,z)
		

def printNetOfCube(A):
	#top face
	print " "+('   ' * N)+" +"+('---' * N)+"-+"+('   ' * N)+"  "+('   ' * N)+"  "
	y = N+1
	for z in range(N,0,-1):
		print " "+('   ' * N)+" |",
		for x in range(1,N+1):
			print "%2d"%(A[x][y][z]),
		print "|"
	
	print "+"+('---' * N)+"-+"+('---' * N)+"-+"+('---' * N)+"-+"+('---' * N)+"-+"
	for y in xrange(N,0,-1):
		#left face
		print "|",
		for i in xrange(N):
			print "%2d"%(A[1-1][y][N-i]),
		#front face
		print "|",
		for i in xrange(N):
			print "%2d"%(A[1+i][y][1-1]),
		#right face
		print "|",
		for i in xrange(N):
			print "%2d"%(A[N+1][y][1+i]),
		#rear face
		print "|",
		for i in xrange(N):
			print "%2d"%(A[N-i][y][N+1]),
		print "|"
	print "+"+('---' * N)+"-+"+('---' * N)+"-+"+('---' * N)+"-+"+('---' * N)+"-+"
	
	#bottom face
	y = 0
	for z in range(1,N+1):
		print " "+('   ' * N)+" |",
		for x in range(1,N+1):
			print "%2d"%(A[x][y][z]),
		print "|"
	print " "+('   ' * N)+" +"+('---' * N)+"-+"+('   ' * N)+"  "+('   ' * N)+"  "
	
	
def printNetOfCubeCorrespondingPermutation(permutationGroupElement):
	#sage.groups.perm_gps.permgroup_element.PermutationGroupElement
	p = Permutation(permutationGroupElement)
			
	global cube3D
	tmp = [[[0 for x in range(N+2)] for y in range(N+2)] for z in range(N+2)]
	#renumbered all faces of cube
	for x in xrange(N+2):
		for y in xrange(N+2):
			for z in xrange(N+2):
				if  cube3D[x][y][z] == -1:
					tmp[x][y][z] = -1
				elif cube3D[x][y][z] == 0:
					tmp[x][y][z] = 0
				else:					
					tmp[x][y][z] = p[cube3D[x][y][z]-1]
					
	printNetOfCube(tmp)
	

# generator of contrclockwise rotate in the plane Z == const
def makeGeneratorOfZFace(A,Z):
	result = ""
	#rotate in Z == const plane
	for i in xrange(1,N+1):
		result += "(%d,%d,%d,%d)" % ( A[i][N+1][Z], A[N+1][N-i+1][Z], A[N-i+1][1-1][Z], A[1-1][i][Z] )
		
	#if current face insn't inner face
	if Z == 1 or Z == N:
		if Z == 1:
			Z = 0
		if Z == N:
			Z = N+1				
		'''
		M - size of square
		for example:
		face = 	
		+--------------+
		|  1    2    3 |
		|  4    9    5 |
		|  6    7    8 |
		+--------------+
		M = 3, square = 
		+--------------+
		|  1    2    3 |
		|  4    .    5 |
		|  6    7    8 |
		+--------------+
		M = 1, square = 
		+--------------+
		|  .    .    . |
		|  .    9    . |
		|  .    .    . |
		+--------------+
		'''
		for M in range(N,0,-2):
			dXY = (N - M) / 2
			for i in range(1,M):
				result += "(%d,%d,%d,%d)" % (A[i+dXY][N-dXY][Z], A[N-dXY][N-i+1-dXY][Z], A[N-i+1-dXY][1+dXY][Z],  A[1+dXY][i+dXY][Z] )
	return result


def turnCubeLeft(cube3D):
	tmp = [[[0 for x in range(N+2)] for y in range(N+2)] for z in range(N+2)]
	for x in xrange(0,N+2):
		for y in xrange(0,N+2):
			for z in xrange(0,N+2):
				tmp[x][y][z] = cube3D[N+2 - z - 1][y][x]
	return tmp
					
def turnCubeForward(cube3D):
	tmp = [[[0 for x in range(N+2)] for y in range(N+2)] for z in range(N+2)]
	for x in xrange(0,N+2):
		for y in xrange(0,N+2):
			for z in xrange(0,N+2):
				tmp[x][y][z] = cube3D[x][z][N+2 - y - 1]
	return tmp
	
def farthestVertex(start):
	resDistance = 0
	resVertex = start
	
	counter = 0
	fivePercentCounterBarrier = 3674160 // 100
	
	d = deque()
	d.append( start )
	distance = {start:0}
	while (d):
		current = d.popleft()
		currentDistance = distance[current]
		
		if currentDistance > resDistance:
			resDistance = currentDistance
			resVertex = current
		
		for turn in xTurns+yTurns+zTurns:
			#90 degree turn
			tmp = current * turn
			if( not tmp in distance ):
				distance[tmp] = currentDistance + 1
				d.append( tmp )				
				counter += 1
				
			#180 degree turn
			tmp = tmp*turn
			if( not tmp in distance ):
				distance[tmp] = currentDistance + 1
				d.append( tmp )				
				counter += 1
			
			#270 degree turn
			tmp = tmp*turn
			if( not tmp in distance ):
				distance[tmp] = currentDistance + 1
				d.append( tmp )				
				counter +=1
			
			#show current progress
			if counter % fivePercentCounterBarrier < 3:				
				sys.stdout.write("\rBFS %d%% completed" % (counter // fivePercentCounterBarrier))
				sys.stdout.flush()
				counter += 3
	
	print "."

	return resVertex, resDistance


def diameterOfGraphOfGroup():	
	Sn = SymmetricGroup(countOfSqrs)
	#the identity permutation correspond the initial state of the Rubic's cube
	E = Sn.identity()
	
	V,d = farthestVertex(E)
	return farthestVertex(V)[1] #return only distance
	

def godsNumberOfCube():
	Sn = SymmetricGroup(countOfSqrs)
	return farthestVertex(Sn.identity())[1] #return only distance
	

def main():
	for x in xrange(0,N+2):
		for y in xrange(0,N+2):
			for z in xrange(0,N+2):
				cube3D[x][y][z] = 0
	
	if N % 2 == 0:
		#fix the corner of cube
		cube3D[0][1][1] = cube3D[1][0][1] = cube3D[1][1][0] = -1
	else:
		#fix centers of the faces
		cube3D[0][(N+1)//2][(N+1)//2] = -1
		cube3D[N+1][(N+1)//2][(N+1)//2] = -1
		cube3D[(N+1)//2][0][(N+1)//2] = -1
		cube3D[(N+1)//2][N+1][(N+1)//2] = -1
		cube3D[(N+1)//2][(N+1)//2][0] = -1
		cube3D[(N+1)//2][(N+1)//2][N+1] = -1
	
	numberedAllFaces(cube3D)		
	printNetOfCube(cube3D)
	
	Sn = SymmetricGroup(countOfSqrs)
	
	tempCube = cube3D		
	for z in range(1,N+1):
		if faceZIsAbleToRorate(tempCube,z):			
			generators.append( makeGeneratorOfZFace(tempCube,z) )
			zTurns.append( Sn(generators[-1]) )
			
	tempCube = turnCubeLeft(tempCube)
	for z in range(1,N+1):
		if faceZIsAbleToRorate(tempCube,z):
			generators.append( makeGeneratorOfZFace(tempCube,z) )
			xTurns.append( Sn(generators[-1]) )
			
	tempCube = turnCubeForward(tempCube)
	for z in range(1,N+1):
		if faceZIsAbleToRorate(tempCube,z):
			generators.append( makeGeneratorOfZFace(tempCube,z) )				
			yTurns.append( Sn(generators[-1]) )

	pp = pprint.PrettyPrinter(width = 70, depth=6, indent=4)

	print "Generators of Group ="
	pp.pprint(generators)
	
	cubeGroup =  PermutationGroup(generators)
	print "Cube.order() = ", factor( cubeGroup.order() ), " = ", cubeGroup.order()
	
	randomCube = cubeGroup.random_element()
	print "random item = ", randomCube				
	printNetOfCubeCorrespondingPermutation(randomCube)
	
	orbits = cubeGroup.orbits()
	print "orbits = ", orbits
		
	if( N == 2 ):
		godsNumber = godsNumberOfCube()
		print "God's number = ", godsNumber
		
	

if __name__ == '__main__':
	main()
