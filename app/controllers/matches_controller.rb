class MatchesController < ApplicationController
  
  def index
    @person = Person.find(params[:person_id])
  end
  
  def show
    @person = Person.find(params[:person_id])
    @match = @person.matches.find(params[:id]).dup_person
  end

  def duplicate
    @person = Person.find(params[:person_id])
  end

  def no_duplicate
    @person = Person.find(params[:person_id])
  end

  def undecided
    @person = Person.find(params[:person_id])
  end
  
  # events
  
  

  
end