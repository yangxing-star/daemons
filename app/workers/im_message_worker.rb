class IMMessageWorker < BaseWorker
  include Sneakers::Worker

  @@queue_name = 'im.message.inbox'
  FROM_QUEUE_NAME = Padrino.env == :production ? @@queue_name : "#{@@queue_name}.#{Padrino.env}"
  from_queue FROM_QUEUE_NAME

  def work(message)
    begin
      Sneakers.logger.info("Receive message: #{message.to_s}")
      request = IMMessage.new
      request.parse_from_string(message)
      
      to = request.to_ids.to_a
      from = request.from_id
      type = build_type(request.type)
      content = build_content(request)
      push_data = request.push_data
      push_content = request.push_content

      result = if request.is_group
                 client.message_group_publish(from, to, type, content, push_content, push_data)
               else
                 client.message_publish(from, to, type, content, push_content, push_data)
               end
      
      if result.success
        Sneakers.logger.info("Success! Rongcloud response: #{result}")
      else
        Sneakers.logger.error("Error! Rongcloud response #{result}")
      end

      ack!
    rescue => e
      Sneakers.logger.error(e.backtrace.join(','))
    end
  end

  def build_type(type)
    type_list = [ 'RC:TxtMsg',
                  'RC:ImgMsg',
                  'RC:VcMsg',
                  'RC:ImgTextMsg',
                  'RC:LBSMsg',
                  'RC:ContactNtf',
                  'RC:InfoNtf',
                  'KLM:SystemMsg',
                  'KLM:WuliuMsg',
                  'KLM:ActivityMsg',
                  'KLM:RebatesMsg',
                  'KLM:OrderMsg',
                  'KLM:AfterSaleMsg',
                  'KLM:FriendMsg' ]
    type_list[type]
  end

  def build_content(req)
    h = {}
    if MessageType::CONTACTNTF == req.type || MessageType::INFONTF == req.type
      h[:message] = req.content unless is_empty?(req.content)
    else
      h[:content] = req.content unless is_empty?(req.content)
    end
    if MessageType::CONTACTNTF == req.type
      h[:sourceUserId] = req.from_id
      h[:targetUserId] = req.to_ids.first
    end

    h[:imageUri]   = req.image_uri unless is_empty?(req.image_uri)
    h[:duration]   = req.duration unless req.duration.nil? || req.duration == 0
    h[:title]      = req.title unless is_empty?(req.title)
    h[:latitude]   = req.latitude unless req.latitude.nil? || req.latitude == 0.0
    h[:longitude]  = req.longitude unless req.longitude.nil? || req.longitude == 0.0
    h[:poi]        = req.poi unless is_empty?(req.poi)
    h[:operation]  = req.operation unless is_empty?(req.operation)
    h[:extra]      = req.extra unless is_empty?(req.extra)
    h.to_json
  end

  def is_empty?(str)
    str.nil? || str.empty?
  end

end
