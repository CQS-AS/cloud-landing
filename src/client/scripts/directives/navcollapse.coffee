(angular.module 'dir.nav.collapse', []).directive 'dirNavCollapse',

    () ->

        (scope, element, attrs) ->
            ($ window).scroll () ->
                if element.offset().top > 50
                    element.addClass 'top-nav-collapse'
                else
                    element.removeClass 'top-nav-collapse'

            return