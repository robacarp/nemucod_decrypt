module Shared
  KEY_LENGTH = 1024
  PACK_METHOD = 'C1'

  def unpack word
    word.unpack(PACK_METHOD).first
  end

  def pack word
    Array(word).pack(PACK_METHOD)
  end

  def hex2bin word
    word.to_i(16).to_s(2)
  end

  def bin2hex word
    word.to_i(2).to_s(16)
  end
end
