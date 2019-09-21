class JobUtils
  class << self
    def enqueue(klass, options = {})
      if Rails.env.test?
        Rails.logger.info('テスト環境ではキューに追加せずに即実行します。')
        klass.perform(options)
      else
        Resque.enqueue(klass, options)
      end
    end

    def enqueue_to(queue, klass, options = {})
      if Rails.env.test?
        Rails.logger.info('テスト環境ではキューに追加せずに即実行します。')
        klass.perform(options)
      else
        Resque.enqueue_to(queue, klass, options)
      end
    end

    def enqueue_in(seconds_from_now, klass, options = {})
      if Rails.env.test?
        Rails.logger.info('テスト環境ではキューに追加せずに即実行します。')
        klass.perform(options)
      else
        Resque.enqueue_in(seconds_from_now, klass, options)
      end
    end

    def enqueue_in_with_queue(queue, seconds_from_now, klass, options = {})
      if Rails.env.test?
        Rails.logger.info('テスト環境ではキューに追加せずに即実行します。')
        klass.perform(options)
      else
        Resque.enqueue_in_with_queue(queue, seconds_from_now, klass, options)
      end
    end

    def schedule
      if Rails.env.test?
        Rails.logger.info('テスト環境では空のハッシュを返します。')
        {}
      else
        Resque.schedule
      end
    end

    def set_schedule(name, schedule_config)
      if Rails.env.test?
        Rails.logger.info('テスト環境ではスケジュール追加をスキップします。')
        return
      end
      Resque.set_schedule(name, schedule_config)
    end

    def remove_schedule(name)
      if Rails.env.test?
        Rails.logger.info('テスト環境ではスケジュール削除をスキップします。')
        return
      end
      Resque.remove_schedule(name)
    end

    def peek(queue, start, count)
      if Rails.env.test?
        Rails.logger.info('テスト環境では空の配列を返します。')
        []
      else
        Resque.peek(queue, start, count)
      end
    end
  end
end
