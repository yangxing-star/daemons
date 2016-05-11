class IMGroupSyncWorker < BaseWorker
  include Sneakers::Worker

  @@queue_name = 'im.group.sync'
  FROM_QUEUE_NAME = ENV['mq_env'] == :production ? @@queue_name : "#{@@queue_name}.#{Padrino.env}"
  from_queue FROM_QUEUE_NAME

  @@to_queue_name = 'im.group.inbox'
  TO_QUEUE_NAME = Padrino.env == :production ? @@to_queue_name : "#{@@to_queue_name}.#{Padrino.env}"

  def work(message)
    begin
      Sneakers.logger.info(message.to_s)
      request = IMSyncRequest.new
      request.parse_from_string(message)
      send(get_method_name(request), request.data)

      ack!
    rescue => e
      Sneakers.logger.error(e.backtrace.join(','))
    end
  end

  def create_group(data)
    msg = IMSyncCreateGroup.new
    msg.parse_from_string(data)
    result = client.group_create(msg.user_ids, msg.group_id, msg.group_name)
    if result.success
      Sneakers.logger.info("RongCloud response(create_group): #{result.inspect}")
      BaseWorker.send_msg(get_reponse_pkg(SyncType::CREATEGROUP, result, data).to_s, TO_QUEUE_NAME)
    else
      Sneakers.logger.error("create_group: #{result.inspect}")
    end
  end

  def join_group(data)
    msg = IMSyncJoinGroup.new
    msg.parse_from_string(data)
    result = client.group_create(msg.user_ids, msg.group_id, msg.group_name)
    if result.success
      Sneakers.logger.info("RongCloud response(join_group): #{result.inspect}")
      BaseWorker.send_msg(get_reponse_pkg(SyncType::JOINGROUP, result, data).to_s, TO_QUEUE_NAME)
    else
      Sneakers.logger.error("create_group: #{result.inspect}")
    end
  end

  def quit_group(data)
    msg = IMSyncQuitGroup.new
    msg.parse_from_string(data)
    result = client.group_quit(msg.user_id, msg.group_id)
    if result.success
      Sneakers.logger.info("RongCloud response(quit_group): #{result.inspect}")
      BaseWorker.send_msg(get_reponse_pkg(SyncType::QUITGROUP, result, data).to_s, TO_QUEUE_NAME)
    else
      Sneakers.logger.error("quit_group: #{result.inspect}")
    end
  end

  def kick_out_group(data)
    msg = IMSyncKickOutGroup.new
    msg.parse_from_string(data)

    send_message(message)
    result = client.group_quit(msg.user_id, msg.group_id)
    if result.success
      Sneakers.logger.info("RongCloud response(kick_out_group): #{result.inspect}")
      BaseWorker.send_msg(get_reponse_pkg(SyncType::KICKOUTGROUP, result, data).to_s, TO_QUEUE_NAME)
    else
      Sneakers.logger.error("kick_out_group: #{result.inspect}")
    end
  end

  def dismiss_group(data)
    msg = IMSyncDismissGroup.new
    msg.parse_from_string(data)

    send_message(message)
    result = client.dismiss_group(msg.user_id, msg.group_id)
    if result.success
      Sneakers.logger.info("RongCloud response(dismiss_group): #{result.inspect}")
      BaseWorker.send_msg(get_reponse_pkg(SyncType::DISMISSGROUP, result, data).to_s, TO_QUEUE_NAME)
    else
      Sneakers.logger.error("dismiss_group: #{result.inspect}")
    end
  end

  private
  def get_method_name(request)
    call_func(request).gsub('group', '_group')
  end

  def send_message(message)
    if message.enable_ms
      attach = JSON.parse(message.attach)
      result = client.message_group_publish( attach['from_id'],
                                             attach['to_ids'].to_a,
                                             type,
                                             { message: attach['content'], extra: attach['extra'] }.to_json,
                                             nil,
                                             nil )
      Sneakers.logger.info("send group message: #{attach.inspect}")
      raise StandardError, result.data['errorMessage'] unless result.success
    end
  end

end
