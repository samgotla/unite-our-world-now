$(function(){
    $('a.vote').click(function(){
        var $el = $(this);

        $.post(
            $el.attr('href'),
            function(data, status, xhr){
                $el.parents('.post').find('.vote').removeClass('voted');
                $el.parents('.post').find('.score').html(data.score);
                $el.addClass('voted').blur();
            });

        return false;
    });
});
