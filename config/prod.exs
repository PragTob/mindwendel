use Mix.Config
require Logger

# For production, don't forget to configure the url host
# to something meaningful, Phoenix uses this information
# when generating URLs.
#
# Note we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the `mix phx.digest` task,
# which you should run after static files are built and
# before starting your production server.
config :mindwendel, MindwendelWeb.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json"

secret_key_base = System.get_env("SECRET_KEY_BASE")

unless secret_key_base do
  Logger.warn(
    "Environment variable SECRET_KEY_BASE is missing. You can generate one by calling: mix phx.gen.secret"
  )
end

config :mindwendel, MindwendelWeb.Endpoint,
  # This configuration ensures / enforces ssl requests sent to this mindwendel instance.
  # See https://hexdocs.pm/phoenix/Phoenix.Endpoint.html#module-compile-time-configuration
  #
  # Note:
  # This configuration also supports deploying mindwendel behind a reverse proxy (load balancer).
  # For this to work, we tell the Phoenix endpoint Configuration (Plug.SSL) to parse the proper protocol from the x-forwarded-* header.
  # See https://hexdocs.pm/plug/Plug.SSL.html#module-x-forwarded
  # See https://hexdocs.pm/phoenix/Phoenix.Endpoint.html#module-compile-time-configuration
  force_ssl: [
    hsts: true,
    rewrite_on: [
      :x_forwarded_host,
      :x_forwarded_port,
      :x_forwarded_proto
    ]
  ],
  http: [
    transport_options: [
      socket_opts: [
        :inet6
      ]
    ]
  ],
  secret_key_base: secret_key_base

# Do not print debug messages in production
config :logger, level: :info

config :mindwendel, :options,
  feature_brainstorming_teasers:
    Enum.member?(
      ["", "true"],
      String.trim(System.get_env("MW_FEATURE_BRAINSTORMING_TEASER") || "")
    )

# ## SSL Support
#
# To get SSL working, you will need to add the `https` key
# to the previous section and set your `:url` port to 443:
#
#     config :mindwendel, MindwendelWeb.Endpoint,
#       ...
#       url: [host: "example.com", port: 443],
#       https: [
#         port: 443,
#         cipher_suite: :strong,
#         keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#         certfile: System.get_env("SOME_APP_SSL_CERT_PATH"),
#         transport_options: [socket_opts: [:inet6]]
#       ]
#
# The `cipher_suite` is set to `:strong` to support only the
# latest and more secure SSL ciphers. This means old browsers
# and clients may not be supported. You can set it to
# `:compatible` for wider support.
#
# `:keyfile` and `:certfile` expect an absolute path to the key
# and cert in disk or a relative path inside priv, for example
# "priv/ssl/server.key". For all supported SSL configuration
# options, see https://hexdocs.pm/plug/Plug.SSL.html#configure/1
#
# We also recommend setting `force_ssl` in your endpoint, ensuring
# no data is ever sent via http, always redirecting to https:
#
#     config :mindwendel, MindwendelWeb.Endpoint,
#       force_ssl: [hsts: true]
#
# Check `Plug.SSL` for all available options in `force_ssl`.
