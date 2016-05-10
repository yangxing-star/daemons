require 'protobuf/message/message'
require 'protobuf/message/enum'
require 'protobuf/message/service'
require 'protobuf/message/extend'

class MessageType < ::Protobuf::Enum
  defined_in __FILE__
  TXTMSG = value(:TXTMSG, 0)
  IMGMSG = value(:IMGMSG, 1)
  VCMSG = value(:VCMSG, 2)
  IMGTEXTMSG = value(:IMGTEXTMSG, 3)
  LBSMSG = value(:LBSMSG, 4)
  CONTACTNTF = value(:CONTACTNTF, 5)
  INFONTF = value(:INFONTF, 6)
  SYSTEMMSG = value(:SYSTEMMSG, 7)
  WULIUMSG = value(:WULIUMSG, 8)
  ACTIVITYMSG = value(:ACTIVITYMSG, 9)
  REBATESMSG = value(:REBATESMSG, 10)
  ORDERMSG = value(:ORDERMSG, 11)
  AFTERSALEMSG = value(:AFTERSALEMSG, 12)
  FRIENDMSG = value(:FRIENDMSG, 13)
end
class IMMessage < ::Protobuf::Message
  defined_in __FILE__
  required :MessageType, :type, 1
  required :bool,        :is_group, 2
  required :string,      :from_id, 3
  repeated :string,      :to_ids, 4
  optional :string,      :content, 5
  optional :string,      :image_uri, 6
  optional :int32,       :duration, 7
  optional :string,      :title, 8
  optional :float,       :latitude, 9
  optional :float,       :longitude, 10
  optional :string,      :poi, 11
  optional :string,      :operation, 12
  optional :string,      :sourceuserid, 13
  optional :string,      :targetuserid, 14
  optional :string,      :extra, 15
  optional :bool,        :is_broadcast, 16
  optional :string,      :push_content, 17
  optional :string,      :push_data, 18
end