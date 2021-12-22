Rails.application.routes.draw do
  mount QuickSearch::Pamphlets::Engine => "/quick_search-pamphlets"
end
