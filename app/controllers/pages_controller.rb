class PagesController < ApplicationController
  allow_unauthenticated_access only: [:home, :about, :started]

  def home
  end

  def about
  end
end
