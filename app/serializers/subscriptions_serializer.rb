class SubscriptionsSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :service_id
end