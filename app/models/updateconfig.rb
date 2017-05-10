class Updateconfig < ActiveRecord::Base
	attr_accessible :config_item
	validates :url, :company, :key, :library,  presence: true
end