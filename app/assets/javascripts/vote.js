$(function(){
    $('a.vote').click(function(){
        var $el = $(this);

        $.ajax({
            url: $el.attr('href'),
            method: 'PUT'
        }).done(function(data, status, xhr){
            if (data.error){
                return;
            }
            
            $el.parents('.votable').find('.vote').removeClass('voted');
            $el.parents('.votable').find('.score').html(data.score);
            $el.addClass('voted').blur();
        });

        return false;
    });
});
