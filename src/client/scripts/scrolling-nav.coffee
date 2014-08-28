# jQuery for page scrolling feature - requires jQuery Easing plugin
$ () ->
    ($ '.page-scroll a').bind 'click', (event) ->
        $anchor = $ @

        ($ 'html, body').stop().animate
            scrollTop: ($ $anchor.attr 'href').offset().top
        , 1500, 'easeInOutExpo'

        event.preventDefault()
