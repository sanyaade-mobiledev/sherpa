
# sherpa

Documentation generator for various languages.

Work in progress, not ready for prime time just yet.

## Font-size
Use `rems` to insert a font size with a pixel fallback.
This showcases how you might create a mixin block.

#### Arguments:

- `$target_px`              - The target font size in pixels
- `$context:$context_px`    - [_optional_] The context constraints of the
                               user's base font size

#### Notes:

- **Heads Up!** Make sure not to include the `px`

#### Examples:

    h1
      +font-size(48)
##  Visibility mixins

Mixin            |Params|Usage
-----------------|------|----------------------------------------------
`+hidden`        |none  |Totally hidden from screen readers and browsers
`+shown`         |none  |Reverse the effects of hidden
`+visuallyhidden`|none  |Only visually hidden, still available to screen readers
`+visuallyshown` |none  |Reverse the settings applied by `.visuallyhidden`
`+invisible`     |none  |Hide visually and from screenreaders, but maintain layout
## Headings
Default heading elements. Showcases how to document a normal style.

#### Usage:

    <h1>Google hearts h1 headings, but only use one per page.</h1>
    <h2>Got sections? Try using h2 headings.</h2>
    <h3>Good things come in threes, like tacos and h3 headings.</h3>
### `h3.alt`
Second sherpa block within the `headings.sass` file describing an alternate heading.

Does Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

#### Examples:

    <h3 class="alt">alternate</h3>
## Links
As a convention, buttons should only be used for actions while hyperlinks are
to be used for objects. For instance, "Download" should be a button while
"recent activity" should be a link.

This is a lorem ipsum test: Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation.

#### States:

- **:hover**    - When the mouse is located over the link.
- **:visited**  - When a link has already been visited.
- **:focus**    - When the element has keyboard focus.
- **:active**   - When the mouse is pressed over the link.

#### Usage:

    <p>The anchor element defines a <a href="http://www.modeset.com/">hyperlink</a>!</p>
##  DimensionViewer

Debugging tool for printing the `innerWidth` of the browser.

#### Notes:

- **Note!** Useful when creating styles associated with media queries.

#### Warnings:

- **Warning!** Useful when creating styles associated with media queries.

#### Alerts:

- **Alert!** Useful when creating styles associated with media queries.

#### Examples:

    @dimension_viewer = new DimensionViewer
### `#initialize`
Get this party started by instantiating a bunch of stuff

Start me some Lorem ipsum dolor sit amet.

    @dimension_viewer.initialize
### `#dispose`
End this party

    @dimension_viewer.dispose
##  GetImageSize

This file showcase the use of JavaDoc, multi line and single line sherpa blocks.

#### Arguments:

- src      - The path to the image requesting the size of
- callback - The callback function to execute after obtaining the image size

#### Examples:

    var image_size = new GetImageSize('/images/image.png', gotImageSize);
### `#requestImageSize`
Uses a multi line sherpa block

    image_size.requestImageSize();
### `#dispose`
Uses a single line sherpa block

    image_size.dispose();
## Ruby
Super simple Ruby file using the `#` symbol for comment markers.

#### Alerts:

- **Alert!** Don't run with scissors.

#### Examples:

    @parser = Sherpa::Parser.new

    ## parses the file...
    @parser.parse file


## Markdown Test File

This is a test markdown file, it should always use the raw template.


# Root File

This is a simple markdown file for root path testing

## Headings
Default heading elements. Showcases how to document a normal style.

#### Usage:

    <h1>Google hearts h1 headings, but only use one per page.</h1>
    <h2>Got sections? Try using h2 headings.</h2>
    <h3>Good things come in threes, like tacos and h3 headings.</h3>
### `h3.alt`
Second sherpa block within the `headings.sass` file describing an alternate heading.

Does Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

#### Examples:

    <h3 class="alt">alternate</h3>
## Font-size
Use `rems` to insert a font size with a pixel fallback.
This showcases how you might create a mixin block.

#### Arguments:

- `$target_px`              - The target font size in pixels
- `$context:$context_px`    - [_optional_] The context constraints of the
                               user's base font size

#### Notes:

- **Heads Up!** Make sure not to include the `px`

#### Examples:

    h1
      +font-size(48)
##  Visibility mixins

Mixin            |Params|Usage
-----------------|------|----------------------------------------------
`+hidden`        |none  |Totally hidden from screen readers and browsers
`+shown`         |none  |Reverse the effects of hidden
`+visuallyhidden`|none  |Only visually hidden, still available to screen readers
`+visuallyshown` |none  |Reverse the settings applied by `.visuallyhidden`
`+invisible`     |none  |Hide visually and from screenreaders, but maintain layout
##  GetImageSize

This file showcase the use of JavaDoc, multi line and single line sherpa blocks.

#### Arguments:

- src      - The path to the image requesting the size of
- callback - The callback function to execute after obtaining the image size

#### Examples:

    var image_size = new GetImageSize('/images/image.png', gotImageSize);
### `#requestImageSize`
Uses a multi line sherpa block

    image_size.requestImageSize();
### `#dispose`
Uses a single line sherpa block

    image_size.dispose();
##  DimensionViewer

Debugging tool for printing the `innerWidth` of the browser.

#### Notes:

- **Note!** Useful when creating styles associated with media queries.

#### Warnings:

- **Warning!** Useful when creating styles associated with media queries.

#### Alerts:

- **Alert!** Useful when creating styles associated with media queries.

#### Examples:

    @dimension_viewer = new DimensionViewer
### `#initialize`
Get this party started by instantiating a bunch of stuff

Start me some Lorem ipsum dolor sit amet.

    @dimension_viewer.initialize
### `#dispose`
End this party

    @dimension_viewer.dispose
![apple touch icon 114x114 precomposed](/test/fixtures/images/apple-touch-icon-114x114-precomposed.png 'apple touch icon 114x114 precomposed')
## Markdown Test File

This is a test markdown file, it should always use the raw template.

## Links
As a convention, buttons should only be used for actions while hyperlinks are
to be used for objects. For instance, "Download" should be a button while
"recent activity" should be a link.

This is a lorem ipsum test: Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation.

#### States:

- **:hover**    - When the mouse is located over the link.
- **:visited**  - When a link has already been visited.
- **:focus**    - When the element has keyboard focus.
- **:active**   - When the mouse is pressed over the link.

#### Usage:

    <p>The anchor element defines a <a href="http://www.modeset.com/">hyperlink</a>!</p>
## Headings
Default heading elements. Showcases how to document a normal style.

#### Usage:

    <h1>Google hearts h1 headings, but only use one per page.</h1>
    <h2>Got sections? Try using h2 headings.</h2>
    <h3>Good things come in threes, like tacos and h3 headings.</h3>
### `h3.alt`
Second sherpa block within the `headings.sass` file describing an alternate heading.

Does Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

#### Examples:

    <h3 class="alt">alternate</h3>
## Ruby
Super simple Ruby file using the `#` symbol for comment markers.

#### Alerts:

- **Alert!** Don't run with scissors.

#### Examples:

    @parser = Sherpa::Parser.new

    ## parses the file...
    @parser.parse file

![apple touch icon 114x114 precomposed](/test/fixtures/images/apple-touch-icon-114x114-precomposed.png 'apple touch icon 114x114 precomposed')![haters1](/test/fixtures/images/haters1.jpeg 'haters1')![haters2](/test/fixtures/images/haters2.jpeg 'haters2')![loading](/test/fixtures/images/loading.gif 'loading')![favicon](/test/fixtures/images/favicon.ico 'favicon')### [view photoshop.psd](/test/fixtures/unsupported/photoshop.psd file)### [view portable.pdf](/test/fixtures/unsupported/portable.pdf file)### [view shockwave.swf](/test/fixtures/unsupported/shockwave.swf file)
## This is an h2 header

Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.o


Usage:

    <h1>This is an H1 heading</h1>
    <h2>This is an H2 heading</h2>

    <h3>This is an H3 heading with some spacing!</h3>

This is back to another line. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

### This is an h3

Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

#### Usage:

    <h4>This is an H4 heading</h4>
    <h5>This is an H5 heading</h5>

    <h6>This is an H6 heading with some spacing!</h6>

#### Usage:

```
<h4>Fenced H4 heading</h4>
<h5>Fenced H5 heading</h5>

<h6>Fenced H6 heading with some spacing!</h6>
```

This is another continuation line.

