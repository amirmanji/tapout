class Log
  class <<self
    def hide_log
      set_log(nil)
      true
    end

    def show_log
      set_log(STDOUT)
      true
    end

    def set_log(stream)
      ActiveRecord::Base.logger = ::Logger.new(stream)
      ActiveRecord::Base.clear_all_connections!
    end
  end
end

