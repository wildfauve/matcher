class PeopleController < ApplicationController
  
  def index
    @people = Person.order_by(hits: :desc, full_name: :asc).paginate(page: params[:page])
  end
  
  def show
    @person = Person.find(params[:id])
  end
  
  def search_form
  end
  
  def filtered
    @filter = Setting.value_for('min_score')
    @people = Person.gt('matches.score' => @filter).order_by(hits: :desc, full_name: :asc).paginate(page: params[:page])
    render 'index'
  end
  
  def search
    @people = Person.general_search(q: params[:search])
  end
  
end