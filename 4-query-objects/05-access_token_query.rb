class AccessTokenQuery
  DISCOURCE_APPLICATION_NAME = 'Discource'
  include Enumerable
  
  def initialize(relation)
    @relation = relation
  end
  
  def for_user(user)
    @relation.where(resource_owner_id: user.id).last
  end
  
  def each(&block)
    @relation.each(&block)
  end
end
