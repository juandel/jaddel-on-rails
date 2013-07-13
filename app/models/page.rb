require 'lib/position_mover'
class Page < ActiveRecord::Base
  attr_accessible :name, :permalink, :position, :visible, :subject_id

  include PositionMover

  # validates_presence_of :name
  # validates_length_of :name, :maximum => 20
  # validates_presence_of :permalink
  # validates_length_of :permalink, :within => 3..255
  # #use presence with length to disallow spaces
  # validates_uniqueness_of :permalink
  # #for unique values by subject, :scope => :subject_id

  validates :name, :presence => true, :length =>{:maximum => 20}
  validates :permalink, :length => {:within => 3..255}, :uniqueness => true

  belongs_to :subject
  has_many :sections
  has_and_belongs_to_many :editors, :class_name => "AdminUser"


  scope :visible, where(:visible => true)
  scope :invisible, where(:visible => false)
  scope :sorted, order('pages.position ASC')

  private

    def position_scope
      "pages.subject_id = #{subject_id.to_i}"
      
    end

end
