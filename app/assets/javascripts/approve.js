$(function(){
    $('a.moderate').click(function(){
        var $el = $(this);

        $.ajax({
            url: $el.attr('href'),
            method: 'PUT'
        }).done(function(data, status, xhr){
            if (data.approved){
                $el.find('span')
                    .removeClass('glyphicon-ok')
                    .addClass('glyphicon-remove');
            } else {
                $el.find('span')
                    .removeClass('glyphicon-remove')
                    .addClass('glyphicon-ok');
            }

            $el.blur();
        });

        return false;
    });
});
