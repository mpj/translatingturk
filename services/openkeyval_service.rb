require 'net/http'

class OpenKeyValueService

  def self.write(key, value)
    Net::HTTP.post_form(URI.parse("http://api.openkeyval.org/#{key}"), { :data => 'value456' })
  end

  def self.read(key)
    Net::HTTP.get(URI.parse("http://api.openkeyval.org/#{key}"))
  end

end