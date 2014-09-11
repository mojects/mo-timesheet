class UsersController < ApplicationController
  protect_from_forgery except: :index

  def index
    @users = params[:show_hidden] ?
      User.all : User.where(active: true)
  end

  def show
    @user = User.find(params[:id])
    @main_info = main_information
    @contacts_info = contacts_information
    @contract_info = contract_information
    @address_info = address_information
    @bank_account_info = bank_account_information
  end

  def syncronize
    timeframe = params.permit(:from, :to).values.map { |x| Date.parse x }
    timeframe[1] += 1.day
    UserConnector.syncronize *timeframe
    redirect_to users_path
  end

  def edit
    @user = User.find(params[:id])
    @info = information
  end

  def update
    @user = User.find(params[:id])
    user_attributes = information.map { |_, (_, x)| x }
    @user.update(params.permit(*user_attributes))
    redirect_to @user
  end

  def hide
    @user = User.find(params[:id])
    @user.update(active: false)
    redirect_to users_path
  end

  def unhide
    @user = User.find(params[:id])
    @user.update(active: true)
    redirect_to users_path
  end

  def destroy
    User.find(params[:id]).destroy
    redirect_to users_path
  end

  private
  def information
    main_information.
      merge(contacts_information).
      merge(contract_information).
      merge(address_information).
      merge(bank_account_information)
  end

  def main_information
    {
      'Login' => [@user.login, :login],
      'First name' => [@user.first_name, :first_name],
      'Last name' => [@user.last_name, :last_name],
      'OS' => [@user.os, :os]
    }
  end

  def contacts_information
    {
      'E-Mail' => [@user.mail, :mail],
      'Skype' => [@user.skype, :skype],
      'Google Hangouts' => [@user.gtalk, :gtalk],
      'Phone' => [@user.phone, :phone]
    }
  end

  def contract_information
    {
      'Duty' => [@user.duty, :duty],
      'Date of contract' => [@user.date_of_contract, :date_of_contract, 'date'],
      'Active' => [@user.active, :active, 'checkbox'],
      'Tax percent' => [@user.tax_percent, :tax_percent]
    }
  end

  def address_information
    {
      'Street & Building' => [@user.address, :address],
      'City' => [@user.city, :city],
      'Country' => [@user.country, :country],
      'ZIP' => [@user.zip, :zip]
    }
  end

  def bank_account_information
    {
      'Name for bank account' => [@user.name_for_bank_account, :name_for_bank_account],
      'Bank account number' => [@user.bank_account_number, :bank_account_number],
      'Bank SWIFT' => [@user.bank_swift, :bank_swift],
      'Bank name' => [@user.bank_name, :bank_name]
    }
  end
end
