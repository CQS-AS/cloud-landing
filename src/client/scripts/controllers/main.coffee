(angular.module 'ctrl.main', []).controller 'ctrlMain',
    ($scope, facSiteCfg) ->

        $scope.factor = facSiteCfg.price.factor
        $scope.currency = facSiteCfg.price.currency

        @