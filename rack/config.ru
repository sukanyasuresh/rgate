require 'rack/reloader'
require_relative 'services/app'

use Rack::Reloader

run ->(env) {APP.call(env)}
