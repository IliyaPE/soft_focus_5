# System Setup Guide

To get the Soft Focus backend running on your Mac, please follow these steps.

## 1. Prerequisites (Homebrew)
If you don't have Homebrew installed, run:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## 2. Install Image Processing & Database
The app needs **ImageMagick** to process the photos and **MongoDB** to save them.
```bash
brew install imagemagick
brew tap mongodb/brew
brew install mongodb-community@6.0
```

Start MongoDB:
```bash
brew services start mongodb-community@6.0
```

## 3. Install Ruby 3.1.0
The project requires a newer version of Ruby.
```bash
brew install rbenv ruby-build
rbenv install 3.1.0
rbenv global 3.1.0
```
*Note: You might need to add `eval "$(rbenv init -)"` to your `~/.zshrc` or `~/.bash_profile` and restart your terminal.*

## 4. Install Gems & Start Server
Go to the project folder:
```bash
cd /Users/Iliya/Downloads/softfocus4-master
gem install bundler:2.3.10
bundle install
bundle exec rails s
```

Now you can visit `http://localhost:3000` to use the real system!
