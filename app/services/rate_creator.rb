class RateCreator
  def self.build(value, submission_id, user_id)
    submission = Submission.find(submission_id)
    user = User.find(user_id)
    new(value, submission, user, RateChecker.new)
  end

  def initialize(value, submission, user, rate_checker)
    @value = value
    @submission = submission
    @user = user
    @rate_checker = rate_checker
  end

  def call
    rate = Rate.new({ value: @value, submission: @submission, user: @user })

    if @rate_checker.user_has_already_rated?(@submission.id, @user.id)
        errors = ['You are not allowed to rate the same submission twice']
        success = false
        result = Result.new(rate, success, errors)
    else
      success = rate.save
      result = Result.new(rate, success)
    end

    result
  end
end
