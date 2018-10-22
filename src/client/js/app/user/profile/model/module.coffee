#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Backbone = require 'backbone'
moment   = require 'moment'

#-------------------------------------------------------------------------------
# Model
#-------------------------------------------------------------------------------

class Model extends Backbone.Model

    idAttribute: '_id'

    url: '/api/profile'

    defaults:
        _id:       ''
        firstname: ''
        lastname:  ''
        email:     ''
        height:    0
        weight:    0
        gender:    0
        birthday:  moment()

        lastModified:     ''
        lastModifiedDate: new Date()
        name:             ''
        size:             0
        imageType:        'profile'
        uploadDate:       moment()
        type:             ''
        data:             ''

    resetImage: ->
        @set
            uploadDate:       moment()
            lastModified:     ''
            lastModifiedDate: new Date()
            name:             ''
            size:             0
            imageType:        'profile'
            type:             ''
            data:             ''
        return

    parse: (response) ->
        user  = _.pick response.user,  _.keys @defaults
        image = _.pick response.image, _.keys @defaults
        return _.extend {}, image, user

#-------------------------------------------------------------------------------
# Weight Model
#-------------------------------------------------------------------------------

class WLogModel extends Backbone.Model
    urlRoot:     '/api/wlogs'
    idAttribute: '_id'

#-------------------------------------------------------------------------------
# Weight Collection
#-------------------------------------------------------------------------------

class WLogCollection extends Backbone.Collection

    model: WLogModel

    comparator: 'date'

    constructor: (options) ->
        super(options)
        @url = "/api/wlogs"

#-------------------------------------------------------------------------------
# Export
#-------------------------------------------------------------------------------

exports.Model          = Model
exports.WLogModel      = WLogModel
exports.WLogCollection = WLogCollection

#-------------------------------------------------------------------------------
