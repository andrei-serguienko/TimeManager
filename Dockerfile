FROM elixir:1.9
# install hex package manager
RUN mix local.hex --force
# install phoenix
RUN mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez --force

RUN mkdir /api
COPY . /api
WORKDIR /api

ENV MIX_ENV=prod
ENV PORT=4000
ENV DATABASE_URL=postgres://ykuyhihsbrkxfg:224818a0753698e7526374534f1362105d48ed66ed1afd4a4989944f9f4d9926@ec2-3-220-222-72.compute-1.amazonaws.com:5432/debs8phkjcl4l8
ENV SECRET_KEY_BASE=9iQ0XDqP0/KwcmxDlsqQGZc+AfZqJyWxb2Z7Kk9SR1UepqFNP1XzfXvnvLzXNFbX

RUN mix local.rebar --force
RUN mix deps.get --only prod
RUN mix compile
RUN mix phx.digest

# run phoenix in production on PORT 4000
CMD mix local.hex --force && mix ecto.reset && mix phx.server
