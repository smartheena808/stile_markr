require 'sqlite3'

class MarkrDB
    
    attr_reader :db, :query
    attr_accessor :data

    def initialize
        create_table
    end

    def create_table
        @db = SQLite3::Database.open ("markr.db")

        @db.execute "CREATE TABLE IF NOT EXISTS TestResults(student_id NUMERIC, first_name TEXT NOT NULL, last_name TEXT, test_id NUMERIC, questions_available INTEGER CHECKED, questions_obtained INTEGER)"

    rescue SQLite3::Exception => err 
        puts "Exception occured: #{err.message}"

    ensure
        @db.close if @db  
    end

    def insert_result(student_id, first_name, last_name, test_id, questions_available, questions_obtained)
   
        @db = SQLite3::Database.open ("markr.db")

        student_count = @db.execute "SELECT COUNT(*) FROM TestResults WHERE test_id = ? AND student_id = ? AND first_name = ? AND last_name = ?",[test_id, student_id, first_name, last_name]
      
        if (student_count.length == 1 and student_count[0][0] != 0)
            query = @db.prepare "SELECT questions_obtained FROM TestResults WHERE test_id = ? AND student_id = ? AND first_name = ? AND last_name = ?"
            old_score = query.execute!(test_id, student_id, first_name, last_name)
            
            # update the student's score with the highest value if there is double submission
            if questions_obtained.to_i > old_score[0][0]
                @db.execute "UPDATE TestResults SET questions_obtained = ? WHERE student_id = ? AND first_name = ? AND last_name = ?", [questions_obtained, student_id, first_name, last_name]
            end
        else
            @db.execute "INSERT INTO TestResults(student_id, first_name, last_name,test_id,questions_available,questions_obtained) VALUES (?, ?, ?, ?, ?, ?)", [student_id, first_name, last_name, test_id, questions_available, questions_obtained]
        end

    rescue SQLite3::Exception => err 
        puts "Exception occured: #{err.message}"

    ensure
        query.close if query
        @db.close if @db
    end

    def get_test_results(test_id)
        @data = []
        @db = SQLite3::Database.open ("markr.db")
        
        query = @db.prepare "SELECT questions_obtained FROM TestResults WHERE test_id = ?"
        rs = query.execute(test_id)

        rs.each do |row|
            @data.push row[0]
        end    
        return @data

    rescue SQLite3::Exception => err 
        puts "Exception occured: #{err.message}"

    ensure
        query.close if query
        @db.close if @db   
    end

end