(angular.module 'ctrl.invite', []).controller 'ctrlInvite',
    ($scope, srvMail) ->

        $scope.busy = srvMail.isBusy
        $scope.done = false
        $scope.error = null

        $scope.req =
            employees: "11-25 employees"
            cwt      : "No"
            country  : "South Africa"
            tandc    : false


        $scope.request = () ->
            srvMail.requestInvite $scope.req, (err) ->
                if err
                    console.log err
                    $scope.error = error

                else
                    $scope.done = true


        @
