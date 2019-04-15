require 'application_system_test_case'

class JudgeActivityTest < ApplicationSystemTestCase
  def setup
    @user = users(:judge_user)
    login_as @user
  end

  test 'judge user can approve an activity' do
    visit judge_main_index_path
    find("a[href='/judge/activities/rails-as-a-day-to-day']").click
    find("a[href='/judge/activities/rails-as-a-day-to-day/activity_status']").click
    assert page.has_content?(I18n.t('activities.messages.approved'))
  end

  test 'judge can unapprove an activity' do
    visit judge_main_index_path
    find("a[href='#all_activities_container']").click
    find("a[href='/judge/activities/poo-java']").click
    find("a[href='/judge/activities/poo-java/activity_status/poo-java']").click
    page.driver.browser.switch_to.alert.accept
    assert page.has_content?(I18n.t('activities.messages.unapproved'))
  end

  test 'judge can see only waiting activities on the on wait sectin' do
    visit judge_main_index_path
    assert page.has_content?('POO ruby')
    assert page.has_content?('Android Studio Curso')
    assert page.has_content?('Rails as a Day to Day')
  end

  test 'judge can see only in revision activities on the revision section' do
    activity = activities(:activity_talk)
    activity.status = 1
    activity.save!
    visit judge_main_index_path
    find("a[href='#pending_activities_container']").click
    assert page.has_content?('POO ruby')
    refute page.has_content?('Android Studio Curso')
    refute page.has_content?('Rails as a Day to Day')
  end

  test 'judge can see all activities in the all activities section' do
    visit judge_main_index_path
    find("a[href='#all_activities_container']").click
    assert page.has_content?('POO ruby')
    assert page.has_content?('Android Studio Curso')
    assert page.has_content?('Rails as a Day to Day')
    assert page.has_content?('POO Java')
    assert page.has_content?('POO Kotlin')
  end

  test 'judge user can validate a location' do
    activity = activities(:activity_talk)
    visit judge_activity_path(activity)
    find("a[href='/judge/activities/poo-ruby/locations/#{activity.locations.first.id}']").click
    assert page.has_content?(I18n.t('labels.approved'))
  end

  test 'judge can unapprove an activity location' do
    activity = activities(:activity_workshop)
    visit judge_activity_path(activity)
    find("a[href='/judge/activities/poo-java/locations/#{activity.locations.first.id}']").click
    assert page.has_content?(I18n.t('labels.unapproved'))
  end

  test 'judge can leave a comment on the activity' do
    activity = activities(:activity_workshop)
    visit judge_activity_path(activity)
    fill_in 'feedback[comment]', with: 'Looks like this is a fantastic activity'
    find('input[name="commit"]').click
    assert page.has_content?(I18n.t('comments.created'))
  end

  test 'judge can edit a comment' do
    activity = activities(:activity_workshop)
    visit judge_activity_path(activity)
    fill_in 'feedback[comment]', with: 'Looks like this is a fantastic activity'
    find('input[name="commit"]').click
    page.find("a[href='#']", visible: :all).click
    fill_in 'editor_0', with: 'Looks like this is amazing'
    page.find("a[href='#']", visible: :all).click
    assert page.has_content?('Looks like this is amazing')
  end
end
