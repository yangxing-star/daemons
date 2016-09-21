class IMSyncUserWorker < BaseWorker
  include Sneakers::Worker

  @@queue_name = 'isc.im.user.sync'
  FROM_QUEUE_NAME = Padrino.env == :production ? @@queue_name : "#{@@queue_name}.#{Padrino.env}"
  from_queue FROM_QUEUE_NAME

  @@to_queue_name = 'isc.im.user.inbox'
  TO_QUEUE_NAME = Padrino.env == :production ? @@to_queue_name : "#{@@to_queue_name}.#{Padrino.env}"

  def work(message)
    begin
      Sneakers.logger.info(message.to_s)
      request = IMSyncRequest.new
      request.parse_from_string(message)
      send(get_method_name(request), request.data)

      ack!
    rescue => e
      Sneakers.logger.error(e.backtrace)
    end
  end

  def add_user(data)
    msg = IMSyncAddUser.new
    msg.parse_from_string(data)
    result = client.user_get_token(msg.user_id, msg.user_name, msg.portrait_uri)
    if result.success
      Sneakers.logger.info("RongCloud response: #{result.inspect}")
      BaseWorker.send_msg(get_reponse_pkg(SyncType::ADDUSER, result, data).to_s, TO_QUEUE_NAME)
    else
      # retry
      Sneakers.logger.error("RongCloud response: #{result.inspect}")
    end
  end

  private

  def get_method_name(request)
    call_func(request).gsub('user', '_user')
  end

end
