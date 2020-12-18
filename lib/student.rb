class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    student = self.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
      SELECT students.id, students.name, students.grade
      FROM students
    SQL

    students = DB[:conn].execute(sql)

    students.collect do |student|
      self.new_from_db(student)
    end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT students.id, students.name, students.grade
      FROM students
      WHERE students.name = ?
      LIMIT 1
    SQL

    student = DB[:conn].execute(sql, name)
    student.collect do |student|
      self.new_from_db(student)
    end.first
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
      SELECT students.id, students.name, students.grade
      FROM students
      WHERE students.grade = 9
    SQL

    students = DB[:conn].execute(sql)
    students.collect do |student|
      self.new_from_db(student)
    end
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT students.id, students.name, students.grade
      FROM students
      WHERE students.grade < 12
    SQL

    students = DB[:conn].execute(sql)
    students.collect do |student|
      self.new_from_db(student)
    end
  end

  def self.first_X_students_in_grade_10(number)
    sql = <<-SQL
      SELECT students.id, students.name, students.grade
      FROM students
      WHERE students.grade = 10
      ORDER BY students.id
      LIMIT ?
    SQL

    students = DB[:conn].execute(sql, number)
    students.collect do |student|
      self.new_from_db(student)
    end
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT students.id, students.name, students.grade
      FROM students
      WHERE students.grade = 10
      ORDER BY students.id
      LIMIT 1
    SQL

    students = DB[:conn].execute(sql)
    students.collect do |student|
      self.new_from_db(student)
    end
  end

  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
      SELECT students.id, students.name, students.grade
      FROM students
      WHERE students.grade = ?
      ORDER BY students.id
    SQL

    students = DB[:conn].execute(sql, grade)
    students.collect do |student|
      self.new_from_db(student)
    end
  end
end
