#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Backbone = require 'backbone'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'backbone.paginator'

#-------------------------------------------------------------------------------
# Model
#-------------------------------------------------------------------------------

class Model extends Backbone.Model

  idAttribute: '_id'

  url:  '/api/exercise/strength'

  defaults:
    date: new Date()
    name:  ''
    type:  0
    note:  ''
    sets:  []
    count: 1

#-------------------------------------------------------------------------------
# Collection
#-------------------------------------------------------------------------------

class Collection extends Backbone.PageableCollection

  url:  '/api/exercise/strength'

  model: Model

  mode: 'client'

  state:
    currentPage: 1
    pageSize:    10

  comparator: (item) -> return -item.get('date')

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.Model      = Model
module.exports.Collection = Collection
module.exports.MasterView = require './master/view'
module.exports.DetailView = require './detail/view'

#-------------------------------------------------------------------------------
