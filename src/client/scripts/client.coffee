client = angular.module 'client', [

    'dir.moreless'
    'dir.nav.collapse'
    'dir.popover'
    'dir.smoothScroll'
]


client.config ($locationProvider) ->
    $locationProvider.html5Mode false
