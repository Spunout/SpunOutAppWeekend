import sqlite3, time, random



class sampleDataMaker:

	def __init__(self):

		if len(sys.argv) != 2:
   			exit()

		print "Opening Database at path: " + sys.argv[1]
		self.conn = sqlite3.connect(sys.argv[1])

		self.c = self.conn.cursor()

		self.current_timestamp = int(round(time.time() * 1000))

	def giveBronzeAchievementsToAll(self):

		counter = 0
		lifetime_points = 10

		while counter < 7:

			lifetime_points += 10
			self.c.execute("INSERT INTO data VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", (50, 1, 1, 1, 1, 1, 1, 1, 1, self.current_timestamp+random.randint(2,5000), lifetime_points) )
			counter += 1
		self.conn.commit()

	def addRandomData(self):
		self.weeks_of_data = 4
		counter = 0
		lifetime_points = 10

		while counter < weeks_of_data:

			current_timestamp -= counter * 604800000

			num_inserts = random.randint(2,20)
			inserts_counter = 0

			if counter == 1:
				eat = 1

			elif counter == 2: 
				eat = 0
			elif counter == 3:
				eat = 1 
			else:
				eat = 0

			while inserts_counter < 7:
				lifetime_points += 50
				self.c.execute("INSERT INTO data VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", (50, eat, eat, random.getrandbits(1), random.getrandbits(1), random.getrandbits(1), random.getrandbits(1), random.getrandbits(1), random.getrandbits(1), self.current_timestamp+random.randint(2,5000), lifetime_points) )


				inserts_counter += 1

			self.conn.commit()

			counter += 1

o = sampleDataMaker()
o.giveBronzeAchievementsToAll()

