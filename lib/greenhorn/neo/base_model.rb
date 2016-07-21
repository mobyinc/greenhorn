module Greenhorn
  module Neo
    class BaseModel < Model
      self.inheritance_column = :_type_disabled
      self.abstract_class = true
    end
  end
end
