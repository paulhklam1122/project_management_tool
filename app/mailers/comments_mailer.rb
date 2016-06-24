class CommentsMailer < ApplicationMailer

  def notify_discussion_owner(comment)
    @comment   = comment
    @user = comment.user
    @discussion = comment.discussion
    @owner = @discussion.user
    mail(to: @owner.email, subject: "You got a new comment from #{@user.full_name}!")
  end
end
