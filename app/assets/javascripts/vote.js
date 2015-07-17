$(function(){
    $('a.vote').click(function(){
        var $el = $(this);

        $.post(
            $el.attr('href'),
            function(data, status, xhr){
                $el.parents('.row').siblings().find('.vote').removeClass('voted');
                $el.parents('.row').siblings('.score').html(data.score);
                $el.addClass('voted').blur();
            });

        return false;
    });
});
