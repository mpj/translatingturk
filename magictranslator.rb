require 'net/https'

file = File.new("bajs.po", "r")

class String

  def gettext_context?()
    self[0..6] == 'msgctxt'
  end

  def gettext_id?()
    self[0..4] == 'msgid'
  end

  # Gets the content of a gettext line. If the line is
  # msgid "Authorize now"
  # this will return the string "Authorize now" (without the quotes)
  def gettext_content
    self[(self.index('"')+1)..-3]
  end

end

class Translatable
  attr_accessor :id, :source, :target
end

# TODO take only untranslated
# TODO handle multiline
# TODO handle insufficient credits (  412 "Precondition Failed" (Net::HTTPServerException)

@translatables = Array.new
while (line = file.gets)
  if line.gettext_context?
    if @current_translatable
      @translatables.push(@current_translatable)
    end
    @current_translatable = Translatable.new
    @current_translatable.id = line.gettext_content
  elsif line.gettext_id? && @current_translatable
    @current_translatable.source = line.gettext_content
  end
end
file.close

@translatables.each do |t|
  http = Net::HTTP.new('sandbox.onehourtranslation.com', 443)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  #url = URI.parse('https://sandbox.onehourtranslation.com/api/1/project/new/')
  url = URI.parse('https://sandbox.onehourtranslation.com/api/1/project/13246/details/?account_id=300&secret_key=0544ea06fbb37917bae806bc4d20419e')

 # args = {
 #    'account_id' => '300',
 #    'secret_key' => "0544ea06fbb37917bae806bc4d20419e",
 #    'source' => 'en-us',
 #    'target' => 'fr-fr',
 #    'source_text' => "dsadssdadas",
 #    'notes' => "translate this yay",
 #    'project_reference' => t.id
 # }


  req = Net::HTTP::Get.new(url.path)
  http = Net::HTTP.new(url.host, url.port)
  #http.use_ssl = true
  #http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  res = http.start {|http| http.request(req) }
  case res
  when Net::HTTPSuccess, Net::HTTPRedirection
    print "hai"
  else
    res.error!
  end

  #req = Net::HTTP::Post.new(url.path)
  #req.set_form_data(post_args)
  #http = Net::HTTP.new(url.host, url.port)
  #http.use_ssl = true
  #http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  #res = http.start {|http| http.request(req) }
  #case res
  #when Net::HTTPSuccess, Net::HTTPRedirection
  #  print "hai"
  #else
  #  res.error!
  #  # 412 "Precondition Failed" (Net::HTTPServerException on insufficient credits
  #end

end

