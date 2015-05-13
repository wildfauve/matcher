class PeopleController < ApplicationController
  
  def index
    @people = Person.paginate(page: params[:page])
  end
  
  def show
    @person = Person.find(params[:id])
  end
  
  def search_form
  end
  
  def search
    @people = Person.es.search(params[:search])
  end
  
end