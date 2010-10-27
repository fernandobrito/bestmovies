#encoding: utf-8

# It turns out that when calling to_s on a node, it converts &nbsp; into something that is whitespace but not stripped out by
# the normal strip function.  I modified the strip function of the String class and all worked well.

# http://www.jasonrowland.com/2010/02/html-dom-in-ruby-with-nokogiri/

class String
  alias_method :strip_old, :strip
  def strip
    self.gsub(/^[\302\240|\s]*|[\302\240|\s]*$/, '')
  end

  def strip!
    before = self.reverse.reverse
    self.gsub!(/^[\302\240|\s]*|[\302\240|\s]*$/, '')
    before == self ? nil : self
  end

  def fix_spaces
    self.gsub "[\302\240|\s]", ""
  end

  def fix_to_query
    string = self

    string = string.fix_spaces
    string.gsub! /[%&$#"]/, ""
    string.gsub!(/[^\x20-\x7E]/, '')
    string.gsub! /[aãâáàÃÂÁÀ]/, "a"
    string.gsub! /[eẽêéèẼÊÉÈ]/, "e"
    string.gsub! /[iĩîíìĨÎÍÌ]/, "i"
    string.gsub! /[oõôóòÕÔÓÒ]/, "o"
    string.gsub! /[uũûúùŨÛÚÙ]/, "u"
    string.gsub! /[cçÇ]/, "c"
    string.gsub! '"', " "
    string.gsub! " ", "%20"

    string
  end
end


# Comes in "16 de outubro" format
def parse_portuguese_date(string)
  string = string.sub(" de", "")

  months = { "Janeiro" => "january", "Fevereiro" => "february", "Março" => "march", "Abril" => "april", "Maio" => "may",
             "Junho" => "june", "Julho" => "july", "Agosto" => "august", "Setembro" => "september", "Outubro" => "october",
             "Novembro" => "november", "Dezembro" => "december"
             }

  months.each do |portuguese, english|
    string = string.sub(portuguese.downcase, english) if string.include?(portuguese.downcase)
  end

  Time.parse(string)
end

