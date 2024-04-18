module DataTrans
  extend ActiveSupport::Concern

  class_methods do
    def string_to_hash_arr(string_hash_arr)
      string_hash_arr.map { |s| eval(s) }
    end

    def generate_blob(lenth)
      return SecureRandom.hex(length)
    end
  end
end
