module MagazCore
  module ShopServices
    class EventWebhookRunner
      include MagazCore::Concerns::Service

      def call(event:, webhook:)
        @shop = event.shop

        @shop.webhooks.where(topic: webhook).each do |w|
          MagazCore::WebhookWorker.perform_async(w.id, event.id)
        end
      end
    end
  end
end