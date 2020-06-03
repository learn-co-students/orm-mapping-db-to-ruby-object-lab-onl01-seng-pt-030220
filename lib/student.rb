require 'pry'

class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # use .new to TEMPORARILY REPRESENT DATA in RUBY
    new_student = self.new #SELF is referring to CLASS itself because it is a class method to begin with
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    return new_student
  end  

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
    SELECT * 
    FROM students 
    WHERE name = ?
    LIMIT 1
    SQL

    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
    #?I really don't understand why we're doing this
    #? or how finding by a name should create instances???
    #? absolutely lost but following pattern..
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

def self.all_students_in_grade_9
 sql = <<-SQL
  SELECT *
  FROM students
  WHERE grade = '9'
 SQL
 DB[:conn].execute(sql).map
end

def self.students_below_12th_grade
  sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade != '12'
  SQL
  DB[:conn].execute(sql).map do |row|
    self.new_from_db(row)
  end
end

def self.all
  #practicing with nonHEREDOC
  sql = "SELECT * FROM students;"
  DB[:conn].execute(sql).map do |r|
    self.new_from_db(r)
  end  
end

def self.first_X_students_in_grade_10(number_x)
  sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade = '10'
    LIMIT ?
  SQL
  DB[:conn].execute(sql, number_x).map do |r|
    self.new_from_db(r)
  end
end


# def self.first_student_in_grade_10
#   sql = "SELECT * FROM students WHERE grade = '10' LIMIT 1;"
#   DB[:conn].execute(sql).map{|row| self.new_from_db(row)}
# end
  
def self.first_student_in_grade_10
  sql = <<-SQL
  SELECT * 
  FROM students 
  WHERE grade = '10' 
  LIMIT 1
  SQL

  DB[:conn].execute(sql).map do |row| 
  self.new_from_db(row)
  end
end
  









  
end #!classEND
