class Rack::Attack
  throttle('uploads/ip', limit: 5, period: 60) do |req|
    req.ip if req.path == '/upload' && req.post?
  end

  self.throttled_responder = lambda do |env|
    [429, { 'Content-Type' => 'application/json' }, ['{"error":"Too many uploads. Please wait a minute before trying again."}']]
  end
end
