(angular.module 'dir.scroller', []).directive 'dirScroller',
    ($timeout) ->

        converter = new Showdown.converter()

        return {
            restrict: 'A'

            link: (scope, elem, attrs) ->
                for v in JSON.parse attrs.dirScroller
                    elem.append converter.makeHtml v

                children = elem.children()
                children.addClass 'hidden'

                idx = -1
                nextValue = () ->
                    unless idx is -1
                        children.slice(idx, idx + 1).addClass 'pullUpFade'
                        children.slice(idx, idx + 1).removeClass 'pullUp'

                    idx = 0 if ++idx is children.length

                    children.slice(idx, idx + 1).addClass 'pullUp'
                    children.slice(idx, idx + 1).removeClass 'hidden'
                    children.slice(idx, idx + 1).removeClass 'pullUpFade'

                    $timeout nextValue, 3000

                    return

                nextValue()
        }