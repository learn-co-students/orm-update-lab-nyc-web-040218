require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade, :id

  def initialize(id=nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
      );
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE students;
    SQL

    DB[:conn].execute(sql)
  end

  def self.create(name, grade)
    student = Student.new(name, grade)
    student.save
  end

  def self.new_from_db(array)#[id, name, grade]
    student = Student.new(array[0], array[1], array[2])
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students
      WHERE name = ?
      ORDER BY id ASC;
    SQL

    Student.new_from_db(DB[:conn].execute(sql, name).flatten)
  end

  def save
    if self.id.nil?
      sql = <<-SQL
        INSERT INTO students (name, grade)
        VALUES (?, ?);
      SQL

      DB[:conn].execute(sql,self.name, self.grade)

      self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM students").flatten[0]
    else
      self.update
    end
  end

  def update
    sql = <<-SQL
      UPDATE students 
      SET name = ?, grade = ?
      WHERE id = ?;
    SQL

    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

  

end
