
#--------------------------------------------------------------
# Database Configurations
#--------------------------------------------------------------

# Production variable.

production = false

# Port to host app.

port = 5000

# MongoDB url

databaseUrl = 'mongodb://localhost:27017/local'

databaseOptions =
  user: ''
  pass: ''
  auth:
    authdb: ''

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
