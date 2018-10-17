#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_            = require 'lodash'
moment       = require 'moment'

#-------------------------------------------------------------------------------
# Color Array
#-------------------------------------------------------------------------------

Colors = [
  '#7cb5ec'
  '#434348'
  '#90ed7d'
  '#f7a35c'
  '#8085e9'
  '#f15c80'
  '#e4d354'
  '#2b908f'
  '#f45b5b'
  '#91e8e1'
  '#993897'
  '#f88df2'
  '#ac9748'
  '#a0ac35'
  '#ba68a2'
  '#40b4c8'
]

#-------------------------------------------------------------------------------
# Muscle group
#-------------------------------------------------------------------------------

Muscles = [
  { value: 0,  label: 'Abdominals' }
  { value: 1,  label: 'Arms'       }
  { value: 2,  label: 'Back'       }
  { value: 3,  label: 'Biceps'     }
  { value: 4,  label: 'Calves'     }
  { value: 5,  label: 'Chest'      }
  { value: 6,  label: 'Forearms'   }
  { value: 7,  label: 'Glutes'     }
  { value: 8,  label: 'Hamstrings' }
  { value: 9,  label: 'Lats'       }
  { value: 10, label: 'Legs'       }
  { value: 11, label: 'Neck'       }
  { value: 12, label: 'Quadriceps' }
  { value: 13, label: 'Shoulders'  }
  { value: 14, label: 'Traps'      }
  { value: 15, label: 'Triceps'    }
]
#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

exports.Colors  = Colors
exports.Muscles = Muscles

#-------------------------------------------------------------------------------