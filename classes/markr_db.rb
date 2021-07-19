require 'sqlite3'

class MarkrDB
    
    attr_reader :db, :query
    attr_accessor :data

    def initialize
        create_table
    end

    def create_table
        @db = SQLite3::Database.open ("markr.db")

        @db.execute "CREATE TABLE IF NOT EXISTS TestResults(student_id NUMERIC UNIQUE, first_name TEXT NOT NULL, last_name TEXT, test_id NUMERIC, questions_available INTEGER CHECKED, questions_obtained INTEGER)"

    rescue SQLite3::Exception => err 
        puts "Exception occured: #{err.message}"

    ensure
        @db.close if @db  
    end

    def insert_result(student_id, first_name, last_name, test_id, questions_available, questions_obtained)
   
        @db = SQLite3::Database.open ("markr.db")

        @db.execute "INSERT INTO TestResults(student_id, first_name, last_name,test_id,questions_available,questions_obtained) VALUES (?, ?, ?, ?, ?, ?)", [student_id, first_name, last_name, test_id, questions_available, questions_obtained]

    rescue SQLite3::Exception => err 
        puts "Exception occured: #{err.message}"

    ensure
        @db.close if @db
    end

    def get_test_results(test_id)
        @data = []
        @db = SQLite3::Database.open ("markr.db")

        @query = @db.prepare "SELECT questions_obtained FROM TestResults WHERE test_id = ?"
        @rs = query.execute(test_id)

        @rs.each do |row|
            @data.push row[0]
        end    
        return @data

    rescue SQLite3::Exception => err 
        puts "Exception occured: #{err.message}"

    ensure
        @query.close if @query
        @db.close if @db   
    end

end