var Geolocation = {
    update: function(location){
        var lat = location.coords.latitude;
        var lng = location.coords.longitude;

        // Don't update if loc hasn't changed
        if (user_location.lat == lat && user_location.lng == lng){
            return;
        }

        var url = $('#users_path').attr('href');
        var obj = { user: {
            latitude: lat,
            longitude: lng
        }};

        $.ajax({
            url: url,
            type: 'PUT',
            contentType: 'application/json',
            data: JSON.stringify(obj)
        });
    },

    error: function(err){
        console.error(err);
    },

    start: function(){
        navigator.geolocation.getCurrentPosition(
            Geolocation.update, Geolocation.error
        );
    }
};

$(Geolocation.start);
