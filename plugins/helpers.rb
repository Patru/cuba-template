module Helpers

  def forwarded?
    env.include? "HTTP_X_FORWARDED_HOST"
  end

  # Generates the absolute URI for a given path in the app.
  # Takes Rack routers and reverse proxies into account.
  def uri(addr = nil, absolute = true, add_script_name = true)
    return addr if addr =~ /\A[A-z][A-z0-9\+\.\-]*:/
    uri = [host = ""]
    if absolute
      host << "http#{'s' if req.ssl?}://"
      if forwarded? or req.port != (req.ssl? ? 443 : 80)
        host << req.host_with_port
      else
        host << req.host
      end
    end
    uri << req.script_name.to_s if add_script_name
    uri << (addr ? addr : req.path_info).to_s
    File.join uri
  end

  alias url uri
  alias to uri

end