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
ENV DATABASE_URL=ecto://postgres:postgres@db/time_api_dev
ENV SECRET_KEY_BASE=t8sxAm3YJK0ekRZO9vIfIMrm8vjz9OdEjs9v4pgp2wlz5sRbU8ZYcV9CqwSUyBqy

RUN mix local.rebar --force
RUN mix deps.get --only prod
RUN mix compile
RUN mix phx.digest
# run phoenix in production on PORT 4000
CMD mix local.hex --force && mix ecto.setup && mix phx.server
