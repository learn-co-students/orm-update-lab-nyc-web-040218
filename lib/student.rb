require_relative "../config/environment.rb"
require 'pry'

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INT)
      SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table

    DB[:conn].execute("DROP TABLE students")

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
    end
  end

  def self.create(name, grade)
    new_stu = self.new(name, grade)
    new_stu.save
  end

  def self.new_from_db(a)
    #create new student object with params from db [id, name, grade]
    new(a[1],a[2],a[0])
  end

  def self.find_by_name(name_string)

    sql = <<-SQL
    SELECT * FROM students
    WHERE name = ?
    SQL

    stu_params = DB[:conn].execute(sql, name_string)
    stu = new_from_db(stu_params[0])
    stu
  end

  def update
    sql = <<-SQL
    UPDATE students
    SET name = ?, grade = ?, id = ?
    SQL

    DB[:conn].execute(sql, self.name, self.grade, self.id)
    self
  end
end
