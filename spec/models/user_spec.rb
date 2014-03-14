  require 'spec_helper'

describe User do
  context 'User authentication and validations' do
    it 'Should not save if username is not given' do
      expect {
        User.create(email: 'bubbles@bubbles.com', password: 'password', password_confirmation: 'password')
      }.to change(User, :count).by(0)
    end

    it 'Should not save if email is not given' do
      expect {
        User.create(username: 'bubbles', password: 'password', password_confirmation: 'password')
      }
    end

    it 'Should not save if password is not given' do
      expect {
        User.create(username: 'bubbles', email: 'bubbles@bubbles.com', password_confirmation: 'password')
      }.to change(User, :count).by(0)
    end

    it 'Should not save if password confirmation is not given' do
      expect {
        User.create(username: 'bubbles', email: 'bubbles@bubbles.com', password: 'password')
      }.to change(User, :count).by(0)
    end

    it 'Should not save if password does not match password confirmation' do
      expect {
        User.create(username: 'bubbles', email: 'bubbles@bubbles.com', password: 'password', password_confirmation: 'someotherthing')
      }.to change(User, :count).by(0)
    end

    it 'Should not save an invalid email' do
      expect {
        User.create(username: 'bubbles', email: 'bubbles@bubbles', password: 'password', password_confirmation: 'password')
      }.to change(User, :count).by(0)
    end

    it 'Should not save if a username is not unique' do
      User.create(username: 'bubbles', email: 'bubbles@bubbles', password: 'password', password_confirmation: 'password')
      expect {
        User.create(username: 'bubbles', email: 'bubbles@bubbles', password: 'password', password_confirmation: 'password')
      }.to change(User, :count).by(0)
    end
  end

  context "when signing up" do
    context "with valid credentials" do
      let(:user) {User.new(username: "oconn", password: "testtest", password_confirmation: "testtest")}

      it "will redirect the user to their homepage and display a welcome message" do
        visit '/users/sign_up'
        fill_in 'Username', with: 'oconn'
        fill_in 'Email', with: "matt@matt.com"
        fill_in 'Password', with: 'testtest'
        fill_in 'Password confirmation', with: "testtest"
        click_button("Sign up")
        expect(page).to have_content "Welcome! You have signed up successfully."
      end
    end

    context "with invalid password" do
      it "that is too short" do
        visit '/users/sign_up'
        fill_in 'Username', with: 'oconn'
        fill_in 'Email', with: "matt@matt.com"
        fill_in 'Password', with: 'test'
        fill_in 'Password confirmation', with: "test"
        click_button("Sign up")
        expect(page).to have_content "Password is too short (minimum is 8 characters)"
      end

      it "that do not match" do
        visit '/users/sign_up'
        fill_in 'Username', with: 'oconn'
        fill_in 'Email', with: "matt@matt.com"
        fill_in 'Password', with: 'test'
        fill_in 'Password confirmation', with: "mismatch"
        click_button("Sign up")
        expect(page).to have_content "Password confirmation doesn't match Password"
      end
    end
  end
end
