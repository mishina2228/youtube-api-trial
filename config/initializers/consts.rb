module Consts
  module Statuses
    STATUS = {
      OK = 0 => 'OK',
      BLANK = 1 => 'BLANK',
      ERROR = -1 => 'ERROR'
    }.freeze
  end

  module Youtube
    REGEXP_URL = %r(\A(https://)?www\.youtube\.com/channel/(?<channel_id>[^/]+).*\z)
    REGEXP_WITHOUT_SLASH = %r(\A[^/]+\z)
  end
end