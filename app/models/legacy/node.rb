class Legacy::Node < Legacy::Base
  self.table_name = 'jk06_arctype'

  has_many :articles, foreign_key: 'typeid'

  def self.main
    where(topid: 0, reid: 0)    
  end

  def root
    return nil if self.topid.zero?
    Legacy::Node.find_by(id: topid)
  end

  def parent
    return nil if self.reid.zero?
    Legacy::Node.find_by(id: reid)
  end

  def children
    Legacy::Node.where(reid: id)
  end
end