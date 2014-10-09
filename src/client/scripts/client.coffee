client = angular.module 'client', [

    'ngResource'

    'ctrl.calculator'
    'ctrl.invite'
    'ctrl.main'

    'dir.moreless'
    'dir.nav.collapse'
    'dir.popover'
    'dir.scroller'
    'dir.scrollto'

    'fac.sitecfg'

    'srv.api'
    'srv.mail'

]


client.config ($locationProvider) ->
    $locationProvider.html5Mode false
