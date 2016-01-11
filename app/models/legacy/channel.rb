class Legacy::Channel < Legacy::Base
  self.table_name = 'jk06_addonspec'

  def name
    str = note.scan(/name=(.*)\snoteid?/).flatten.first rescue ''
    str = str.gsub(/'/, '')
    str
  end

  def keywords
    str = note.scan(/keywords=(.*)\stypeid?/).flatten.first rescue ''
    str = str.gsub(/'/, '') 
    str   
  end
end