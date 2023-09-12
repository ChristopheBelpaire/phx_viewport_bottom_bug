import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :phx_viewport_bottom_bug, PhxViewportBottomBugWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "5y086Q31XX7YW67AfSlv937jItZO/j0InP0twwZopJ0sa5DG72zRhscn8cffcXwC",
  server: false

# In test we don't send emails.
config :phx_viewport_bottom_bug, PhxViewportBottomBug.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
