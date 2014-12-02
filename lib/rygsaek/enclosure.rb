module Rygsaek
  module Enclosure

    def self.included(base)
      base.send :extend, ClassMethods
    end

    module ClassMethods
      def has_enclosures(options = {})
        #
        # shameless steel from airblade/paper_trail
        # Lazily include the instance methods so we don't clutter up
        # any more ActiveRecord models than we have to.
        send :include, InstanceMethods
        
        if ::ActiveRecord::VERSION::MAJOR >= 4 # `has_many` syntax for specifying order uses a lambda in Rails 4
          has_many self.attachments_association_name,
            lambda { order(model.timestamp_sort_order) },
            :class_name => self.attachment_class_name, :as => :item
        else
          has_many self.attachments_association_name,
            :class_name => self.attachment_class_name,
            :as         => :attachment,
            :order      => self.rygsaek_version_class.timestamp_sort_order
        end
        
      end
    end
  end
end