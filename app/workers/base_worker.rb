class BaseWorker

  protected

  def client
    @client ||= Rongyun::Client.new(ENV['app_key'], ENV['app_secret'])
  end

  def call_func(request)
    hash = Hash.new
    SyncType.values.each do |key, value|
      hash[value.to_i] = key.to_s.downcase
    end
    hash[request.type]
  end

  def get_reponse_pkg(type, result, data, extra_data = {})
    res                   = IMSyncResponse.new
    res.error_code        = 0
    res.error_message     = ''
    res.type              = type
    unless result.success
      res.error_code    = -1
      error_response = result.data['error_response']
      res.error_message = "call remote error => msg: #{error_response['msg']} sub_msg: #{error_response['sub_msg']}"
    end
    res.raw_data          = data
    res.extra_data        = extra_data.to_json
    res
  end

  def self.send_msg(data, to_queue)
    Sneakers.logger.info("send_msg => to_queue: #{to_queue}, data: #{data.to_s.force_encoding('UTF-8')}")
    $publisher_pool.with do |publisher|
      publisher.publish(data.to_s, to_queue: to_queue)
    end
  end
end
