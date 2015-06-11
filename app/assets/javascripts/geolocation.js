var Geolocation = {
    update: function(location){
        var lat = location.coords.latitude;
        var lng = location.coords.longitude;

        // When location is retrieved from browser, disable input
        $('#user_latitude').val(lat);
        $('#user_longitude').val(lng);
        $('#user_zip_code')
            .val('')
            .prop('disabled', true);

        // Display success check button
        $('#get_location span')
            .removeClass('glyphicon-map-marker')
            .addClass('glyphicon-ok');

        $('#get_location')
            .prop('disabled', true)
            .removeAttr('title');
    },

    error: function(err){
        $('#get_location span')
            .removeClass('glyphicon-map-marker')
            .addClass('glyphicon-alert');

        $('#get_location')
            .prop('disabled', true)
            .removeAttr('title');

        console.error(err);
    },

    start: function(){
        navigator.geolocation.getCurrentPosition(
            Geolocation.update, Geolocation.error
        );
    }
};

$(function(){
    $('#get_location').click(Geolocation.start);
});
