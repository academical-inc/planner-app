

class Env

  @APP_ENV:          process.env.APP_ENV
  @SECTIONS_URL:     process.env.SECTIONS_URL
  @API_HOST:         process.env.API_HOST
  @API_PROTOCOL:     process.env.API_PROTOCOL
  @AUTH0_DOMAIN:     process.env.AUTH0_DOMAIN
  @AUTH0_CLIENT_ID:  process.env.AUTH0_CLIENT_ID
  @SCHOOL:           process.env.SCHOOL


module.exports = Env
