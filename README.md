
# sherpa

Documentation generator for various languages.

## What it contains

### Sherpa
Sherpa parses files and outputs a json file with relevant sections converted from markdown to html. It can be loaded from a Rails app, Sinatra app or from the command line. It should accept a list of files (globbed, yaml, or json), output directory/filename, overview file. The contents of Sherpa looks like:

- Builder: accepts an array of files and outputs json
- Parser: parses a file for sherpa comment blocks
- Renderer: renders sections to markdown
- Utilities: helpers for stripping comments, determining block types, languages, etc..

Theoretically, this json file can be used by any sort of renderer. A user could write their own layout engine, or send it to something like [mad](https://github.com/visionmedia/mad) for man style pages.


### Sherpa Layouts
Sherpa layouts utilize a configuration file to output markup from Sherpa parsed files. It needs to augment the returned ruby object from sherpa and merge in the settings from the configuration file (`json|yaml`) which describes various properties associated with rendering layouts (see configuration options below). It then renders the augmented configuration file to a mustache template based off of mustache sections.

- Configuration File: `json|yaml` file applicable for layouts
- Builder: reads the configuration file and sends out files to Sherpa's parser/renderer
- Layout Renderer: renders the layout to sections and finally the page
- Layouts:
  - `layout.mustache`: the shell page
  - `default_section.mustache`: the default section used if there is no default `language.mustache`
  - `language.mustache`: the default section used by most templates for a given language (include 1 for each language type)
  - `alternatives.mustache`: a few alternative sections (mainly for the style guides)


## Use Cases

### Sherpa no layout
Typically from the command line, but can come from Rails/Sinatra

- Determine if the files are globbed or coming from a `json|yaml` file
- If coming from a configuration file, load that file and convert into an array of files
- Unless not set, see if there is a README file in the base directory to use as an overview
- Send each file out to the parser
  - Parser reads each file line by line
  - Once it comes to a sherpa block (denoted with `//~`)
  - Add the current block to a `@blocks` array (there can be multiple sherpa blocks within a single file)
  - Create `raw` key to store the entire comment block
  - Create `filename` key to store the current file name (stripped as `parent_dir/filename`)
  - Create a `current_key` as a summary` key to store the initial description
  - Continue and strip off the comment markers
  - Trim left spacing unless in an `examples` or `usage` block (need to maintain formatting for markdown conversion)
  - Determine if the current line is a header (if line ends in `:` it gets converted to an `h3`)
  - If it is a header, set a new `current_key` as the name of the header
  - Determine if the `current_key` is `examples`, this will get stored in a separate object for style guides
  - If the line is under the `examples` block, format and store it for rendering in both pre and inline markup
  - Store the modified comment line in both the `raw` key and `current_key`
  - Continue and scrub next line or clean the examples for further formatting
  - Once complete, look for other sherpa blocks, if found repeat otherwise return the `@blocks` array
- Send out the current file's comment blocks to the `Renderer`
- The `Renderer` parses each key and converts to markdown using redcarpet unless it's the `raw` or `examples` key
- `Renderer` returns the existing block back to push into an array
- Add a few other settings to the object: publication time, publisher, etc..
- Once complete for each file, Sherpa converts the object to json and saves the file

### Sherpa with Layout
Typically from Rails/Sinatra, but could come from the command line as well

- Load the configuration `json|yaml` file which contains the settings related to rendering a layout
- Set defaults for anything related to the configuration file
- Find the file list within the configuration file and send to Sherpa for parsing (Sherpa only returns the parsed ruby object)
- Merge the configuration file and the sherpa output (mainly creating templates associated with files and any other relevant information)
- Render each section with their associated template (templates should be cached once read in)
- Render and write the layout to an html file
- Optionally save the raw json file as well


## Configuration file for layouts

The configuration file is only applicable when generating layouts. Sherpa can run without it based on a listing of files and a few other properties.

- Top level objects for setting defaults across all _pages_
  - `layout_dir`: defaults to a layout dir included with the gem
  - `layout_file`: defaults to a `layout.mustache` included with the gem
  - `default_section_template`: defaults to a `layout.mustache` included with the gem
  - `output_dir`: not sure where to store this
- Broken into pages `"page":"styles"`
- Each page represents a language (cs|js, sass|scss|css, html, ruby, etc..)
- Each page object has: (navigation name inferred from `"page"`)
  - `base_dir`: no default
  - `overview_file`: based off the `readme.md` file located in the `base_dir`
  - `layout_dir`: overrides top level property
  - `layout_file`: overrides top level property
  - `default_section_template`: overrides top level property
  - `output_dir`: overrides top level property
  - `section`: used for navigation items
    - `section.name`: navigation category
    - `section.manifest`: array of `file` and `template` overrides (navigation name inferred from `File.basename`)

## External Dependencies

- `json`
- `redcarpet`
- `mustache` (only for layouts)

## Future

- Abstract the Renderer so if someone wants to use Bluecloth, Discount or some other library they can
- Possibly rewrite in C and use Ruby or Node bindings to make platform and framework agnostic

