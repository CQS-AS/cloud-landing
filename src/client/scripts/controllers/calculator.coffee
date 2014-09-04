(angular.module 'ctrl.calculator', []).controller 'ctrlCalculator',
    ($scope) ->
        $scope.calc =
            users: 5
            files: 10

        $scope.total =
            plan: 0
            users:
                inc: 0
                add: 0
            year: 0
            month: 0
            store:
                inc: 0
                add: 0
                extra: 0
        
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
                $scope.total.plan = if $scope.calc.users is 1 then 0 else 1

                planCost = if $scope.calc.users is 1 then CONST.singleCost else CONST.officeCost

                $scope.total.users.inc = if $scope.calc.users is 1 then 1 else 5
                $scope.total.users.add = Math.max 0, $scope.calc.users - $scope.total.users.inc
                userCost = $scope.total.users.add*CONST.userCost

                $scope.total.store.inc = 1*CONST.userGB*$scope.total.users.inc
                $scope.total.store.add = 1*CONST.userGB*$scope.total.users.add
                calcStore = $scope.calc.files*CONST.fileGB
                $scope.total.store.extra = Math.ceil Math.max 0, (calcStore - ($scope.total.store.inc + $scope.total.store.add))/CONST.storeGB
                storeCost = $scope.total.store.extra*CONST.storeCost

                $scope.total.year = planCost + userCost
                $scope.total.month = storeCost


        $scope.$watch 'calc.users', calc
        $scope.$watch 'calc.files', calc


        @