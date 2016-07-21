class H4::Base < ActiveRecord::Base
  self.abstract_class = true
  establish_connection(Setting.h4_db)
end