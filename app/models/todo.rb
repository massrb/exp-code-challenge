require 'net/http'

class Todo < ApplicationRecord
  JsonUrl = "https://jsonplaceholder.typicode.com/todos"

  def self.percentages
    query = %Q(
      select 
        a.user_id, 
        (cast((select count() from todos as b 
          where completed is true and a.user_id = b.user_id) as real) 
          / 
         cast((select count(*) from todos as c 
           where a.user_id = c.user_id) as real)) 
      * 100 as precent 
      from todos as a group by user_id
      )
      ActiveRecord::Base.connection.execute(query)
  end

  def self.load_json
   resp = Net::HTTP.get_response(URI.parse(JsonUrl))
   data = resp.body
   result = JSON.parse(data)
   result.each do |rec|
     Todo.create!(rec.transform_keys { |key| key.to_s.underscore })
   end
  end
end
