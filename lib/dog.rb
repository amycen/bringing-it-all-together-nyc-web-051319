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
      Dog.new(id: row[0], name: row[1], breed: row[2])
    end
  end

  def self.find_by_name(name:)
    sql = <<-SQL
    SELECT * FROM dogs WHERE dogs.name = ?
    SQL

    data = DB[:conn].execute(sql, :name)
    self.new_from_db(data)
  end

  def update
    sql = <<-SQL
    UPDATE dogs SET dogs.name = ?, dogs.breed = ? WHERE dogs.id = ?
    SQL

    DB[:conn].execute(sql, self.name, self.breed, self.id)

  end

  def save
    if !self.id
      self.update
    else
      sql = <<-SQL
      INSERT INTO dogs (name, breed) VALUES (?, ?)
      SQL

      DB[:conn].execute(sql, self.name, self.breed)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")
    end
    self
  end
end
