class Owner
  include Mongoid::Document
  
  field :ip
  
  embedded_in :image
end
