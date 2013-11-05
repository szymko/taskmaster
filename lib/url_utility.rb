require 'uri'

module UrlUtility
  def self.add_slash(url)
    url.to_s[-1] == "/" ? url.to_s : url.to_s + "/"
  end

  def self.equal?(url1, url2)
    add_slash(url1) == add_slash(url2)
  end

  def self.remove_fragment(url)
    url.gsub(/#.*$/,'')
  end

end
