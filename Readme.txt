Startup instruction:
	- start mongod (mongodb server)
	- npm start (start node server)

start app with pm2 on production server.
    pm2 start ./server/app.js


Install Node
	- install packages from package.json
Install mongodb
	- run mongod in order to run mongo
		- /data/db folder may be needed as path for mongod
	- on windows. Go to mongodb folder and run commmand:
		mongodb --dbpath \data\db


kill task
    netstat -a -o -n
    taskkill /F /PID 28344
