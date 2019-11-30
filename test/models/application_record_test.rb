require 'test_helper'

class ApplicationRecordTest < ActiveSupport::TestCase
  def test_proper_per
    assert_equal 1, ApplicationRecord.proper_per(1)
    assert_equal 1, ApplicationRecord.proper_per('1')
    assert_equal ApplicationRecord::DEFAULT_PER, ApplicationRecord.proper_per(0)
    assert_equal ApplicationRecord::DEFAULT_PER, ApplicationRecord.proper_per('0')
    assert_equal ApplicationRecord::DEFAULT_PER, ApplicationRecord.proper_per(-1)
    assert_equal ApplicationRecord::DEFAULT_PER, ApplicationRecord.proper_per('-1')

    assert_equal ApplicationRecord::DEFAULT_PER, ApplicationRecord.proper_per('')
    assert_equal ApplicationRecord::DEFAULT_PER, ApplicationRecord.proper_per(nil)

    per = ApplicationRecord::MAX_PER
    assert_equal ApplicationRecord::MAX_PER, ApplicationRecord.proper_per(per)
    assert_equal ApplicationRecord::MAX_PER, ApplicationRecord.proper_per(per.to_s)
    per = ApplicationRecord::MAX_PER + 1
    assert_equal ApplicationRecord::MAX_PER, ApplicationRecord.proper_per(per)
    assert_equal ApplicationRecord::MAX_PER, ApplicationRecord.proper_per(per.to_s)
  end
end
