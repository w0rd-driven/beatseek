defmodule BeatseekWeb.Router do
  use BeatseekWeb, :router

  import BeatseekWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {BeatseekWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BeatseekWeb do
    pipe_through :browser

    get "/", PageController, :music
  end

  # Other scopes may use custom stacks.
  # scope "/api", BeatseekWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:beatseek, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: BeatseekWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", BeatseekWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{BeatseekWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", BeatseekWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{BeatseekWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
    end
  end

  scope "/", BeatseekWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{BeatseekWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new

      live "/artists", ArtistLive.Index, :index
      live "/artists/new", ArtistLive.Index, :new
      live "/artists/:id/edit", ArtistLive.Index, :edit

      live "/artists/:id", ArtistLive.Show, :show
      live "/artists/:id/show/edit", ArtistLive.Show, :edit

      live "/albums", AlbumLive.Index, :index
      live "/albums/new", AlbumLive.Index, :new
      live "/albums/:id/edit", AlbumLive.Index, :edit

      live "/albums/:id", AlbumLive.Show, :show
      live "/albums/:id/show/edit", AlbumLive.Show, :edit

      live "/notifications", NotificationLive.Index, :index
      live "/notifications/new", NotificationLive.Index, :new
      live "/notifications/:id/edit", NotificationLive.Index, :edit

      live "/notifications/:id", NotificationLive.Show, :show
      live "/notifications/:id/show/edit", NotificationLive.Show, :edit
    end
  end
end
