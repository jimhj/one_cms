class H4::Tagging < H4::Base
  belongs_to :tag, counter_cache: true
  belongs_to :article
end
