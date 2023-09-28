import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :sample, SampleWeb.Endpoint,
  http: [ip: {0, 0, 0, 0}, port: 4002],
  secret_key_base: "F1S1oIPm+bhkiaVHv0WsQfLVwzSv1Wj0WBiQuhl4nyImzD+/gduo/etyUDL3m2I6",
  server: false

# In test we don't send emails.
config :sample, Sample.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
