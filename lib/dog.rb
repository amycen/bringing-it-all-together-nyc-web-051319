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

  def self.find_by_name(name:)
    sql = <<-SQL
    SELECT * FROM dogs WHERE dogs.name = ?
    SQL

    data = DB[:conn].execute(sql, :name)
    self.new_from_db(data)
  end

  def update(name:)
    id = Dogs.find_by_name(:name).id
    sql = <<-SQL
    UPDATE dogs SET dogs.name = ? WHERE dogs.id = ?
    SQL

    DB[:conn].execute(sql, :name, id)

  end
end
