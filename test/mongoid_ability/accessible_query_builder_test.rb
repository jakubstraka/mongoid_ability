require "test_helper"

module MongoidAbility
  describe AccessibleQueryBuilder do

    let(:base_class) { MySubject }

    let(:owner) { MyOwner.new }
    let(:ability) { Ability.new(owner) }

    let(:action) { :read }

    subject { AccessibleQueryBuilder.call(base_class, ability, action) }

    before do
      MySubject.default_locks = [ MyLock.new(subject_type: MySubject, action: :read, outcome: false) ]
    end

    it 'returns Mongoid::Criteria' do
      subject.must_be_kind_of Mongoid::Criteria
    end

  end
end