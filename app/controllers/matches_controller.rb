class MatchesController < ApplicationController
  
  def index
    @person = Person.find(params[:person_id])
  end
  
  def show
    @person = Person.find(params[:person_id])
    @match = @person.matches.find(params[:id])
    @dup = @match.dup_person
  end

  def duplicate
    @person = Person.find(params[:person_id])
    @person.subscribe self
    @person.match_decision(decision: :duplicate, match: params[:id])
  end

  def no_duplicate
    @person = Person.find(params[:person_id])
    @person.subscribe self
    @person.match_decision(decision: :no_duplicate, match: params[:id])
  end

  def undecided
    @person = Person.find(params[:person_id])
    @person.subscribe self
    @person.match_decision(decision: :undecided, match: params[:id])
  end
  
  # events
  
  def successful_match_decision_event(person, match)
    redirect_to person_match_path(person, match)
  end

  
end