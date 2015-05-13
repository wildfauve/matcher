class PeopleController < ApplicationController
  
  def index
    @people = Person.paginate(page: params[:page])
  end
  
  def search_form
  end
  
  def search
    @people = Person.search(params[:search])
  end
  
end