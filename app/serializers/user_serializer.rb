class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :email, :created_at, :confirmed_at
end
