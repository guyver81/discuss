use Mix.Releases.Config,
    # This sets the default release built by `mix release`
    default_release: :default,
    # This sets the default environment used by `mix release`
    default_environment: :dev

# For a full list of config options for both releases
# and environments, visit https://hexdocs.pm/distillery/configuration.html


# You may define one or more environments in this file,
# an environment's settings will override those of a release
# when building in that environment, this combination of release
# and environment configuration is called a profile

environment :dev do
  set dev_mode: true
  set include_erts: false
  set cookie: :"|{7T5ZWOM;L/*]K/RfUaA7v$NU9HWLMTG3?0eovMDUF`Q4,*p^x0.@kyo:o@66}M"
end

environment :prod do
  set include_erts: true
  set include_src: false
  set cookie: :"fz@swYx*y1D{vB^C@rfa9@49:0z@u(2o/cKfaz|6v&/rzJ%XT{YHRUKn5)~Hk&pu"
end

# You may define one or more releases in this file.
# If you have not set a default release, or selected one
# when running `mix release`, the first release in the file
# will be used by default

release :discuss do
  set version: current_version(:discuss)
end

