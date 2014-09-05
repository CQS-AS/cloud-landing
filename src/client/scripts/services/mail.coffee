(angular.module 'srv.mail', []).service 'srvMail',

    ($resource, srvApi) ->

        @isBusy = srvApi.isBusy

        @requestInvite = (info, cb) ->
            ($resource '/api/1/invite').save info, (srvApi.okCb cb), (srvApi.errCb cb)
            srvApi.setBusy true


        @