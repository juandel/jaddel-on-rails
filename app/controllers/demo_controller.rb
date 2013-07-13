class DemoController < ApplicationController
  layout 'admin'
  def index
  #render('hello')
  #redirect_to(:action =>'other_hello')
  end
  def hello
  	@array = [1,2,3,4,5]
    @id = params[:id].to_i
    #to_i converts the string in params (html only sends strings) and converts it into an integer
    @page = params[:page].to_i
  end
  def other_hello
  	render(:text => 'Hello enverysdfkak')
  end
  def text_helpers
    
  end
  def escape_output
    
  end
end

