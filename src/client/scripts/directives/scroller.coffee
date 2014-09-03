(angular.module 'dir.scroller', []).directive 'dirScroller',
    ($timeout) ->

        return {
            restrict: 'A'

            link: (scope, elem, attrs) ->
                values = JSON.parse attrs.dirScroller
                idx = -1

                nextValue = () ->
                    idx = 0 if ++idx is values.length

                    elem.text values[idx]

                    $timeout nextValue, 3000

                    return

                nextValue()
        }