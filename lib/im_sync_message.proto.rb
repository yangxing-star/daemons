require 'protobuf/message/message'
require 'protobuf/message/enum'
require 'protobuf/message/service'
require 'protobuf/message/extend'

class SyncType < ::Protobuf::Enum
  defined_in __FILE__
  ADDUSER = value(:ADDUSER, 0)
  REFRESHUSER = value(:REFRESHUSER, 1)
  USERCHECKONLINE = value(:USERCHECKONLINE, 2)
  ADDBLACKLIST = value(:ADDBLACKLIST, 3)
  REMOVEBLACKLIST = value(:REMOVEBLACKLIST, 4)
  BLOCKUSER = value(:BLOCKUSER, 5)
  UNBLOCKUSER = value(:UNBLOCKUSER, 6)
  QUERYBLOCKUSER = value(:QUERYBLOCKUSER, 7)
  CREATEGROUP = value(:CREATEGROUP, 8)
  DISMISSGROUP = value(:DISMISSGROUP, 9)
  JOINGROUP = value(:JOINGROUP, 10)
  QUITGROUP = value(:QUITGROUP, 11)
  KICKOUTGROUP = value(:KICKOUTGROUP, 12)
  QUERYGROUPUSER = value(:QUERYGROUPUSER, 13)
  SYNCGROUP = value(:SYNCGROUP, 14)
  GROUPUSERGAGADD = value(:GROUPUSERGAGADD, 15)
  GROUPUSERGAGROLLBACK = value(:GROUPUSERGAGROLLBACK, 16)
  GROUPUSERGAGLIST = value(:GROUPUSERGAGLIST, 17)
  ADDWORDFILTER = value(:ADDWORDFILTER, 18)
  DELETEWORDFILTER = value(:DELETEWORDFILTER, 19)
  WORDFILTERLIST = value(:WORDFILTERLIST, 20)
end
class IMSyncRequest < ::Protobuf::Message
  defined_in __FILE__
  required :SyncType, :type, 1
  required :string, :data, 2
  optional :string, :callback_data, 3
end
class IMSyncResponse < ::Protobuf::Message
  defined_in __FILE__
  required :int32, :error_code, 1
  required :string, :error_message, 2
  required :SyncType, :type, 3
  required :string, :raw_data, 4
  required :string, :extra_data, 5
end
class IMSyncAddUser < ::Protobuf::Message
  defined_in __FILE__
  required :string, :user_id, 1
  required :string, :user_name, 2
  required :string, :portrait_uri, 3
  required :string, :user_type, 4
end
class IMSyncRefreshUser < ::Protobuf::Message
  defined_in __FILE__
  required :string, :user_id, 1
  required :string, :user_name, 2
  required :string, :portrait_uri, 3
end
class IMSyncAddUserExtra < ::Protobuf::Message
  defined_in __FILE__
  required :string, :token, 1
end
class IMSyncAddBlacklist < ::Protobuf::Message
  defined_in __FILE__
  required :string, :user_id, 1
  required :string, :black_user_id, 2
end
class IMSyncRemoveBlacklist < ::Protobuf::Message
  defined_in __FILE__
  required :string, :user_id, 1
  required :string, :black_user_id, 2
end
class IMSyncCreateGroup < ::Protobuf::Message
  defined_in __FILE__
  required :string, :group_id, 1
  required :string, :group_name, 2
  repeated :string, :user_ids, 3
end
class IMSyncKickOutGroup < ::Protobuf::Message
  defined_in __FILE__
  required :string, :group_id, 1
  repeated :string, :user_ids, 2
  required :bool,   :enable_ms, 3
  optional :string, :attach, 4
end
class IMSyncDismissGroup < ::Protobuf::Message
  defined_in __FILE__
  required :string, :group_id, 1
  required :string, :user_id, 2
  required :bool,   :enable_ms, 3
  optional :string, :attach, 4
end
class IMSyncJoinGroup < ::Protobuf::Message
  defined_in __FILE__
  required :string, :group_id, 1
  optional :string, :group_name, 2
  repeated :string, :user_ids, 3
end
class IMSyncQuitGroup < ::Protobuf::Message
  defined_in __FILE__
  required :string, :group_id, 1
  repeated :string, :user_ids, 2
end
class IMSyncGroupUserGagAdd < ::Protobuf::Message
  defined_in __FILE__
  required :string, :group_id, 1
  required :string, :user_id, 2
  optional :int32, :minute, 3
end
class IMSyncGroupUserGagRollback < ::Protobuf::Message
  defined_in __FILE__
  required :string, :group_id, 1
  required :string, :user_id, 2
end
class IMSyncGroupUserGagList < ::Protobuf::Message
  defined_in __FILE__
  required :string, :group_id, 1
end