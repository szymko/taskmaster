require 'pry'
class UpdatePages

  def perform(**opts)
    opts[:pages].each do |p|
      res = responses(opts).find { |r| p.url == r.url.to_s }
#      binding.pry
      success?(res) ? insert_response(p, res) : insert_error(p, res)
      p.save
    end

    {}
  end

  private

  def responses(opts)
    opts[:crawler].responses
  end

  def message(opts) #opts => { url: ,code: , type: }
    "Page update #{opts[:type]} with url: #{opts[:url]} "\
    "and status_code: #{opts[:code]}."
  end

  def insert_response(page, response)
    page.create_page_content(body: response.body,
                             status_code: response.status_code)
    page.mark_as("success")
    TaskLogger.log(level: :info, msg: message(url: page.url, type: "success",
                                              code: response.status_code))
  end

  def insert_error(page, response)
    status_code = response && response.status_code

    page.mark_as("error")
    TaskLogger.log(level: :warn, msg: message(url: page.url, type: "error",
                                              code: "#{status_code}"))
  end

  def success?(response)
    response && (response.status_code.to_s =~ /(1|2|3)\d{2}/)
  end

end
