(angular.module 'srv.api', []).service 'srvApi',
    () ->
        busy = 0


        @isBusy = () ->
            busy isnt 0


        setBusy = @setBusy = (flag) ->
            if flag then busy++ else busy--


        @okCb = (cb, noflag) ->
            (r) ->
                cb? null, r.res
                setBusy false unless noflag


        @errCb = (cb, noflag) ->
            (e) ->
                console.error 'srvApi.errCb', e
                cb? e
                setBusy false unless noflag


        @
