module Consts
  module Statuses
    STATUS = {
      OK = 0 => 'OK',
      BLANK = 1 => 'BLANK',
      ERROR = -1 => 'ERROR'
    }.freeze
  end

  module Youtube
    CREDENTIAL_YML_PATH = Rails.root.join('config/youtube/oauth2_credentials.yml')
    LIST_MAX_RESULTS = 50
    REGEXP_URL = %r(\A(https://)?www\.youtube\.com/channel/(?<channel_id>[^/]+).*\z).freeze
    REGEXP_WITHOUT_SLASH = %r(\A[^/]+\z).freeze
  end

  module Job
    RETRY_MAX_COUNT = 3
  end
end
