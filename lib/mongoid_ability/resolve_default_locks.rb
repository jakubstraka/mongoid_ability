module MongoidAbility
  class ResolveDefaultLocks < ResolveLocks
    def call
      return false if default_locks.any? { |l| l.closed?(options) }
      return true if default_locks.any? { |l| l.open?(options) }
    end

    private # =============================================================

    def default_locks
      subject_class.default_locks.select { |l| l.action.to_s == action.to_s }
    end
  end
end
