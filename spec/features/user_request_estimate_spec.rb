require 'rails_helper'

feature "User request estimate" do
  scenario "successfully" do
    #Arrange
    user = create(:user, name: "Bruno", email: "bruno@campuscode.com.br")
    category = create(:category, name: "Eletricista")
    create(:contractor, name: "Severino Eletricista", category: category)
    login_as(user, scope: :user)

    #Act
    visit root_path
    click_on(category.name)
    click_on("Solicitar orçamento")

    fill_in "Título", with: "Instalação de Tomada"
    fill_in "Descrição", with: "Instalar tomada 220V na área de serviço"
    fill_in "Local", with: "Morumbi"
    fill_in "Data desejada", with: "20/04/2019"
    select "Tarde", from: "Turno"
    attach_file 'Foto', Rails.root.join('spec', 'support', 'tomada.jpg')
    click_on 'Enviar'

    #Assert
    expect(page).to have_content("Orçamento solicitado com sucesso!")
    expect(current_path).to eq estimate_path(Estimate.last)
    expect(page).to have_css('h1', text: "Instalação de Tomada")
    expect(page).to have_css('p', text: "Instalar tomada 220V na área de serviço")
    expect(page).to have_css('p', text: "Morumbi")
    expect(page).to have_css('p', text: "20/04/2019")
    expect(page).to have_css('p', text: "Tarde")
    expect(page).to have_css('img[src*="tomada.jpg"]')

  end
end
