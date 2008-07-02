# Include hook code here
require 'amazon'
require 'plugin'
require 'mephisto_amazon'
require 'keyword_search_macro'
require 'mephistoamazon/keyword_search'
require 'mephistoamazon/asin_search'
require 'mephistoamazon/search_delegate'
require 'mephistoamazon/response_drop'


FilteredColumn.macros[:keyword_search_macro] = KeywordSearchMacro
FilteredColumn.macros[:asin_search_macro] = AsinSearchMacro
FilteredColumn.macros[:wishlist_search_macro] = WishlistSearchMacro