$( document ).ready(function() {

    //+ Jonas Raoni Soares Silva
    //@ http://jsfromhell.com/array/shuffle [v1.0]
    function shuffle(o){ //v1.0
        for(var j, x, i = o.length; i; j = Math.floor(Math.random() * i), x = o[--i], o[i] = o[j], o[j] = x);
        return o;
    };

    var updateBanners = function (campaign_id) {
        $('#banners').empty().append($('<img>').attr('src', '/campaigns/images/loader.gif'));
        
        $.getJSON('/campaigns/api/' + campaign_id, function(data) {
            $('#banners').empty();
            if (data.error) {
                $('#banners').text(data.error);
            } else {
                $('#campaignId').val(campaign_id);
                //$.each(shuffle(data.banners), function (k,v) {
                //    $('<img>').attr('src', '/campaigns/images/image_' + v + '.png').appendTo('#banners');
                //});
                $('<img>').attr('src', '/campaigns/images/image_' + data.banner + '.png').appendTo('#banners');
            }
        }).fail(function(){
            $('#banners').text('error');
        });
    }

    var campaign = location.pathname.split('/')[2];
    if (campaign) {
        updateBanners(campaign);
    }
});
