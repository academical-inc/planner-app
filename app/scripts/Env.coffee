

class Env

  @APP_ENV:          process.env.APP_ENV
  @SECTIONS_URL:     process.env.SECTIONS_URL
  @API_HOST:         process.env.API_HOST
  @API_PROTOCOL:     process.env.API_PROTOCOL
  @AUTH0_DOMAIN:     process.env.AUTH0_DOMAIN
  @AUTH0_CLIENT_ID:  process.env.AUTH0_CLIENT_ID
  @GOOGLE_API_KEY:   process.env.GOOGLE_API_KEY
  @FB_APP_ID:        process.env.FB_APP_ID
  @BUGSNAG_API_KEY:  process.env.BUGSNAG_API_KEY
  @SCHOOL:           process.env.SCHOOL
  @CLOSED:           process.env.CLOSED
  @ANNOUNCE:         process.env.ANNOUNCE


module.exports = Env
