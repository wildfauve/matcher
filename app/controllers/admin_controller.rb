class AdminController < ApplicationController
  
  def index
  end
  
  def match
    Person.comparison
  end
  
end