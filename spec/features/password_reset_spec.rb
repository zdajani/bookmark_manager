feature 'Password reset' do

let(:user) do
  create(:user)
end

 scenario 'requesting a password reset' do
   sign_up(user)
   visit '/users/password_reset'
   fill_in 'email', with: user.email
   click_button 'Reset password'
   expect(user.password_token).not_to be_nil
   expect(page).to have_content 'Check your emails'
 end

 scenario 'resetting password' do

    user.password_token = 'token'
    expect(user.password_token).not_to be_nil
    visit "/users/new_password/#{user.password_token}"
    expect(page.status_code).to eq 200
    expect(page).to have_content 'Enter a new password'
 end
end
