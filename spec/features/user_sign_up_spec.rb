feature 'User sign up' do

  let(:user) do
    build(:user)
  end

  scenario 'I can sign up as a new user' do
    expect { sign_up(user) }.to change(User, :count).by(1)
    expect(page).to have_content("Welcome, #{user.email}")
    expect(User.first.email).to eq("#{user.email}")
  end

  scenario 'with a password that does not match' do
    user = build(:user, password_confirmation: "wrong")
    expect {sign_up(user)}.not_to change(User, :count)
  end

  scenario 'with a password that does not match' do
    user = build(:user, password_confirmation: "wrong")
    expect {sign_up(user)}.not_to change(User, :count)
    expect(current_path).to eq('/users')
    expect(page).to have_content('Sorry, there were the following problems with the form.')
  end

  scenario 'with an email that is already registered' do
    sign_up(user)
    expect { sign_up(user)}.to change(User, :count).by(0)
    expect(page).to have_content('Sorry, there were the following problems with the form.')
  end
end
