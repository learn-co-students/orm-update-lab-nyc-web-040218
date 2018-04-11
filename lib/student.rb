require_relative "../config/environment.rb"
require 'pry'
class Student

    attr_accessor :name, :grade, :id
    def initialize(name, grade, id=nil)
      @name = name
      @grade = grade
      @id = id
    end

    def self.create_table
    sql =  "CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
      );"
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
      INSERT INTO students
      (name, grade)
      VALUES (?, ?)
      SQL

      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
      end
    end

    def self.create(name, grade)
      mk_gallagher = Student.new(name, grade)
      mk_gallagher.save
    end

    def self.new_from_db(attributes)
      # binding.pry
      mk_gallagher = Student.new(attributes[1], attributes[2], attributes[0])
      # mk_gallagher.id = attributes[0]
      # mk_gallagher.name = attributes[1]
      # mk_gallagher.grade = attributes[2]
      # attributes = [1, "Pat", 12]
      mk_gallagher
    end

    def self.find_by_name(name)

      sql = <<-SQL
        SELECT *
        FROM students
        WHERE name= ?
      SQL

      DB[:conn].execute(sql, name).map {|row| Student.new_from_db(row)}.first
    end

    def update
      sql = <<-SQL
        UPDATE students
        SET name= ?, grade= ?
        WHERE id= ?
      SQL
      DB[:conn].execute(sql, self.name, self.grade, self.id)
    end







end
