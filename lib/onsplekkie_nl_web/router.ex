defmodule OnsplekkieNlWeb.Router do
  use OnsplekkieNlWeb, :router

  import OnsplekkieNlWeb.AdminAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {OnsplekkieNlWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  # Public site: also loads the shared content settings for header/footer.
  pipeline :site do
    plug OnsplekkieNlWeb.Plugs.SiteContent
  end

  pipeline :admin do
    plug :require_admin
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Public website
  scope "/", OnsplekkieNlWeb do
    pipe_through [:browser, :site]

    get "/", PageController, :home
    get "/accommodatie", PageController, :accommodatie
    get "/omgeving", PageController, :omgeving

    get "/reserveren", PageController, :reserveren
    post "/reserveren", InquiryController, :create_reservation

    get "/contact", PageController, :contact
    post "/contact", InquiryController, :create_message

    get "/taal/:locale", LocaleController, :update
  end

  # Admin authentication (no auth required)
  scope "/admin", OnsplekkieNlWeb do
    pipe_through :browser

    get "/login", AdminSessionController, :new
    post "/login", AdminSessionController, :create
    delete "/logout", AdminSessionController, :delete
  end

  # Admin backend (auth required)
  scope "/admin", OnsplekkieNlWeb do
    pipe_through [:browser, :admin]

    get "/", AdminController, :index
    get "/content", AdminController, :content
    put "/content", AdminController, :update_content

    get "/images", AdminImageController, :index
    post "/images", AdminImageController, :create
    put "/images/:id", AdminImageController, :update
    delete "/images/:id", AdminImageController, :delete

    get "/inbox", AdminInboxController, :index
    put "/inbox/reservations/:id/toggle", AdminInboxController, :toggle_reservation
    delete "/inbox/reservations/:id", AdminInboxController, :delete_reservation
    put "/inbox/messages/:id/toggle", AdminInboxController, :toggle_message
    delete "/inbox/messages/:id", AdminInboxController, :delete_message
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:onsplekkie_nl, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: OnsplekkieNlWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
