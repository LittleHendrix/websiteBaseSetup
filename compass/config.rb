# Require any additional compass plugins here.

# Set environment:
# environment = :production or :development (default)

# Delineate the directory for our SASS/SCSS files (this directory)
# sass_path = File.dirname(__FILE__)

# Set this to the root of your project when deployed:
http_path = "/"
css_dir = "stylesheets"
sass_dir = "sass"
images_dir = "stylesheets/images"
javascripts_dir = "../scripts"
# generated_images_dir = "../css/images"

# You can select your preferred output style here (can be overridden via the command line):
# output_style = :expanded or :nested or :compact or :compressed
output_style = (environment == :production) ? :compressed : :expanded

# To enable relative paths to assets via compass helper functions. Uncomment:
relative_assets = true

# To disable debugging comments that display the original location of your selectors. Uncomment:
# line_comments = false

# If you prefer the indented syntax, you might want to regenerate this
# project again passing --syntax sass, or you can uncomment this:
# preferred_syntax = :sass
# and then run:
# sass-convert -R --from scss --to sass sass scss && rm -rf sass && mv scss sass

sass_options = {:debug_info => true}

#scss sass