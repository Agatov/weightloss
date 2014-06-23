$ ->

  $('.scroll-to-form').on 'click', ->
    $('body').animate({scrollTop: $('#order-form').offset().top}, 'slow')