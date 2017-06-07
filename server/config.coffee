
#--------------------------------------------------------------
# Database Configurations
#--------------------------------------------------------------

# Production variable is set in gulp file.

production = process.env.production is 'production'

# Port to host app.

port = 5000

# MongoDB url

databaseUrl = 'mongodb://localhost:27017/local'

databaseOptions =
  user: ''
  pass: ''
  auth:
    authdb: ''


console.log '>>>>>>>>>>>', production, process.env.production

# MongoDB auth with username and password.

if production
  databaseOptions =
    user: 'admin'
    pass: '1234'
    auth:
      authdb: 'admin'

#--------------------------------------------------------------
# Exports
#--------------------------------------------------------------


exports.port            = port
exports.databaseUrl     = databaseUrl
exports.databaseOptions = databaseOptions

#--------------------------------------------------------------
