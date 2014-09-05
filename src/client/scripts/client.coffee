client = angular.module 'client', [

    'ngResource'

    'ctrl.calculator'
    'ctrl.invite'

    'dir.moreless'
    'dir.nav.collapse'
    'dir.popover'
    'dir.scroller'
    'dir.scrollto'

    'srv.api'
    'srv.mail'

]


client.config ($locationProvider) ->
    $locationProvider.html5Mode false
