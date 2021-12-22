module QuickSearch
  module Pamphlets
    class ApplicationRecord < ActiveRecord::Base
      self.abstract_class = true
    end
  end
end
