class AppLogger
  def uuid
    SecureRandom.uuid[0..7]
  end

  def info(msg, uid = nil)
    log msg, 'INFO', uid
  end

  def debug(msg, uid = nil)
    log msg, 'DEBUG', uid
  end

  def warn(msg, uid = nil)
    log msg, 'WARN', uid
  end

  def error(msg, uid = nil)
    log msg, 'ERROR', uid
  end

  private
  def log(msg, level, uid = nil)
    uid ||= self.uuid
    puts "[#{Time.now}][#{Time.now.to_f.to_s}][#{level}][#{uid}] #{msg}"
  end
end