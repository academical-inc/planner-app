
React         = require 'react'
I18nMixin     = require '../mixins/I18nMixin'
SchoolStore   = require '../stores/SchoolStore'
{UiConstants} = require '../constants/PlannerConstants'
LoginDialog   = React.createFactory require './LoginDialog'
ErrorDialog   = React.createFactory require './ErrorDialog'
MessageDialog = React.createFactory require './MessageDialog'
R             = React.DOM

{CLOSED}      = require '../Env'


LandingPage = React.createClass(

  mixins: [I18nMixin]

  openLogin: ->
    if CLOSED
      @refs.messageDialog.show()
    else
      @refs.loginDialog.show()

  componentDidMount: ->
    @refs.messageDialog.show() if CLOSED
    @refs.announcementDialog.show()
    @refs.errorDialog.show() if @props.error?
    $(@refs.videoLink.getDOMNode()).magnificPopup type: 'iframe'
    $(@refs.videoBtn.getDOMNode()).magnificPopup type: 'iframe'

  render: ->
    R.div className: 'pla-content container-fluid',
      React.createElement('div', { className: 'navbar-fixed-top header-index' }, React.createElement('img', src: '/images/academical_logo.png'), React.createElement('div', { className: 'header_buttons' }, React.createElement('a', {
        className: 'language_button right_button'
        href: '/?lang=en'
        onClick: -> window.location.reload true
        type: 'button'
      }, 'EN'), React.createElement('a', {
        className: 'language_button left_button'
        href: '/?lang=es'
        onClick: -> window.location.reload true
        type: 'button'
      }, 'ES'), React.createElement('button', {
        className: 'signin_button'
        onClick: @openLogin
        type: 'button'
      }, @t('loginDialog.header'))))
      React.createElement('div', { className: 'main' }, React.createElement('section', null, React.createElement('div', { className: 'container-fluid sec1' }, React.createElement('div', { className: 'container-fluid sec1-1' }, React.createElement('h1', null, @t('landing.section1.title'), React.createElement('strong', null, @t('landing.section1.titleStrong'))), React.createElement('p', null, @t('landing.section1.subtitle'))), React.createElement('div', { className: 'container-fluid sec1-2' }, React.createElement('img',
        src: '/images/macbook.png'
        className: 'img-mac'), React.createElement('div', { className: 'container-fluid video-play' }, React.createElement('a', {
        className: 'popup-link'
        ref: 'videoLink'
        href: 'https://www.youtube.com/watch?v=WEhQn5bKHDE'
      }, React.createElement('div', className: 'btn_play')), React.createElement('a', {
        className: 'popup-link'
        ref: 'videoBtn'
        href: 'https://www.youtube.com/watch?v=WEhQn5bKHDE'
      }, React.createElement('h2', null, @t('landing.section1.videoBtn'))))))), React.createElement('section', null, React.createElement('div', { className: 'container-fluid sec2' }, React.createElement('h1', null, @t('landing.section2.title')), React.createElement('h3', null, @t('landing.section2.subtitle')), React.createElement('div', {
        className: 'row'
        id: 'functions'
      }, React.createElement('div', { className: 'col-md-3 col-sm-6 col-xs-6' }, React.createElement('img',
        src: '/images/availability_feature.png'
        className: 'fadeInUp-animation'), React.createElement('h2', null, @t('landing.section2.title1')), React.createElement('p', null, @t('landing.section2.sen1'))), React.createElement('div', { className: 'col-md-3 col-sm-6 col-xs-6' }, React.createElement('img',
        src: '/images/organize_feature.png'
        className: 'fadeInUp-animation'), React.createElement('h2', null, @t('landing.section2.title2')), React.createElement('p', null, @t('landing.section2.sen2'))), React.createElement('div', { className: 'col-md-3 col-sm-6 col-xs-6' }, React.createElement('img',
        src: '/images/search_feature.png'
        className: 'fadeInUp-animation'), React.createElement('h2', null, @t('landing.section2.title3')), React.createElement('p', null, @t('landing.section2.sen3'))), React.createElement('div', { className: 'col-md-3 col-sm-6 col-xs-6' }, React.createElement('img',
        src: '/images/more_feature.png'
        className: 'fadeInUp-animation'), React.createElement('h2', null, @t('landing.section2.title4')), React.createElement('p', null, @t('landing.section2.sen4')))))), React.createElement('section', null, React.createElement('div', { className: 'container-fluid sec4' }, React.createElement('div', { className: 'row stats-test-box' }, React.createElement('div', { className: 'row stats' }, React.createElement('div', { className: 'rotateInDownLeft-animation col-md-3 col-sm-3 col-xs-3 statsbox' }, React.createElement('h1', null, React.createElement('img', src: '/images/stats1_icon.png'), @t('landing.section3.stats1')), React.createElement('h2', null, @t('landing.section3.stats1Sub')), React.createElement('img',
        src: '/images/stats1_logo.png'
        className: 'academical-stats-icon')), React.createElement('div', { className: 'fadeInDown-animation col-md-3 col-sm-3 col-xs-3 statsbox' }, React.createElement('img',
        src: '/images/stats2_icon.png'
        className: 'people-stats-icon'), React.createElement('h1', null, @t('landing.section3.stats2')), React.createElement('h2', null, @t('landing.section3.stats2Sub'))), React.createElement('div', { className: 'rotateInDownRight-animation col-md-3 col-sm-3 col-xs-3 statsbox' }, React.createElement('img', src: '/images/stats3_icon.png'), React.createElement('h1', null, @t('landing.section3.stats3')), React.createElement('h2', null, @t('landing.section3.stats3Sub')))), React.createElement('div', { className: 'container-fluid testi' }, React.createElement('h3', null, @t('landing.section3.testimonies.title'))), React.createElement('div', {
        className: 'carousel slide testibox'
        'data-ride': 'carousel'
        id: 'carousel-example-generic'
      }, React.createElement('div', { className: 'container-fluid' }, React.createElement('div', { className: 'col-md-1 col-sm-1 col-xs-1 centercontent' }, React.createElement('a',
        className: 'leftarrow'
        'data-slide': 'prev'
        href: '#carousel-example-generic'
        role: 'button')), React.createElement('div', { className: 'col-md-7 col-sm-9 col-xs-9 centercontent' }, React.createElement('div', { className: 'carousel-inner' }, React.createElement('div', { className: 'item' }, React.createElement('img',
        src: '/images/testimony_pic_1.jpg'
        className: 'student-photo'), React.createElement('p', null, @t('landing.section3.testimonies.first.sentence'), React.createElement('br', null), React.createElement('br', null), React.createElement('strong', null, @t('landing.section3.testimonies.first.name')), React.createElement('br', null), React.createElement('strong', null, @t('landing.section3.testimonies.first.info')), React.createElement('br', null), React.createElement('strong', null, @t('landing.section3.testimonies.first.university')))), React.createElement('div', { className: 'item' }, React.createElement('img',
        src: '/images/testimony_pic_5.png'
        className: 'student-photo'), React.createElement('p', null, @t('landing.section3.testimonies.second.sentence'), React.createElement('br', null), React.createElement('br', null), React.createElement('strong', null, @t('landing.section3.testimonies.second.name')), React.createElement('br', null), React.createElement('strong', null, @t('landing.section3.testimonies.second.info')), React.createElement('br', null), React.createElement('strong', null, @t('landing.section3.testimonies.second.university')))), React.createElement('div', { className: 'item active' }, React.createElement('img',
        src: '/images/testimony_pic_2.jpg'
        className: 'student-photo'), React.createElement('p', null, @t('landing.section3.testimonies.third.sentence'), React.createElement('br', null), React.createElement('br', null), React.createElement('strong', null, @t('landing.section3.testimonies.third.name')), React.createElement('br', null), React.createElement('strong', null, @t('landing.section3.testimonies.third.info')), React.createElement('br', null), React.createElement('strong', null, @t('landing.section3.testimonies.third.university')))), React.createElement('div', { className: 'item' }, React.createElement('img',
        src: '/images/testimony_pic_4.png'
        className: 'student-photo'), React.createElement('p', null, @t('landing.section3.testimonies.fourth.sentence'), React.createElement('br', null), React.createElement('br', null), React.createElement('strong', null, @t('landing.section3.testimonies.fourth.name')), React.createElement('br', null), React.createElement('strong', null, @t('landing.section3.testimonies.fourth.info')), React.createElement('br', null), React.createElement('strong', null, @t('landing.section3.testimonies.fourth.university')))))), React.createElement('div', { className: 'col-md-1 col-sm-1 col-xs-1 centercontent' }, React.createElement('a',
        className: 'rightarrow'
        'data-slide': 'next'
        href: '#carousel-example-generic'
        role: 'button'))), React.createElement('ol', { className: 'carousel-indicators' }, React.createElement('li',
        'data-slide-to': 0
        'data-target': '#carousel-example-generic'
        className: true), React.createElement('li',
        'data-slide-to': 1
        'data-target': '#carousel-example-generic'
        className: true), React.createElement('li',
        'data-slide-to': 2
        'data-target': '#carousel-example-generic'
        className: 'active'), React.createElement('li',
        className: true
        'data-slide-to': 3
        'data-target': '#carousel-example-generic')))), React.createElement('footer', null, React.createElement('div', { className: 'footer_web footerbox special-footer-case' }, React.createElement('a', {
        id: 'terminos_and_policy_btn'
        className: 'float-shadow'
        href: UiConstants.site.ABOUT
      }, @t('landing.footer.about')), React.createElement('a', {
        id: 'terminos_and_policy_btn'
        className: 'float-shadow'
        href: UiConstants.site.CONTACT
      }, @t('landing.footer.contact')), React.createElement('a', {
        id: 'terminos_and_policy_btn'
        className: 'float-shadow'
        href: UiConstants.site.PRIVACY
      }, @t('landing.footer.privacy')), React.createElement('div', { className: 'icons-block-inline' }, React.createElement('a', {
        href: 'https://www.facebook.com/academicalapp'
        id: 'icon_btn'
        target: '_blank'
      }, React.createElement('img', src: '/images/facebook_logo.png')), React.createElement('a', {
        href: 'https://twitter.com/academicalapp'
        id: 'icon_btn'
        target: '_blank'
      }, React.createElement('img', src: '/images/twitter_logo.png')), React.createElement('a', {
        href: 'https://github.com/academical-inc'
        id: 'icon_btn'
        target: '_blank'
      }, React.createElement('img', src: '/images/github_logo.png'))))))))
      LoginDialog ref: "loginDialog"
      ErrorDialog ref: "errorDialog", error: @props.error
      MessageDialog(
        ref: "messageDialog",
        message: @t("landing.dialogMessage.#{SchoolStore.school().nickname}")
      )
      MessageDialog(
        ref: "announcementDialog",
        message: @t("landing.dialogAnnounce.#{SchoolStore.school().nickname}")
      )

)

module.exports = LandingPage
