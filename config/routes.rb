Rails.application.routes.draw do
  namespace :admin do
    get 'customers/index'
    get 'customers/edit'
    get 'customers/update'
    get 'customers/show'
  end
  namespace :admin do
    get 'genres/index'
    get 'genres/create'
    get 'genres/edit'
    get 'genres/update'
  end
  namespace :admin do
    get 'homes/top'
  end
  namespace :public do
    get 'orders/index'
    get 'orders/show'
    get 'orders/new'
  end
  namespace :public do
    get 'cart_items/index'
    get 'cart_items/update'
  end
  namespace :public do
    get 'customers/show'
    get 'customers/edit'
    get 'customers/update'
  end
  namespace :public do
    get 'items/index'
    get 'items/show'
  end
  namespace :public do
    get 'homes/top'
    get 'homes/about'
  end
  # 顧客用
# URL /customers/sign_in ...
devise_for :customers,skip: [:passwords], controllers: {
  registrations: "public/registrations",
  sessions: 'public/sessions'
}

# 管理者用
# URL /admin/sign_in ...
devise_for :admin, skip: [:registrations, :passwords], controllers: {
  sessions: "admin/sessions"
}
end
