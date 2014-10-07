require "use_case/version"

module UseCase
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def perform(*args)
      use_case = new(*args)
      use_case.perform
      use_case
    end
  end

  def perform
    raise NotImplementedError
  end

  def success?
    !failed?
  end

  def failed?
    @failed
  end

  def success
    @failed = false
    true
  end

  def failure
    @failed = true
    false
  end
end
