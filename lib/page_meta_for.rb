# frozen_string_literal: true

require_relative "page_meta_for/version"
require 'active_support'
require 'action_controller'

module PageMeta
  extend ::ActiveSupport::Concern

  included do
    initialize_meta
    helper_method :page_meta_for, :page_meta_for?
  end

  module ClassMethods
    def initialize_meta
      before_action do
        @page_meta_for = {}
      end
    end

    # Controller level method to define the part of the meta tags
    #
    #   class ApplicationController < ActionController::Base
    #     meta_for(:title, :suffix, 'ApplicationName')
    #     meta_for(:title, :prefix) { action_name }
    #     meta_for(:description) { 'Lorem ipsum set' }
    #   end
    #
    #   class WelcomeController < ApplicationController
    #     meta_for(:title) { 'Landing Page' }
    #     meta_for(:description) { 'Lorem ipsum set2' }
    #   end
    #
    # Then views and layouts are able to call `page_meta_for`:
    #
    #   <title><%= page_meta_for(:title, join_string: ' * ') %></title>
    #   <meta name="description" content="<%= page_meta_for(:description) %>" />
    #
    # It renders the following:
    #
    #    <title>Index * Landing Page * ApplicationName</title>
    #    <meta name="description" content="Lorem ipsum set2" />
    #
    # If last argument is Hash, a appropriate method will be called
    #
    #   class ApplicationController < ActionController::Base
    #     meta_for(:title, :generate_title)
    #
    #     private
    #
    #     def generate_title
    #       'Application Name'
    #     end
    #   end
    #
    def meta_for(*keys, **options, &block)
      content_proc = if block_given?
                       block
                     else
                       c = keys.pop
                       c.is_a?(Symbol) ? proc { send(c) } : proc { c }
                     end

      keys = Array.wrap(keys).flatten
      key = keys.shift
      scope = keys.pop || :value

      before_action(**options) do
        @page_meta_for ||= {}
        @page_meta_for[key] ||= {}
        @page_meta_for[key][scope] = content_proc
      end
    end
  end

  def page_meta_for(key, scopes: [:prefix, :value, :suffix], join_string: " - ")
    @page_meta_for ||= {}
    scopes.map { |s| @page_meta_for.fetch(key, {}).fetch(s, nil) }
          .select(&:present?)
          .map { |s| instance_exec(&s) }
          .select(&:present?)
          .join(join_string)
          .presence
  end

  def page_meta_for?(key)
    (@page_meta_for || {}).fetch(key, {}).values.any?(&:present?)
  end
end

ActionController::Base.include(PageMeta)
