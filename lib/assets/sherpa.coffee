
#~
# Used with "sherpa" styleguides for augmenting behavior for navigation
# and component definitions. Include this file only in the styleguide page.

class Sherpa
  constructor: ->
    @initialize()

  initialize: ->
    @domLookup()
    @addListeners()
    @activateMain()
    @activateUsages()

  # Create references for common DOM elements
  domLookup: ->
    @subnav_lists = $('.sherpa-anchor-nav li')
    @subnav_links = $('.sherpa-anchor-nav a')
    @usages = $('.sherpa-usage > h4')
    @anchor_links = $('.sherpa-wrapper [href=#]')

  # Listen to events from DOM elements
  addListeners: ->
    @subnav_links.on 'click', @activateSubnav
    @anchor_links.on 'click', @disableAnchors
    @usages.on 'click', @usageToggle

  # Sherpa Specific
  # Add the activate class to the main nav item based on the id of the body
  activateMain: ->
    active = $('body').attr('id')
    main_nav = $('.sherpa-dox-nav li a')
    for item in main_nav
      link = $(item)
      text = link.html().toLowerCase()
      if text is active then link.parent('li').addClass('active')

  # Set the active state on anchors after click
  activateSubnav:(e) =>
    @subnav_lists.removeClass('active')
    $(e.target).parent('li').addClass('active')

  # Disable `href="#"` within the guide
  disableAnchors:(e) =>
    e.preventDefault()

  # Find the pre block closest to the selected usage header
  getPreTag:(el) ->
    el.parent('.sherpa-usage').find('pre').first()

  # On page initialization hide the pre block and set text accordingly
  activateUsages: ->
    @usages.addClass('sherpa-togglable')
    @usages.prepend("Hide ")
    @usages.trigger 'click'

  # Toggle the usage example on click
  usageToggle:(e) =>
    el = $(e.target)
    pre = @getPreTag(el)
    if pre.hasClass('sherpa-hidden') then @usageShow(el, pre) else @usageHide(el, pre)

  # Show the usage example
  usageShow:(el, pre) ->
    text = el.html()
    el.html(text.replace(/^View/, "Hide"))
    pre.removeClass('sherpa-hidden')

  # Hide the usage example
  usageHide:(el, pre) ->
    text = el.html()
    el.html(text.replace(/^Hide/, "View"))
    pre.addClass('sherpa-hidden')

# Get this party started
new Sherpa()

