
#~
# ## DimensionViewer
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
  # ## initialize
  # Lets see if this works
  # Examples:
  #    @dimension_viewer.initialize
  initialize: ->
    console.log "Hi There"

new DimensionViewer()

