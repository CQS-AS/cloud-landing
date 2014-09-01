# =============================================================
#/*
#/*	 Angular Smooth Scroll 1.7.0
#/*	 Animates scrolling to elements, by David Oliveros.
#/*
#/*   Callback hooks contributed by Ben Armston
#/*   https://github.com/benarmston
#/*
#/*	 Easing support contributed by Willem Liu.
#/*	 https://github.com/willemliu
#/*
#/*	 Easing functions forked from Gaëtan Renaudeau.
#/*	 https://gist.github.com/gre/1650294
#/*
#/*	 Infinite loop bugs in iOS and Chrome (when zoomed) by Alex Guzman.
#/*	 https://github.com/alexguzman
#/*
#/*	 Influenced by Chris Ferdinandi
#/*	 https://github.com/cferdinandi
#/*
#/*
#/*	 Free to use under the MIT License.
#/*
#/* =============================================================

# Scrolls the window to this element, optionally validating an expression
#

# Scrolls to a specified element ID when this element is clicked
#

# Smooth scrolls the window to the provided element.
#
angular.module("dir.smoothScroll", []).directive("dirSmoothScroll",
    ($timeout, smoothScroll) ->
        return (
            restrict: "A"
            scope:
                callbackBefore: "&"
                callbackAfter: "&"

            link: ($scope, $elem, $attrs) ->
                $timeout ->
                    if typeof $attrs.scrollIf is "undefined" or $attrs.scrollIf is "true"
                        callbackBefore = (element) ->
                            if $attrs.callbackBefore
                                exprHandler = $scope.callbackBefore(element: element)
                                exprHandler element  if typeof exprHandler is "function"
                            return

                        callbackAfter = (element) ->
                            if $attrs.callbackAfter
                                exprHandler = $scope.callbackAfter(element: element)
                                exprHandler element  if typeof exprHandler is "function"
                            return

                        smoothScroll $elem[0],
                            duration: $attrs.duration
                            offset: $attrs.offset
                            easing: $attrs.easing
                            callbackBefore: callbackBefore
                            callbackAfter: callbackAfter

                    return

                return
        )
).directive("scrollTo",
    (smoothScroll) ->
        return (
            restrict: "A"
            scope:
                callbackBefore: "&"
                callbackAfter: "&"

            link: ($scope, $elem, $attrs) ->
                targetElement = undefined
                $elem.on "click", (e) ->
                    targetElement = document.getElementById($attrs.scrollTo)
                    if targetElement
                        e.preventDefault()
                        callbackBefore = (element) ->
                            if $attrs.callbackBefore
                                exprHandler = $scope.callbackBefore(element: element)
                                exprHandler element  if typeof exprHandler is "function"
                            return

                        callbackAfter = (element) ->
                            if $attrs.callbackAfter
                                exprHandler = $scope.callbackAfter(element: element)
                                exprHandler element  if typeof exprHandler is "function"
                            return

                        smoothScroll targetElement,
                            duration: $attrs.duration
                            offset: $attrs.offset
                            easing: $attrs.easing
                            callbackBefore: callbackBefore
                            callbackAfter: callbackAfter

                        false

                return
        )
).factory "smoothScroll",
    ($timeout) ->
        getScrollLocation = ->
            (if window.pageYOffset then window.pageYOffset else document.documentElement.scrollTop)

        smoothScroll = (element, options) ->
            $timeout ->
                startLocation = getScrollLocation()
                timeLapsed = 0
                percentage = undefined
                position = undefined

                # Options
                #
                options = options or {}
                duration = options.duration or 800
                offset = options.offset or 0
                easing = options.easing or "easeInOutQuart"
                callbackBefore = options.callbackBefore or ->

                callbackAfter = options.callbackAfter or ->


                    # Calculate the easing pattern
                    #
                easingPattern = (type, time) ->
                    return time * time  if type is "easeInQuad" # accelerating from zero velocity
                    return time * (2 - time)  if type is "easeOutQuad" # decelerating to zero velocity
                    return (if time < 0.5 then 2 * time * time else -1 + (4 - 2 * time) * time)  if type is "easeInOutQuad" # acceleration until halfway, then deceleration
                    return time * time * time  if type is "easeInCubic" # accelerating from zero velocity
                    return (--time) * time * time + 1  if type is "easeOutCubic" # decelerating to zero velocity
                    return (if time < 0.5 then 4 * time * time * time else (time - 1) * (2 * time - 2) * (2 * time - 2) + 1)  if type is "easeInOutCubic" # acceleration until halfway, then deceleration
                    return time * time * time * time  if type is "easeInQuart" # accelerating from zero velocity
                    return 1 - (--time) * time * time * time  if type is "easeOutQuart" # decelerating to zero velocity
                    return (if time < 0.5 then 8 * time * time * time * time else 1 - 8 * (--time) * time * time * time)  if type is "easeInOutQuart" # acceleration until halfway, then deceleration
                    return time * time * time * time * time  if type is "easeInQuint" # accelerating from zero velocity
                    return 1 + (--time) * time * time * time * time  if type is "easeOutQuint" # decelerating to zero velocity
                    return (if time < 0.5 then 16 * time * time * time * time * time else 1 + 16 * (--time) * time * time * time * time)  if type is "easeInOutQuint" # acceleration until halfway, then deceleration
                    time # no easing, no acceleration


                # Calculate how far to scroll
                #
                getEndLocation = (element) ->
                    location = 0
                    if element.offsetParent
                        loop
                            location += element.offsetTop
                            element = element.offsetParent
                            break unless element
                    location = Math.max(location - offset, 0)
                    location

                endLocation = getEndLocation(element)
                distance = endLocation - startLocation

                # Stop the scrolling animation when the anchor is reached (or at the top/bottom of the page)
                #
                stopAnimation = ->
                    currentLocation = getScrollLocation()
                    if position is endLocation or currentLocation is endLocation or ((window.innerHeight + currentLocation) >= document.body.scrollHeight)
                        clearInterval runAnimation
                        callbackAfter element
                    return


                # Scroll the page by an increment, and check if it's time to stop
                #
                animateScroll = ->
                    timeLapsed += 16
                    percentage = (timeLapsed / duration)
                    percentage = (if (percentage > 1) then 1 else percentage)
                    position = startLocation + (distance * easingPattern(easing, percentage))
                    window.scrollTo 0, position
                    stopAnimation()
                    return


                # Init
                #
                callbackBefore element
                runAnimation = setInterval(animateScroll, 16)
                return

            return

        return smoothScroll
