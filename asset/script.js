var sliderApp = angular.module('MyApp', ['ngAnimate', 'ngResource']);
sliderApp
.directive('slider', ['$resource', '$interval', function($resource, $interval) {
    return {
        restrict: 'AE',
        replace: true,
        link: function(scope, elem, attrs) {
            // Initial
            scope.dataLoaded = false;
            var data = $resource('json/images.json').query();
            data.$promise.then(function() {
                scope.images = data;
                scope.dataLoaded = true;
            });

            // Add images
            scope.addImages = function() {
                var newData = $resource('json/images.json').query();
                newData.$promise.then(function() {
                    if(scope.images.length < newData.length) {
                        scope.images.push(newData[scope.images.length]);
                    }
                });
            }
            $interval(function() {
                scope.addImages();
            }, 3000);

            // Intial index number
            scope.currentIndex = 0;
            scope.randomIndex = function() {
                scope.currentIndex = Math.floor(Math.random() * (scope.images.length));
                scope.images.forEach(function(image) {
                    image.visible = false;
                });
                scope.images[scope.currentIndex].visible = true;
            };
            // Loop images
            var t = $interval(function() {
                scope.randomIndex();
            }, 4000);
            scope.onclick = function() {
                $interval.cancel(t);
            };

        },
        templateUrl: 'slider.html'
    };
}])

.controller('randomController', ['$scope', '$resource', 'sharedService', function($scope, $resource, sharedService) {
    $scope.start = true;
    // Initial
    $scope.onStart = function(){
        $scope.start = false;
        $scope.loading = true;

        var data = $resource('json/random.json').query();
        data.$promise.then(function() {
            $scope.images = sharedService.shuffleArray(data);
            // Waiting a few sec.
            var time = new Date().getTime();
            while (new Date().getTime() < time + 3000);

            $scope.loading = false;
            var i = 1;
            $scope.images.forEach(function(image) {
                if(i <= 15) {
                    image.visible = true;
                }
                i++;
            });
        });
    }
}])
.service('sharedService', function(){
    return {
        shuffleArray: function(array) {
            return array.map(function(a){return {weight:Math.random(), value:a}}).sort(function(a, b){return a.weight - b.weight}).map(function(a){return a.value});
        }
    }
})

.controller('top3Controller', ['$scope', '$resource', function($scope, $resource) {
    var data = $resource('json/contest.json').get();
    data.$promise.then(function() {
        $scope.contests = data;
    });

    $scope.getResult = function(award, number) {
        $scope.top = false;

        $scope.award = award;
        if(number == 0) {
            $scope.first = $scope.contests[award][number];
        } else {
            $scope.second = $scope.contests[award][number];
            $scope.third = $scope.contests[award][number+1];
        }
    }

    $scope.showResultAll = function() {
        $scope.top = false;
        $scope.show = true;
    }

    $scope.backToList = function() {
        resetResultScope();
        $scope.top = true;
    }

    $scope.onStart = function(){
        $scope.start = false;
        $scope.top = true;
    }

    // Reset previous award from scope
    function resetResultScope() {
        $scope.first = null;
        $scope.second = null;
        $scope.third = null;
    }

}])