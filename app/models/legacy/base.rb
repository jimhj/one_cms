class Legacy::Base < ActiveRecord::Base
  self.abstract_class = true

  conf = {
    host: '127.0.0.1',
    adapter: 'mysql2',
    encoding: 'utf8',
    username: 'root',
    password: '0819',
    database: 'jk06'    
  }

  establish_connection conf
end