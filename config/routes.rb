Rails.application.routes.draw do
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

root to: 'public/homes#top'
 get 'homes/about' => "public/homes#about", as: :about

  namespace :admin do
    get 'homes/top' => 'homes#top'
    resources :items, only:[:index, :new, :create, :show, :edit, :update]
    resources :genres, only: [:index, :create, :edit, :update]
    resources :customers, only: [:index, :show, :edit, :update] do
      member do
        get "order"
      end
    end
    resources :orders, only: [:show, :index]
    patch "orders/status" => "orders#status_update"
    patch "orders/production_status" => "orders#production_status_update"
   
  end

  scope module: :public do
 # customers

   get  '/customers/mypage' => 'customers#show'
   get  '/customers/information/edit' => 'customers#edit'
   patch  '/customers/information' => 'customers#update'
 # 退会確認画面
   get  '/customers/check' => 'customers#check'
 # 論理削除用のルーティング
   patch  '/customers/withdraw' => 'customers#withdraw'
   resources :customers, only: [:show, :edit, :update]

   get 'orders/confirm' => 'orders#confirm'
   resources :orders, only: [:index, :show, :new, :create] do
       collection do
         post 'confirm'
         get 'complete'
        end
    end
   resources :items, only: [:index, :show]

   resources :cart_items, only: [:index, :update, :destroy, :create]
   delete 'cart_items_destroy_all'=> 'cart_items#destroy_all',as: "cart_items_destroy_all"

   resources :addresses, only: [:index, :edit, :create, :update, :destroy]

  end


   get '/genre/search' => 'searches#genre_search'

   
end

