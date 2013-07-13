class SectionsController < ApplicationController
	layout 'admin'	

	before_filter :confirm_logged_in, :only => [:index, :menu]
	before_filter :find_subject
	
	def index
		list
		render('list')	
	end
	def list
		@sections = Section.sorted.where(:page_id => @page.id)
		@subject_id = @page.subject_id
	end
	def show
		@section = Section.find(params[:id])
	end
	def new
		@section = Section.new(:page_id => @page.id)
		@section_count = @page.sections.size+1
		@pages = Page.order('position ASC')
	end
	def create
		new_position = params [:section].delete(:position) 
		#instantiate a new object using form parameters
		@section = Section.new (params[:section])
		#Save object
		if @section.save
			@section.move_to_position(new_position)
			# If save succeeds, redirect to the list action
			flash[:notice] = "Section "+@section.name+" Created."
			redirect_to(:action => 'list', :page_id => @section.page_id)
		else
			#If save fails, redisplay the form so user can fix the problems
			@section_count = @page.sections.size+1
			@pages = Page.order('position ASC')
			render('new')
		end
	end
	def edit
		@section = Section.find(params[:id])
		@section_count = @page.sections.size
		@pages = Page.order('position ASC')
	end
	def update
		#Find a new object using form parameters
		@section = Section.find(params[:id])
		new_position = params [:section].delete(:position) 
		#Update object
		if @section.update_attributes(params[:section])
			@section.move_to_position(new_position)
			# If update succeeds, redirect to the list action
			flash[:notice] = "Section "+@section.name+" Updated."
			redirect_to(:action => 'show', :id => @section.id, :page_id => @section.page_id)
		else
			#If save fails, redisplay the form so user can fix the problems
			@section_count = @page.sections.size
			@pages = Page.order('position ASC')
			render('edit')
		end
	end
	def delete
		@section = Section.find(params[:id])
	end
	def destroy
		@section = Section.find(params[:id])
		@section.move_to_position(nil)
		@section.destroy
		flash[:notice] = "Section "+@section.name+" Deleted."
		redirect_to(:action => 'list', :page_id => @page.id)
	end

	private
	
	def find_subject
		if params[:page_id]
			@page = Page.find_by_id(params[:page_id])
		end
	end

end
