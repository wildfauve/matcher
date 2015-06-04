class Admin::JobsController < ApplicationController
  
  def index
  end
  
  def match
    Person.comparison
  end
  
  def export
    @people = Person.where(full_name: "Adam David Davey")
    send_data Person.generate_download(@people),
              filename: "people_export.json",
              type: "application/json"
  end
  
end

