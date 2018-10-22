#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Backbone = require 'backbone';

#-------------------------------------------------------------------------------
# Strength Log Model
#-------------------------------------------------------------------------------

class StrengthModel extends Backbone.Model

  idAttribute: '_id'

  defaults:
    _id: ''

#-------------------------------------------------------------------------------
# Strength Log Collection
#-------------------------------------------------------------------------------

class StrengthCollection extends Backbone.Collection

  url:  '/api/slogs'
  model: StrengthModel


#-------------------------------------------------------------------------------
# Weight Model
#   Strength model used to fetch data of that exercises
#   such as the name and muscle type.
#-------------------------------------------------------------------------------

class WeightModel extends Backbone.Model
    urlRoot:     '/api/wlogs'
    idAttribute: '_id'

#-------------------------------------------------------------------------------
# Weight Collection
#-------------------------------------------------------------------------------

class WeightCollection extends Backbone.Collection

    model: WeightModel

    comparator: 'date'

    constructor: (options) ->
        super(options)
        @url = "/api/wlogs"

#-------------------------------------------------------------------------------
# Export
#-------------------------------------------------------------------------------

exports.StrengthModel      = StrengthModel
exports.StrengthCollection = StrengthCollection
exports.WeightModel        = WeightModel
exports.WeightCollection   = WeightCollection

#-------------------------------------------------------------------------------
