@asked_fog = false
@add_image_uploads = false
@add_devise = false
@use_fog = false
@add_active_admin = false

def add_and_use_fog
  gsub_file 'Gemfile', '# gem fog', 'gem "fog"'

  run 'bundle'

  aws_bucket = ask("AWS Bucket Name: ")
  aws_key = ask("AWS Key: ")
  aws_secret = ask("AWS Secret: ")

  initializer 'fog.rb', <<-'INIT'
CarrierWave.configure do |config|
config.fog_credentials = {
  :provider              => 'AWS',
  :aws_access_key_id     => ENV['S3_KEY_ID'],
  :aws_secret_access_key => ENV['S3_SECRET']
}
config.fog_directory = ENV['S3_BUCKET']
end
  INIT

  file '.env', <<-'INIT'
S3_BUCKET="# Bucket"
S3_KEY_ID="# Key"
S3_SECRET="# Secret"
  INIT

  gsub_file '.env', '# Bucket', aws_bucket
  gsub_file '.env', '# Key', aws_key
  gsub_file '.env', '# Secret', aws_secret

  git add: "--all"
  git rm: "--cached config/initializers/fog_creds.rb"
  git commit: "-am 'Add Fog'"
end

def handle_devise add_devise
  if add_devise
    gsub_file 'Gemfile', '# gem devise', "gem 'devise'"

    run 'bundle'

    generate 'devise:install'

    generate 'devise:views'

    environment "config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }", env: 'development'

    generate 'devise', 'User'

    rake "db:migrate"

    git add: '--all'
    git commit: "-am 'Add User Login'"
  end
end

def handle_image_uploads add_image_uploads
  if add_image_uploads
    gsub_file 'Gemfile', '# gem carrierwave', 'gem "carrierwave"'
    gsub_file 'Gemfile', '# gem mini_magick', 'gem "mini_magick"'

    run 'bundle'

    generate 'uploader', 'Image'

    inside('app') do
      inside('uploaders') do
        run "rm image_uploader.rb"

        file 'image_uploader.rb', <<-'RUBY'
# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  # storage :fog
  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Create different versions of your uploaded files:
  version :large do
    resize_to_fit(264, 284)
  end

  version :medium do
    resize_to_fit(180, 180)
  end

  version :thumb do
    resize_to_fit(80, 80)
  end

  # File Type White List
  def extension_white_list
    %w(jpg jpeg gif png)
  end

end
        RUBY
      end
    end

    git add: '--all'
    git commit: "-am 'Add Image Uploads'"

    if !@asked_fog
      @use_fog = yes?("Use AWS(for starage)?")
      if @use_fog
        add_and_use_fog()
      end
    end

    if @use_fog
      inside('app') do
        inside('uploaders') do
          gsub_file 'image_uploader.rb', '# storage :fog', 'storage :fog'
          gsub_file 'image_uploader.rb', 'storage :file', ''
        end
      end

      git add: "--all"
      git commit: "-am 'Fix Image Uploads to use fog'"
    end
  end
end

def handle_active_admin add_active_admin
  if add_active_admin
    gsub_file 'Gemfile', '# gem activeadmin, github: "activeadmin"', 'gem "activeadmin", github: "activeadmin"'

    if !@add_devise
      gsub_file 'Gemfile', '# gem devise', 'gem "devise"'
    end

    run 'bundle'

    generate 'active_admin:install'

    rake 'db:migrate'

    git add: "--all"
    git commit: "-am 'Add basic Active Admin'"
  end
end

def additional_options
  @add_devise = yes?("Add Devise(User login)?")
  handle_devise(@add_devise)

  @add_image_uploads = yes?("Add Image Uploads?")
  handle_image_uploads(@add_image_uploads)

  @add_active_admin = yes?("Add Active Admin?")
  handle_active_admin(@add_active_admin)
end


# ---------------------------------
# Begin
# ---------------------------------

run "rm Gemfile"

file "Gemfile", <<-"RUBY"
source "https://rubygems.org"
ruby "2.2.0"

# gem activeadmin, github: "activeadmin"
gem "autoprefixer-rails"
gem "bootstrap-sass"
gem "bower-rails"
gem "browserify-rails"
# gem carrierwave # Great File upload
# gem devise # Great Login
# gem fog # Upload to cloud storage
gem "font-awesome-sass"
# gem fuzzily # Good simple indexing
# gem mini_magick # For Img uploads
gem "modernizr-rails"
gem "nested_form"
# gem "omniauth"
# gem "omniauth-facebook"
# gem "omniauth-twitter"
gem "rack-rewrite"
gem "react-rails", github: "reactjs/react-rails", branch: "master"

# REQUIRED #
gem "rails", "4.2.0"
gem "sass-rails", "~> 5.0"
gem "uglifier", ">= 1.3.0"
gem "coffee-rails", "~> 4.1.0"
gem "jquery-rails"
gem "jbuilder", "~> 2.0"
gem "sdoc", "~> 0.4.0", group: :doc

# FOR HEROKU #
group :production do
  gem "pg"
  gem "rails_12factor"
end

group :development, :test do
  gem "awesome_print"
  gem "better_errors"
  gem "certified"
  gem "dotenv-rails"
  gem "factory_girl_rails"
  gem "pry-rails"
  gem "pry-stack_explorer"
  gem "quiet_assets"
  gem "rspec-rails"
  gem "spring"
  gem "sqlite3"
  gem "guard"
  gem "guard-rspec"
  gem "rubocop"
  gem "rubocop-rspec"
  gem "guard-rubocop"
  gem "database_cleaner"
  gem "faker"
  gem "shoulda-matchers"
  gem "capybara"
  # Access an IRB console on exceptions page and /console in development
  gem "web-console", "~> 2.0.0.beta2"
end
RUBY

run 'bundle'

file '.ruby-version', <<-'VERSION'
ruby-2.2.0-preview1
VERSION

file '.ruby-gemset', <<-'GEMSET'
#APP NAME#
GEMSET

app_name = ask("What is the title of the application?")

puts "You will need to run 'rvm gemset create #{app_name.gsub(' ', '')}'"

gsub_file '.ruby-gemset', '#APP NAME#', app_name.gsub(' ', '')

inside('app') do
  inside('views') do
    inside('layouts') do
      file '_alert.html.erb', <<-'HTML'
<% flash.each do |name, msg| -%>
  <div class="<%= name %> alert alert-warning alert-dismissible" role="alert">
    <button type="button" class="close" data-dismiss="alert"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
    <%= msg %>
  </div>
<% end -%>
      HTML

      file '_meta.html.erb', <<-'HTML'
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no">
<meta name="description" content="">
<meta name="revisit-after" content="30 days">
      HTML

      run "rm application.html.erb"

      file 'application.html.erb', <<-'HTML'
<!DOCTYPE html>
<html>
<head>
  <title>#APP NAME#</title>
  <%= render 'layouts/meta' %>
  <%= stylesheet_link_tag    'application', media: 'all' %>
  <%= javascript_include_tag 'modernizr' %>
  <%= csrf_meta_tags %>
</head>
<body>
  <%= render 'layouts/alert' %>

  <%= yield %>

  <%= javascript_include_tag 'application' %>
</body>
</html>
      HTML

      gsub_file 'application.html.erb', '#APP NAME#', app_name
    end
  end

  route "root 'pages#index'"

  route "get '*any', to: 'pages#not_found'"

  generate(:controller, "pages index")

  inside('controllers') do
    run "rm pages_controller.rb"

    file 'pages_controller.rb', <<-'RUBY'
class PagesController < ApplicationController
  rescue_from ActionController::UnknownFormat, with: :raise_not_found
  after_action :allow_iframe

  def index
  end

  def not_found
    respond_to do |format|
      format.html { render file: "#{Rails.root}/public/404", layout: false, status: :not_found }
      format.xml  { head :not_found }
      format.any  { head :not_found }
    end
  end

  def raise_not_found
    render file: "#{Rails.root}/public/404", layout: false, status: :not_found
  end

  private

  def allow_iframe
    response.headers.except! 'X-Frame-Options'
  end
end
    RUBY
  end

  inside('views') do
    inside('pages') do
      run 'rm index.html.erb'

      file 'index.html.erb', <<-'ERB'
<div id="container">
  <%= react_component('LoadingView', {}, { prerender: true }) %>
</div>
      ERB
    end
  end

  inside('assets') do
    file 'fonts/deleteme.txt', <<-'TXT'
DELETE ME
    TXT

    inside('fonts') do
      run "rm deleteme.txt"
    end

    inside('javascripts') do
      run "rm application.js"

      file 'application.js', <<-'JAVASCRIPT'
//= require jquery
//= require jquery_ujs
//= require jquery_nested_form
//= require bootstrap-sprockets
//= require pnotify
//= require lodash
//= require picturefill
//= require react
//= require react_ujs
//= require components
//= require pages
      JAVASCRIPT

      run "rm pages.js.coffee"

      file 'pages.js', <<-'JAVASCRIPT'
$(document).ready(function() {

});
      JAVASCRIPT


      file 'components.js', <<-'JAVASCRIPT'
// require like this = require components/component_name
//= require components/loading_view
      JAVASCRIPT

      file 'components/loading_view.js.jsx', <<-'JAVASCRIPT'
var LoadingView = React.createClass({
  componentDidMount: function() {
    var Loader = require('../lib/partical_loader').Loader;
    Loader.init('.loading-view');
  },

  render: function() {
    return (
      <div className="loading-view"></div>
    );
  }
});

window.LoadingView = LoadingView;
      JAVASCRIPT

      file 'lib/partical_loader.js', <<-'JAVASCRIPT'
// Modifed from http://codepen.io/jackrugile/pen/JAKbg
(function() {
  var Loader = {};

  Loader.Particle = function( opt ) {
    this.radius = 7;
    this.x = opt.x;
    this.y = opt.y;
    this.angle = opt.angle;
    this.speed = opt.speed;
    this.accel = opt.accel;
    this.decay = 0.01;
    this.life = 1;
  };

  Loader.Particle.prototype.step = function( i ) {
    this.speed += this.accel;
    this.x += Math.cos( this.angle ) * this.speed;
    this.y += Math.sin( this.angle ) * this.speed;
    this.angle += Loader.PI / 64;
    this.accel *= 1.01;
    this.life -= this.decay;

    if( this.life <= 0 ) { Loader.particles.splice( i, 1 ); }
  };

  Loader.Particle.prototype.draw = function( i ) {
    Loader.ctx.fillStyle = Loader.ctx.strokeStyle = 'hsla(' + ( Loader.tick + ( this.life * 120 ) ) + ', 100%, 60%, ' + this.life + ')';
    Loader.ctx.beginPath();
    if( Loader.particles[ i - 1 ] ) {
      Loader.ctx.moveTo( this.x, this.y );
      Loader.ctx.lineTo( Loader.particles[ i - 1 ].x, Loader.particles[ i - 1 ].y );
    }
    Loader.ctx.stroke();

    Loader.ctx.beginPath();
    Loader.ctx.arc( this.x, this.y, Math.max( 0.001, this.life * this.radius ), 0, Loader.TWO_PI );
    Loader.ctx.fill();

    var size = Math.random() * 1.25;
    Loader.ctx.fillRect( ~~( this.x + ( ( Math.random() - 0.5 ) * 35 ) * this.life ), ~~( this.y + ( ( Math.random() - 0.5 ) * 35 ) * this.life ), size, size );
  };

  Loader.step = function() {
    Loader.particles.push( new Loader.Particle({
      x: Loader.width / 2 + Math.cos( Loader.tick / 20 ) * Loader.min / 2,
      y: Loader.height / 2 + Math.sin( Loader.tick / 20 ) * Loader.min / 2,
      angle: Loader.globalRotation + Loader.globalAngle,
      speed: 0,
      accel: 0.01
    }));

    Loader.particles.forEach( function( elem, index ) {
      elem.step( index );
    });

    Loader.globalRotation += Loader.PI / 6;
    Loader.globalAngle += Loader.PI / 6;
  };

  Loader.draw = function() {
    Loader.ctx.clearRect( 0, 0, Loader.width, Loader.height );

    Loader.particles.forEach( function( elem, index ) {
      elem.draw( index );
    });
  };

  Loader.init = function(query) {
    Loader.canvas = document.createElement( 'canvas' );
    Loader.ctx = Loader.canvas.getContext( '2d' );
    Loader.width = Loader.canvas.width = 300;
    Loader.height = Loader.canvas.height = 300;
    Loader.min = Loader.width * 0.5;
    Loader.particles = [];
    Loader.globalAngle = 0;
    Loader.globalRotation = 0;
    Loader.tick = 0;
    Loader.PI = Math.PI;
    Loader.TWO_PI = Loader.PI * 2;
    Loader.ctx.globalCompositeOperation = 'lighter';
    $(query).append( Loader.canvas );
    Loader.loop();
  };

  Loader.loop = function() {
    requestAnimationFrame( Loader.loop );
    Loader.step();
    Loader.draw();
    Loader.tick++;
  };

  exports.Loader = Loader;
}).call(this);
      JAVASCRIPT


    end

    inside('stylesheets') do
      run 'rm application.css'

      file 'application.scss', <<-'SCSS'
@import "bootstrap-sprockets";
@import "bootstrap";
@import "font-awesome-sprockets";
@import "font-awesome";
@import "pnotify/pnotify.core";
@import "pnotify/pnotify.picon";

@import "pages";
@import "loading_view";
      SCSS

      file 'loading_view.scss', <<-'SCSS'
.loading-view {
  position: fixed;
  top: 0;
  bottom: 0;
  right: 0;
  left: 0;
  background-color: rgba(0, 0, 0, 0.8);

  canvas {
    bottom: 0;
    left: 0;
    margin: auto;
    position: absolute;
    right: 0;
    top: 0;
    transform: translateZ(0);
  }
}
      SCSS

      run 'rm pages.scss'

      file 'pages.scss', <<-'SCSS'
/* Smartphones (portrait and landscape) */
@media only screen and (min-device-width: 320px) and (max-device-width: 480px) {
/* Styles */
}

/* Smartphones (landscape) */
@media only screen and (min-width: 321px) {
}

/* Smartphones (portrait) */
@media only screen and (max-width: 320px) {
}

/* iPads (portrait and landscape) */
@media only screen and (min-device-width: 768px) and (max-device-width: 1024px){
}

/* iPads (landscape) */
@media only screen and (min-device-width: 768px) and (max-device-width: 1024px) and (orientation: landscape) {
}

/* iPads (portrait) */
@media only screen and (min-device-width : 768px) and (max-device-width : 1024px) and (orientation : portrait) {
}

/* Desktops and laptops */
@media only screen and (min-width : 1224px) {
}

/* Large screens */
@media only screen and (min-width : 1824px) {
}

/* iPhone 4 */
@media only screen and (-webkit-min-device-pixel-ratio : 1.5), only screen and (min-device-pixel-ratio : 1.5) {
}
      SCSS
    end
  end
end

file 'package.json', <<-'NPM'
{
  "name": "#APP NAME#",
  "devDependencies" : {
  },
  "dependencies" : {
    "browserify": "~> 6.3",
    "browserify-incremental": "^1.4.0"
  },
  "license": "MIT",
  "engines": {
    "node": ">= 0.10"
  }
}
NPM

gsub_file 'package.json', '#APP NAME#', app_name.gsub(' ', '')

run 'npm install'

generate('bower_rails:initialize json')

run 'rm bower.json'

file 'bower.json', <<-'BOWER'
{
  "name": "#APP NAME#",
  "lib": {
    "name": "bower-rails generated lib assets",
    "dependencies": {
    }
  },
  "vendor": {
    "name": "bower-rails generated vendor assets",
    "dependencies": {
      "lodash": "latest",
      "pnotify": "latest",
      "picturefill": "latest"
    }
  }
}
BOWER

gsub_file 'bower.json', '#APP NAME#', app_name.gsub(' ', '')

rake "bower:install"

file '.buildpacks', <<-'BUILD'
https://github.com/heroku/heroku-buildpack-nodejs
https://github.com/heroku/heroku-buildpack-ruby
BUILD

run "rm README.rdoc"

file 'README.md', <<-'README'
# Heroku

To have Heroku deploys:

```bash
heroku config:add BUILDPACK_URL=https://github.com/ddollar/heroku-buildpack-multi.git
```

Try a deploy: it should successfully compile assets.

README

run "rm .gitignore"

file '.gitignore', <<-'CODE'
# Ignore bundler config.
/.bundle

# Ignore the default SQLite database.
/db/*.sqlite3
/db/*.sqlite3-journal

# Ignore all logfiles and tempfiles.
/log/*
!/log/.keep
/tmp

/public/uploads

.env
CODE

inside('config') do
  application_file =  "class Application < Rails::Application
    config.assets.enabled = true
    config.assets.paths << Rails.root.join('app', 'assets', 'fonts')
    config.middleware.use Rack::Deflater
    config.exceptions_app = self.routes
    # Deal with trailing slashes need rack-rewrite gem
    config.middleware.insert_before(Rack::Runtime, Rack::Rewrite) do
      r301 %r{^/(.*)/$}, '/$1'
    end

    # Propagate errors during ActiveRecord callbacks.
    config.active_record.raise_in_transactional_callbacks = true"

  gsub_file 'application.rb', 'class Application < Rails::Application', application_file
end

file ".rspec", <<-"SPEC"
--color
--require spec_helper
SPEC

file ".rubocop.yml", <<-"SPEC"
require: rubocop-rspec

AllCops:
  Exclude:
    - db/schema.rb

AccessorMethodName:
  Enabled: false

ActionFilter:
  Enabled: false

Alias:
  Enabled: false

ArrayJoin:
  Enabled: false

AsciiComments:
  Enabled: false

AsciiIdentifiers:
  Enabled: false

Attr:
  Enabled: false

BlockNesting:
  Enabled: false

CaseEquality:
  Enabled: false

CharacterLiteral:
  Enabled: false

ClassAndModuleChildren:
  Enabled: false

ClassLength:
  Enabled: false

ClassVars:
  Enabled: false

CollectionMethods:
  PreferredMethods:
    find: detect
    reduce: inject
    collect: map
    find_all: select

ColonMethodCall:
  Enabled: false

CommentAnnotation:
  Enabled: false

CyclomaticComplexity:
  Enabled: true

Delegate:
  Enabled: false

DeprecatedHashMethods:
  Enabled: false

Documentation:
  Enabled: false

DotPosition:
  EnforcedStyle: trailing

DoubleNegation:
  Enabled: false

EachWithObject:
  Enabled: false

EmptyLiteral:
  Enabled: false

Encoding:
  Enabled: false

EvenOdd:
  Enabled: false

FileName:
  Enabled: false

FlipFlop:
  Enabled: false

FormatString:
  Enabled: false

GlobalVars:
  Enabled: false

GuardClause:
  Enabled: false

IfUnlessModifier:
  Enabled: false

IfWithSemicolon:
  Enabled: false

InlineComment:
  Enabled: false

Lambda:
  Enabled: false

LambdaCall:
  Enabled: false

LineEndConcatenation:
  Enabled: false

LineLength:
  Max: 80

MethodLength:
  Enabled: true

ModuleFunction:
  Enabled: false

NegatedIf:
  Enabled: false

NegatedWhile:
  Enabled: false

Next:
  Enabled: false

NilComparison:
  Enabled: false

Not:
  Enabled: false

NumericLiterals:
  Enabled: false

OneLineConditional:
  Enabled: false

OpMethod:
  Enabled: false

ParameterLists:
  Enabled: false

PercentLiteralDelimiters:
  Enabled: false

PerlBackrefs:
  Enabled: false

PredicateName:
  NamePrefixBlacklist:
    - is_

Proc:
  Enabled: false

RaiseArgs:
  Enabled: false

RegexpLiteral:
  Enabled: false

SelfAssignment:
  Enabled: false

SingleLineBlockParams:
  Enabled: false

SingleLineMethods:
  Enabled: false

SignalException:
  Enabled: false

SpecialGlobalVars:
  Enabled: false

StringLiterals:
  EnforcedStyle: double_quotes

VariableInterpolation:
  Enabled: false

TrailingComma:
  Enabled: false

TrivialAccessors:
  Enabled: false

VariableInterpolation:
  Enabled: false

WhenThen:
  Enabled: false

WhileUntilModifier:
  Enabled: false

WordArray:
  Enabled: false

# Lint

AmbiguousOperator:
  Enabled: false

AmbiguousRegexpLiteral:
  Enabled: false

AssignmentInCondition:
  Enabled: false

ConditionPosition:
  Enabled: false

DeprecatedClassMethods:
  Enabled: false

ElseLayout:
  Enabled: false

HandleExceptions:
  Enabled: false

InvalidCharacterLiteral:
  Enabled: false

LiteralInCondition:
  Enabled: false

LiteralInInterpolation:
  Enabled: false

Loop:
  Enabled: false

ParenthesesAsGroupedExpression:
  Enabled: false

RequireParentheses:
  Enabled: false

UnderscorePrefixedVariableName:
  Enabled: false

Void:
  Enabled: false
SPEC

file "Guardfile", <<-"SPEC"
replace
SPEC

gsub_file "Guardfile", 'replace', 'group :tdd, halt_on_fail: true do
  guard :rspec, cmd: "bundle exec rspec" do
    require "guard/rspec/dsl"
    dsl = Guard::RSpec::Dsl.new(self)

    # RSpec files
    rspec = dsl.rspec
    watch(rspec.spec_helper) { rspec.spec_dir }
    watch(rspec.spec_support) { rspec.spec_dir }
    watch(rspec.spec_files)

    # Ruby files
    ruby = dsl.ruby
    dsl.watch_spec_files_for(ruby.lib_files)

    # Rails files
    rails = dsl.rails(view_extensions: %w(erb haml slim))
    dsl.watch_spec_files_for(rails.app_files)
    dsl.watch_spec_files_for(rails.views)

    watch(rails.controllers) do |m|
      [
        rspec.spec.("routing/#{m[1]}_routing"),
        rspec.spec.("controllers/#{m[1]}_controller"),
        rspec.spec.("acceptance/#{m[1]}")
      ]
    end

    # Rails config changes
    watch(rails.spec_helper)     { rspec.spec_dir }
    watch(rails.routes)          { "#{rspec.spec_dir}/routing" }
    watch(rails.app_controller)  { "#{rspec.spec_dir}/controllers" }

    # Capybara features specs
    watch(rails.view_dirs)     { |m| rspec.spec.("features/#{m[1]}") }

    # Turnip features and steps
    watch(%r{^spec/acceptance/(.+)\.feature$})
    watch(%r{^spec/acceptance/steps/(.+)_steps\.rb$}) do |m|
      Dir[File.join("**/#{m[1]}.feature")][0] || "spec/acceptance"
    end
  end

  guard :rubocop do
    watch(%r{.+\.rb$})
    watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
  end
end'

inside("spec") do

  file "rails_helper.rb", <<-"SPEC"
ENV["RAILS_ENV"] ||= "test"
require "spec_helper"
require File.expand_path("../../config/environment", __FILE__)
require "rspec/rails"
require "shoulda/matchers"
require "database_cleaner"

# Checks for pending migrations before tests are run
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # Include behaviours based on their file location
  config.infer_spec_type_from_file_location!

  # Load Factory Girl methods
  config.include FactoryGirl::Syntax::Methods

  # Configure DatabaseCleaner to use transaction strategy
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  # Run start DatabaseCleaner and lint factories before tests
  config.before(:suite) do
    begin
      DatabaseCleaner.start
      FactoryGirl.lint
    ensure
      DatabaseCleaner.clean
    end
  end
end
  SPEC

  file "spec_helper.rb", <<-"SPEC"
RSpec.configure do |config|
  # Allow only the new expect syntax
  config.expect_with :rspec do |specs|
    specs.syntax = :expect
    specs.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # Config rspec-mocks to only stub methods that exist in the original object
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  # Use only the recommended sytanx
  config.disable_monkey_patching!

  # Allow more verbose output when running an individual spec file
  if config.files_to_run.one?
    config.default_formatter = "doc"
  end

  # Print the 10 slowest examples and example groups
  config.profile_examples = 10

  # Run specs in random order to surface order dependencies
  config.order = :random
end
  SPEC

end

git :init
git add: '--all'
git commit: "-am 'Initial commit'"

additional_options()
