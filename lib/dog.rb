class Dog
  attr_accessor :id, :name, :breed
  
  def initialize(id:, name:, breed:)
    @id, @name, @breed = id, name, breed
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE dogs
      (id INTEGER PRIMARY KEY,
        name TEXT,
        breed TEXT
      );
    SQL
    DB[:conn].execute(sql)  
  end

  def self.drop_table
    sql = <<-SQL
    DROP TABLE IF EXISTS dogs
    SQL

    DB[:conn].execute(sql)
  end

  
end