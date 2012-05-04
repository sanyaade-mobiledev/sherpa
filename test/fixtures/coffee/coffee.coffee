
#~ DimensionViewer:
#
# Debugging tool for printing the `innerWidth` of the browser.
#
# Notes:
# - **Note!** Useful when creating styles associated with media queries.
#
# Examples:
#    @dimension_viewer = new DimensionViewer

class DimensionViewer
  constructor: ->
    @initialize()

  #~
  # ### `#initialize`
  # Get this party started by instantiateing a bunch of stuff
  #
  #    @dimension_viewer.initialize
  initialize: ->
    console.log "Hi There"

  #~
  # ### `#dispose`
  # End this party
  #
  #    @dimension_viewer.dispose
  dispose: ->
    console.log "Bye Now"

new DimensionViewer()

