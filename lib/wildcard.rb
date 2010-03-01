class Wildcard
  def self.expand(*args)
    new(*args).expand
  end

  def initialize(text)
    @text = Array(text)
  end

  def expand
    texts = @text
    texts = texts.map{|i| expand_range(i)}.flatten.uniq
    texts = texts.map{|i| expand_selection(i)}.flatten.uniq
    texts
  end

  private
    def expand_range(text)
      if text =~ /\{(.*?)\.\.(.*?)\}/
        ($1..$2).map{|i| expand_range("#{$`}#{i}#{$'}")}
      else
        text
      end
    end

    def expand_selection(text)
      if text =~ /\{(.*?,.*?)\}/
        b,text,a = $`,$1,$'
        array = text.split(/,/).map{|i| expand_range("#{b}#{i}#{a}") }
        array << "#{b}#{a}" if text[-1] == ?,
        array
      else
        text
      end
    end
end
