// NewsletterUsers Module
var NewsletterUsers = angular.module("NewsletterUser", ["ListView", "Filter", "Anim", "Fields",]);

// NewsletterUsers configuration section ---------------------------
NewsletterUsers.config(["$routeProvider", function($routeProvider){
    // Add any route you need here
    $routeProvider.
        when("/newsletter_users", {
            templateUrl: template("newsletter_user/index"),
            controller: "NewsletterUserController"
        }).
        when("/newsletter_users/new",{
            templateUrl: template("newsletter_user/new"),
            controller: "AddNewsletterUserController"
        }).
        when("/newsletter_users/:id/edit",{
            templateUrl: template("newsletter_user/new"),
            controller: "AddNewsletterUserController"
        });
}]);


// NewsletterUser index controller -------------------------------------------------------
// This controller is responsible for list page (index)
NewsletterUsers.controller("NewsletterUserController", ["$scope", "gettext", "Restangular", "catch_error", "$location", "$routeParams", function($scope, gettext, API, catch_error, $location, $routeParams){

    
    
    // Cache object for each field name possible values
    $scope.cache = {};

    // Change event handler for field_name combobox in bulk edit
    $scope.field_name_change = function(x){
        var current_value = $("#field_name").val();
        $scope.current_field= _.find($scope.fields, function(x){
            return x.name == current_value;
        });
        if( "to" in $scope.current_field ){
            if (! ($scope.current_field.name in $scope.cache)) {
                $scope.current_field.to().then(function(x){
                    $scope.cache[$scope.current_field.name] = x;
                });
            }
        }
    };

    $scope.columns = [];
    $scope.fields = [
    ];

    // details_template is the address of template which should load for
    // each item details section
    $scope.details_template = template("newsletter_user/details");

    // Buttons for top of the list-view
    $scope.buttons = [
        {
            title: gettext("New"),
            icon: "fa fa-plus",
            classes: "btn tiny green",
            permission: {
              name: "create",
              model: "NewsletterUser"
            },
            route: "#/newsletter_users/new"

         },
        {
            title: gettext("Bulk Edit"),
            icon: "fa fa-edit",
            classes: "btn tiny yellow",
            permission: {
              name: "update",
              model: "NewsletterUser"
            },
            action: function(){
                $scope.$apply("bulk_edit = ! bulk_edit");
            },

        },
        {
            title: gettext("Duplicate"),
            icon: "fa fa-files-o",
            classes: "btn tiny red",
            permission: {
              name: "create",
              model: "NewsletterUser"
            },
            action: function(){
                var selected = _.find($scope.newsletter_users, function(x){
                    return x.is_selected === true;
                });

                if (selected === undefined ) {
                    error_message(gettext("You should only select one item to copy."));
                }
                else {
                    $location.path("/newsletter_users/-" + selected.id + "/edit");
                }
            }
        }

    ];

    /*
     * On bulk save event
     */
    $scope.bulk_save = function(){

        $scope.view_progressbar = true;
        var value = $("#field_value").val();
        var field = $scope.current_field.name;
        var type = $scope.current_field.type;
        var field_name = $scope.current_field.title;
        if ((type == "has_many") || (type == "belongs_to")) {
            value = parseInt(value, 10);
        }
        var requests_count = 0;

        $scope.rfiller = 0;
        $scope.sfiller = 0;
        $scope.success = 0;
        $scope.failed = 0;
        $scope.total = _.where($scope.newsletter_users, function(x){return x.is_selected === true;}).length;

        _.each($scope.newsletter_users, function(x){
            if( x.is_selected === true ){
                x[field] = value;
                requests_count++;

                var rwidth = (requests_count * 100) / $scope.total;
                if (requests_count == $scope.total) { rwidth = 100; }
                $scope.rfiller = rwidth + "%";

                API.one("newsletter_users", x.id).patch(x).then(function(data){
                    $scope.success++;
                    var swidth = parseInt(($scope.success * 100) / $scope.total);
                    if ($scope.sucess == $scope.total) { swidth = 100; }
                    $scope.sfiller = swidth + "%";
                    x[field_name.toLowerCase()] = data[field_name.toLowerCase()];
                }, function(data){
                    $scope.failed++;
                    catch_error(data);
                });

            }
        });

    };

    /*
     * On bulk cancel event
     */
    $scope.bulk_cancel = function(){
        $("#field_name").val(0);
        document.getElementById("bulk_form").reset();
        $scope.view_progressbar = false;
        $scope.bulk_edit = false;
    };
    
    /*
     * On delete event handler - `items` is an array of objects to delete
     */
    $scope.on_delete = function(items){

        var query = [];
        items.forEach(function(item){
            query.push(item.id);
        });

        API.all("newsletter_users").customDELETE(query.join(","))
            .then(function(data) {

                $scope.newsletter_users = _.filter($scope.newsletter_users, function(x){
                    return !(query.indexOf(x.id) != -1);
                });
                success_message(data.msg);
            }, function(data){
                catch_error(data);
            });

    };
    
    
    API.all("newsletter_users").getList()
        .then(function(data){
            $scope.newsletter_users = data;
        }, function(data){
            catch_error(data);
        });
     
}]);


NewsletterUsers.controller("AddNewsletterUserController", ["Restangular", "$scope", "$location", "$routeParams", "gettext", "catch_error", function(API, $scope, $location, $routeParams, gettext, catch_error){

    

    $scope.select2options = {};
    $scope.editing = false;
    $scope.obj_id = null;
    var is_copy = false;

    
    
    if( "id" in $routeParams ){
        $scope.obj_id = $routeParams.id;
        $scope.editing = true;
        if ($scope.obj_id < 0) {
            is_copy = true;
            $scope.obj_id = $scope.obj_id * -1;
        }

        var obj = API.one("newsletter_users", $scope.obj_id).get()
                .then(function(data) {
                
                    $scope.email = data.email;
                }, function(data){
                    catch_error(data);
                });

    }

    $scope.have = function(field, obj_id) {
        var tmp = _.where($scope[field], {id: obj_id});
        if (tmp.length > 0) {
            return true;
        }
        else {
            return false;
        }
    };

    $scope.cancel = function(){
        $(".form input").val("");
        $location.path("/newsletter_users");
    };

    $scope.save = function(save_another){
        $("small.error").html("");
        $("small.error").removeClass("error");

        var newsletter_user = {newsletter_user: {
            email: $scope.email,
            __res__: 0
        }};
        if (($scope.obj_id) && (is_copy === false)) {

            API.one("newsletter_users", $scope.obj_id).patch(newsletter_user)
                .then(function(){
                    success_message(gettext("NewsletterUser updated successfully."));
                    if (save_another) {
                        $(".form input").val("");
                    }
                    else {
                        $location.path("/newsletter_users");
                    }
                }, function(data){
                    catch_error(data);
                });

        }
        else {
            API.all("newsletter_users").customPOST(newsletter_user, "").then(function(){
                success_message(gettext("NewsletterUser created successfully."));
                if (save_another) {
                    $(".form input").val("");
                }
                else {
                    $location.path("/newsletter_users");
                }
            }, function(data){
                catch_error(data);
            });
        }

    };
}]);




