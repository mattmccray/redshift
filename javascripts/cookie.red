# Class +Cookie+ governs the writing and accessing of cookies in the browser.
# 
class Cookie
  OPTIONS = {
    :path     => false,
    :domain   => false,
    :duration => false,
    :secure   => false,
    :document => Document
  }
  
  # call-seq:
  #   Cookie.new(key, value, options = {}) -> cookie
  # 
  # Returns a new +Cookie+ object with the given parameters.
  # 
  def initialize(key, value, options = {})
    @key     = key
    @options = OPTIONS.merge(options)
    return self.update(value)
  end
  
  # call-seq:
  #   cook.destroy -> cook
  # 
  # Returns _cook_, expired and overwritten with the empty string.
  # 
  def destroy
    self.update('',:duration => -1)
  end
  
  # call-seq:
  #   cook.inspect -> string
  # 
  # Returns a string representing _cook_ and its data.
  # 
  def inspect
    "#<Cookie: @key=#{@key.inspect} @value=#{@value.inspect}>"
  end
  
  # call-seq:
  #   cook.read -> string or nil
  # 
  # Returns _cook_'s string value.
  # 
  def read
    value = `#{@options[:document].native}.cookie.match('(?:^|;)\\s*' + #{Regexp.escape(@key)}._value + '=([^;]*)')`
    return value ? `$q(decodeURIComponent(value[1]))` : ''
  end
  
  # call-seq:
  #   cook.update(value, options = {}) -> cook
  # 
  # Updates _cook_ with the given parameters.
  # 
  def update(str, options = {})
    @options.update(options)
    @value = str
    str = `$q(encodeURIComponent(str._value))`
    str += "; domain=#{@options[:domain]}" if @options[:domain]
    str += "; path=#{@options[:path]}"     if @options[:path]
    if @options[:duration]
      `date = new Date()`
      `date.setTime(date.getTime() + #{@options[:duration]} * 24 * 60 * 60 * 1000)`
      str += "; expires=#{`$q(date.toGMTString())`}"
    end
    str += '; secure' if @options[:secure]
    
    `#{@options[:document].native}.cookie = #{@key}._value + '=' + str._value`
    return self
  end
end