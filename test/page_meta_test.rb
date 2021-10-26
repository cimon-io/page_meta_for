require 'test_helper'

class PageMetaForTest < Minitest::Test
  def fake_app_controller
    Class.new do
      def self.helper_method(*args); end
      def self.before_action(*args, &block)
        instance_exec(&block)
      end

      include ::PageMeta
    end
  end
  def test_that_it_has_a_version_number
    refute_nil ::PageMetaFor::VERSION
  end

  def test_that_has_class_method_page_meta
    b1 = Class.new(fake_app_controller)

    assert b1.respond_to?(:meta_for), 'class should have method #meta_for'
    assert b1.new.respond_to?(:page_meta_for), 'instance should have helper #page_meta_for'
  end

  # def test_that_custom_suffixes_works
  #   controller = Class.new(fake_app_controller)

  #   controller.meta_for(:blah, :one) { '1' }
  #   controller.meta_for(:blah, :two) { '2' }
  #   controller.meta_for(:blah, :three) { '3' }
  #   controller.meta_for(:blah, :four) { '4' }
  #   assert controller.new.page_meta_for(:blah, scopes: [:one, :two, :three, :four], join_string: ' ^ '), '1 ^ 2 ^ 3 ^ 4'
  # end
end
