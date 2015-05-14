class PeopleController < ApplicationController
  
  def index
    @people = Person.order_by(hits: :desc, full_name: :asc).paginate(page: params[:page])
  end
  
  def show
    @person = Person.find(params[:id])
  end
  
  def search_form
  end
  
  def search
    @people = Person.general_search(q: params[:search])
  end
  
end