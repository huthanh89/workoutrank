#--------------------------------------------------
# Imports
#--------------------------------------------------

express  = require 'express'
router   = express.Router()

#--------------------------------------------------
# Import Routes
#--------------------------------------------------

comment  = require './comment/module'
chat     = require './chat/module'
contact  = require './contact/module'
home     = require './home/module'
movie    = require './movie/module'
profile  = require './profile/module'
userlist = require './userlist/module'

#--------------------------------------------------
# Path Routers
#--------------------------------------------------

index = (req, res, next) ->
  res.render 'index'
  return

router.get '/',              index
router.get '/home',          index
router.get '/chatbox',       index
router.get '/movies',        index
router.get '/movies/:title', index

#--------------------------------------------------
# Collection Routers for resources.
#--------------------------------------------------

# Comment
router.get  '/api/comment', comment.get
router.post '/api/comment', comment.post

# Contact
router.get '/api/contacts', contact.get

# Home
router.get '/api/home', home.get

# Profile
router.get '/api/profile', profile.get

# UserList
router.get '/api/userlist', userlist.get


# Chat
router.get  '/api/chatbox', chat.get
router.post '/api/chatbox', chat.post

# Movies
router.get  '/api/movies', movie.list
#router.post '/api/movies', chat.post

router.get  '/api/movies/test', movie.get

#--------------------------------------------------
# Exports
#--------------------------------------------------

module.exports = router

#--------------------------------------------------
