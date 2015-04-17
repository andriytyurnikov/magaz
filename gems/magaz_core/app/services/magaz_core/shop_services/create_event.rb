module MagazCore
  module ShopServices
    class CreateEvent
      include MagazCore::Concerns::Service
      attr_accessor :event

      def call(subject:, message:, description:)
        @event = MagazCore::Event.new

        MagazCore::Event.connection.transaction do
          begin
            _create_event!(subject: subject, event: @event,
                           message: message, description: description)
          rescue ActiveRecord::RecordNotFound, ActiveRecord::RecordInvalid, ArgumentError
            raise ActiveRecord::Rollback
          end
        end
      end

      private

      def _create_event!(subject:, event:, message:, description:)
        if subject.class.name.split('::').last == "Product" ||
           subject.class.name.split('::').last == "Collection"
          arguments = [name: subject.name]
        end
        if subject.class.name.split('::').last == "Order"
          arguments = [products: subject.line_items]
        end
        event.update_attributes!(subject_id: subject.id, subject_type: subject.class.name.split('::').last,
                                 arguments: arguments, message: message, description: description) || fail(ArgumentError)
      end
    end
  end
end