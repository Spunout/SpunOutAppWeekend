import sqlite3, time, random, sys

if len(sys.argv) != 2:
    exit()

print "Opening Database at path: " + sys.argv[1]
conn = sqlite3.connect(sys.argv[1])
c = conn.cursor()

current_timestamp = int(round(time.time() * 1000))

weeks_of_data = 4
counter = 0
lifetime_points = 10

while counter < weeks_of_data:
    current_timestamp -= counter * 604800000

    num_inserts = random.randint(2, 20)
    insertsCounter = 0

    num_inserts = random.randint(2,20)
    inserts_counter = 0

    while inserts_counter < num_inserts:
        lifetime_points += 50
        c.execute("INSERT into data VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", (50, 1, random.getrandbits(1), random.getrandbits(1), random.getrandbits(1), random.getrandbits(1), random.getrandbits(1), random.getrandbits(1), random.getrandbits(1), current_timestamp+random.randint(2,5000), lifetime_points))

        inserts_counter += 1

    counter += 1

print "Successfully added test data"
>>>>>>> Updated test script to take database path as parameter
