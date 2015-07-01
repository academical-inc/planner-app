
Request = require '../api/request'
API_KEY = require('../Env').GOOGLE_API_KEY
{GoogleApiConstants: {
  API_HOST
}} = require '../constants/PlannerConstants'


class GoogleApi

  @shorten: (longUrl, cb)->
    Request(
      "post"
      "#{API_HOST}/urlshortener/v1/url?key=#{API_KEY}"
      (err, response)->
        cb err, response.body.id
      headers: {"Content-Type": "application/json"}
      data: {longUrl: longUrl}
    )

module.exports = GoogleApi
