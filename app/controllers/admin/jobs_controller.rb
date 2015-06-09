class Admin::JobsController < ApplicationController
  
  def index
  end
  
  def match
    Person.comparison
  end
  
  def export
    send_data Person.generate_download([Person.last], AllFilter.new),
              filename: "people_export.json",
              type: "application/json"
  end
  
end

