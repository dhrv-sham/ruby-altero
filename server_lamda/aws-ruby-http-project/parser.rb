require 'json'

def parse_funct(event:, context:)
  {
    statusCode: 200,
    body: JSON.generate({
      message: "Environment check",
      version: ENV['VERSION'],
      feature: ENV['FEATURE_FLAG']
    })
  }
end
