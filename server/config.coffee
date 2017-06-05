
#--------------------------------------------------------------
# Database Configurations
#--------------------------------------------------------------

production = true

# Port to host app.

port = 5000

# MongoDB url

databaseUrl = 'mongodb://localhost:27017/local'

databaseOptions = {}

# MongoDB auth

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
