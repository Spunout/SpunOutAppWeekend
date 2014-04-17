import sqlite3, time, random, sys

class sampleDataMaker:

	def __init__(self):

		if len(sys.argv) != 2:
   			exit()

		print "Opening Database at path: " + sys.argv[1]
		self.conn = sqlite3.connect(sys.argv[1])

		self.c = self.conn.cursor()

		self.current_timestamp = int(round(time.time() * 1000))

	def giveAchievementsToAll(self, level):

		counter = 0
		lifetime_points = 10

		if level is "bronze":
			num_activies = 8
		elif level is "silver":
			num_activies = 13
		elif level is "gold":
			num_activies = 19

		while counter < num_activies:

			lifetime_points += 10
			self.c.execute("INSERT INTO data VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", (50, 1, 1, 1, 1, 1, 1, 1, 1, self.current_timestamp+random.randint(2,5000), lifetime_points) )
			counter += 1
		self.conn.commit()

	def addRandomData(self):
		weeks_of_data = 10
		counter = 0
		lifetime_points = 10

		while counter < weeks_of_data:

			self.current_timestamp -= 604800000
			print self.current_timestamp
			num_inserts = random.randint(2,20)
			inserts_counter = 0

			if counter == 0:
				eat = 0
			elif counter == 1:
				eat = 1
			elif counter == 2:
				eat = 0
			elif counter == 3:
				eat = 1

			while inserts_counter < 7:
				lifetime_points += 50
				self.c.execute("INSERT INTO data VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", (50, random.getrandbits(1), random.getrandbits(1), random.getrandbits(1), random.getrandbits(1), random.getrandbits(1), random.getrandbits(1), random.getrandbits(1), random.getrandbits(1), (self.current_timestamp+random.randint(2,5000))/1000, lifetime_points) )


				inserts_counter += 1

			self.conn.commit()

			counter += 1

o = sampleDataMaker()
#o.giveAchievementsToAll("gold")
o.addRandomData()
