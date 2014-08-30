(angular.module 'dir.popover', []).directive 'dirPopover',

    () ->

        (scope, element, attrs) ->
            element.popover
                trigger  : 'hover'
                placement: 'auto left'

            return