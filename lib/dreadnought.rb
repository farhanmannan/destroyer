require 'nokogiri'

class Dreadnought
  def initialize(html)
    @html = html
  end
  
  def destroy
    demonise_images
    randomise_capitalisation
    do_character_swaps
    doc.to_html
  end
  
  private
  
  def doc
    @doc ||= Nokogiri::HTML(@html)
  end

  def demonise_images
    doc.css('img').each do |node|
      node[:style] = %q{
         -webkit-transform: matrix(1, 0, 0, -1, 0, 0);
         -webkit-filter: invert(100%);
      }
    end
  end

  def randomly_capitalise(s)
    s = s.split("").map do |character|
      if rand(6) > 4
        character = character.swapcase
      end
      character
    end.join
  end

  def randomise_capitalisation
    doc.xpath("//text()").each do |node|
      node.content = randomly_capitalise(node.content.to_s)
    end
  end

  def random_character_swap(s)
    new_characters = "xjy_*".split("")
    s = s.split("").map do |character|
      if rand(11) > 9
        character = new_characters.sample
      end
      character
    end.join
  end

  def do_character_swaps
    doc.xpath("//text()").each do |node|
      node.content = random_character_swap(node.content.to_s)
    end
  end

end