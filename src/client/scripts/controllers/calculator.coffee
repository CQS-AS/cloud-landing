(angular.module 'ctrl.calculator', []).controller 'ctrlCalculator',
    ($scope) ->
        $scope.calc =
            users: 5
            files: 10

        $scope.total =
            year: 0
            month: 0
            storeInc: 0
            storeExtra: 0
        
        CONST =
            fileGB: 0.05
            userGB: 5
            storeGB: 5

            userCost: 11*5*12
            storeCost: 11*5

            singleCost: 11*10*12
            officeCost: 11*25*12


        calc = () ->
            if $scope.calc.users > 0
                planCost = if $scope.calc.users is 1 then CONST.singleCost else CONST.officeCost

                planUsers = if $scope.calc.users is 1 then 1 else 5
                extraUsers = Math.max 0, $scope.calc.users - planUsers
                userCost = extraUsers*CONST.userCost

                $scope.total.storeInc = 1*CONST.userGB*$scope.calc.users
                calcStore = $scope.calc.files*CONST.fileGB
                console.log "calcStore=#{calcStore}, calcStore-storeInc=#{calcStore - $scope.total.storeInc}"
                $scope.total.storeExtra = Math.ceil Math.max 0, (calcStore - $scope.total.storeInc)/CONST.storeGB
                storeCost = $scope.total.storeExtra*CONST.storeCost

                $scope.total.year = planCost + userCost
                $scope.total.month = storeCost


        $scope.$watch 'calc.users', calc
        $scope.$watch 'calc.files', calc


        @