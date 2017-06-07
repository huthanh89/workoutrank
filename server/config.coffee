
#--------------------------------------------------------------
# Database Configurations
#--------------------------------------------------------------

# Production variable.

production = true

# Port to host app.

port = 5000

# MongoDB url

databaseUri = 'mongodb://localhost:27017/local'

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
exports.databaseUri     = databaseUri
exports.databaseOptions = databaseOptions

#--------------------------------------------------------------
