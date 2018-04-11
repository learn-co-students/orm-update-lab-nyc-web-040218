require_relative "../config/environment.rb"
require "pry"
class Student

  attr_accessor :name, :grade, :id

  ALL = []

  def initialize(id = nil, name, grade)
    @id = id
    @name = name
    @grade = grade
    ALL << self
  end

  def self.create_table
    sql =  <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
        )
        SQL
    DB[:conn].execute(sql )
  end
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
      DB[:conn].execute(sql)
  end

  def save
    if self.id
    self.update
    else
      sql = <<-SQL
        INSERT INTO students (name, grade)
        VALUES (?, ?)
      SQL

      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
      # binding.pry
    end
  end

  def self.create(name, grade)
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, name,grade)
  end

  def self.new_from_db(arr)
    student = Student.new(arr[0], arr[1], arr[2])
    student

  end

  def self.find_by_name(name)
    sql = " SELECT * from students where name = ?"
    result = DB[:conn].execute(sql, name)[0]
    Student.new(result[0], result[1], result[2])
  end


  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

end
