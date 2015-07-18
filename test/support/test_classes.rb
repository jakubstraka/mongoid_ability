module MongoidAbility
  class MyLock
    include Mongoid::Document
    include MongoidAbility::Lock
    embedded_in :owner, polymorphic: true
  end

  class MyLock_1 < MyLock
    def calculated_outcome options={}
      options[:override] || outcome
    end
  end

  # ---------------------------------------------------------------------

  class MySubject
    include Mongoid::Document
    include MongoidAbility::Subject

    default_lock MyLock, :read, true
    default_lock MyLock_1, :update, false
  end

  class MySubject_1 < MySubject
    default_lock MyLock, :read, false
  end

  class MySubject_2 < MySubject_1
  end

  # ---------------------------------------------------------------------

  class MyOwner
    include Mongoid::Document
    include MongoidAbility::Owner

    embeds_many :my_locks, class_name: 'MongoidAbility::MyLock', as: :owner
    has_and_belongs_to_many :my_roles

    def self.locks_relation_name
      :my_locks
    end

    def self.inherit_from_relation_name
      :my_roles
    end
  end

  class MyOwner_1 < MyOwner
  end

  # ---------------------------------------------------------------------

  class MyRole
    include Mongoid::Document
    include MongoidAbility::Owner

    embeds_many :locks, class_name: 'MongoidAbility::MyLock', as: :owner
    has_and_belongs_to_many :my_owners

    def self.locks_relation_name
      :my_locks
    end
  end

  class MyRole_1 < MyRole
  end
end







# class TestLock
#   include Mongoid::Document
#   include MongoidAbility::Lock
#
#   embedded_in :owner, polymorphic: true
# end
#
# class TestLockSub < TestLock
# end
#
# # ---------------------------------------------------------------------
#
# class TestOwnerSuper
#   include Mongoid::Document
#   include MongoidAbility::Owner
#
#   embeds_many :test_locks, class_name: 'TestLock', as: :owner
# end
#
# class TestOwner < TestOwnerSuper
# end
#
# # ---------------------------------------------------------------------
#
# class SubjectTest
#   include Mongoid::Document
#   include MongoidAbility::Subject
#
#   default_lock :read, true
# end
#
# class SubjectTestOne < SubjectTest
# end
#
# class SubjectTestTwo < SubjectTest
# end
#
# class SubjectSingleTest
#   include Mongoid::Document
#   include MongoidAbility::Subject
#
#   default_lock :read, true
# end
#
# # ---------------------------------------------------------------------
#
# class TestAbilityResolverSubject
#   include Mongoid::Document
#   include MongoidAbility::Subject
#
#   default_lock :read, true
# end
#
# class TestAbilitySubjectSuper2
#   include Mongoid::Document
#   include MongoidAbility::Subject
#
#   default_lock :read, false
#   default_lock :update, true
# end
#
# class TestAbilitySubjectSuper1 < TestAbilitySubjectSuper2
# end
#
# class TestAbilitySubject < TestAbilitySubjectSuper1
# end
#
# # ---------------------------------------------------------------------
#
# class TestRole
#   include Mongoid::Document
#   include MongoidAbility::Owner
#
#   field :name, type: String
#
#   embeds_many :test_locks, class_name: 'TestLock', as: :owner
#   has_and_belongs_to_many :users, class_name: 'TestUser'
# end
#
# class TestUser
#   include Mongoid::Document
#   include MongoidAbility::Owner
#
#   embeds_many :test_locks, class_name: 'TestLock', as: :owner
#   has_and_belongs_to_many :roles, class_name: 'TestRole'
# end
