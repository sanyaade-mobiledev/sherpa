
#~ DimensionViewer:
#
# Debugging tool for printing the `innerWidth` of the browser.
#
# Notes:
# - **Note!** Useful when creating styles associated with media queries.
#
# Warnings:
# - **Warning!** Useful when creating styles associated with media queries.
#
# Alerts:
# - **Alert!** Useful when creating styles associated with media queries.
#
# Examples:
#    @dimension_viewer = new DimensionViewer

class DimensionViewer
  constructor: ->
    @initialize()

  #~
  # ### `#initialize`
  # Get this party started by instantiating a bunch of stuff
  #
  # Start me some ~lorem_xsmall
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

