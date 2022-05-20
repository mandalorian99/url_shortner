module Generatable
  extend ActiveSupport::Concern

  def relative_short_code_len
    rows_count = ShortUrl.count
    n = ShortUrl::CHARACTERS.length
    base_range = 1
    short_code_lenth = 1
    nCr = combinations.(n)
     
    for r in (1..n)
      total_combinations = nCr.(r)
      if rows_count > base_range and rows_count < total_combinations
        short_code_lenth = r
        break
      end
      base_range = total_combinations
    end

    return short_code_lenth
 end
 
 def combinations
    factorial = ->(n) { Array(1..n).reduce(&:*) || 1}
    
    return (
      -> (n) do
        -> (r) do
          factorial.(n) / (factorial.(r) * factorial.(n-r) )
        end
      end
    )
end

def gen_short_code
  ShortUrl::CHARACTERS.sample(relative_short_code_len).join
end

def is_unique?(short_code)
  !ShortUrl.exists?(shortcode: short_code)
end
end