require 'pry'
class Dog
  attr_accessor :id, :name, :breed

  def initialize(id: nil, name:, breed:)
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

  def self.new_from_db(rows)
    rows.map do |row|
      Dog.new(row[0], row[1], row[2])
    end
  end

  def self.find_by_name(name:)
    sql = <<-SQL
    SELECT * FROM dogs WHERE dogs.name = ?
    SQL

    data = DB[:conn].execute(sql, name)
    self.new_from_db(data)
  end

  def update
    sql = <<-SQL
    UPDATE dogs SET dogs.name = ?, dogs.breed = ? WHERE dogs.id = ?
    SQL
    #binding.pry
    DB[:conn].execute(sql, self.name, self.breed, self.id)
  end

  def save
    #binding.pry
    if self.id
      self.update
    else
      sql = <<-SQL
      INSERT INTO dogs (name, breed) VALUES (?, ?)
      SQL

      DB[:conn].execute(sql, self.name, self.breed)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    end
    self
  end

  def self.create(name:, breed:)
    dog = Dog.new(name: name, breed: breed)
    dog.save
    dog
  end

  def self.find_by_id(id:)
    sql = <<-SQL
    SELECT * FROM dogs WHERE id = ?
    SQL

    data = DB[:conn].execute(sql, id)
    self.new_from_db(data)
  end
end
