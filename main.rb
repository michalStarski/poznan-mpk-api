require_relative('./scripts/find_routes.rb')
require_relative('./scripts/timetable.rb')
require 'sinatra'
require 'json'

get '/api' do
    '<p>This is the poznan-mpk-api:</p> 
    <a href="https://github.com/michalStarski/poznan-mpk-api">Github</a>'
end

get '/api/get_routes' do
    from = params['from']
    to = params['to']
    response.headers['Content-Type'] = 'application/json'
    data = Timetable::routes(from, to).to_json
    if data['error']
        status 400
    else
        status 200
    end

    return data
end

get '/api/quick_look' do
    stop = params['stop']
    line = params['line']
    response.headers['Content-Type'] = 'application/json'

    data = Timetable::quick_look(line, stop)

    #Quick_look returns -1 when the stop is the last stop of the route
    #We have to filter it out
    data = data.delete_if { |entry| entry === -1 }
    
    return data.to_json
end
