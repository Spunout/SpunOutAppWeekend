import sqlite3, time, random

conn = sqlite3.connect("/Users/jameseggers/Library/Application Support/iPhone Simulator/7.0.3-64/Applications/882B36EA-19F0-4056-97D1-8EFDB42CC59E/Documents/miyo.db")

c = conn.cursor()

current_timestamp = int(round(time.time() * 1000))

weeks_of_data = 4
counter = 0
lifetime_points = 10

while counter < weeks_of_data:

	current_timestamp -= counter * 604800000

	num_inserts = random.randint(2,20)
	insertsCounter = 0

	while insertsCounter < num_inserts:
		lifetime_points += 50
		c.execute("INSERT into data VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", (50, random.getrandbits(1), random.getrandbits(1), random.getrandbits(1), random.getrandbits(1), random.getrandbits(1), random.getrandbits(1), random.getrandbits(1), random.getrandbits(1), current_timestamp+random.randint(2,5000), lifetime_points))

		insertsCounter += 1

	conn.commit()

	counter += 1	