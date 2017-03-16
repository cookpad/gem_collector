module GemCollector
  module ApplicationHelper
    def gem_news_body_template
      <<~TEMPLATE
      ## Problem
      {{Write problem here}}

      ## Required actions
      {{Write required actions here}}

      ## Background
      {{Write background here}}

      ## Contact information
      {{Write your department or inquiry counter about this news}}
      TEMPLATE
    end
  end
end
