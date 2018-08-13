function ReviewCart() {
    this.expandPreview();
    this.activateAttrAccordion();
}

(function($) {
    /**
     * Expand and collapse the mini-cart
     *
     */
    ReviewCart.prototype.expandPreview = function() {
        var speed = 500,
            minicartW = 0,
            minicart = $('#vlocity-minicart'),
            minicartBtnText = $('button.review-cart-top').text();           
        $('button.review-cart').click(function(e) {            
            e.preventDefault();
            e.stopPropagation();
            var reviewCartBtn = $('.review-cart'),
                rowW = minicart.parent().outerWidth();

            reviewCartBtn.disable(true);
            // Putting back to normal
            if(reviewCartBtn.hasClass('select-config')) {
                
                    minicart.addClass('animating').animate({
                        width: minicartW
                    }, speed, function() {
                        minicart.removeClass('animating').removeClass('expanded');
                        $('#vlocity-filter, #vlocity-richproducts').show();
                        reviewCartBtn.removeClass('select-config').text(minicartBtnText);
                        reviewCartBtn.disable(false);
                    	minicart.css("width","");
                        var c = $('.condense-show');
                        c.addClass('condense');
                        c.removeClass('condense-show');
                    });
                            
            // Fading out other columns and expanding minicart to full width
            }else{
                minicartW = minicart.outerWidth();
                $('#vlocity-filter, #vlocity-richproducts').fadeOut(1, function() {
                    minicart.addClass('animating').animate({
                        width: rowW,
                        margin: '0'
                    }, speed, function() {
                        minicart.removeClass('animating').addClass('expanded');
                        reviewCartBtn.text('Change Order').addClass('select-config');
                        var c = $('.condense');
                        c.addClass('condense-show');
                        c.removeClass('condense');
                        reviewCartBtn.disable(false);
                    });
                });
            }
        });
    };

    /**
     * Toggle product attributes
     *
     */
     ReviewCart.prototype.activateAttrAccordion = function() {
        $('a.attribute-toggle').click(function(e) {
            e.preventDefault();
            var s = $(this).siblings();
            $(this).siblings().slideToggle(500);
//            $(this).children('.attributes-container').slideToggle(500);
//            $(this).children().slideToggle(500);
        });
     };

	/***
	* expand contact items
	*
	*/

     ReviewCart.prototype.activateExpandList = function() {
        $('a.list-toggle').click(function(e) {
            e.preventDefault();
            var s = $(this).siblings();
            $(this).siblings().slideToggle(500);
//            $(this).children('.attributes-container').slideToggle(500);
//            $(this).children().slideToggle(500);
        });
     };
('[class*="someclass"]')

     // Disable function from http://stackoverflow.com/a/16788240/2843948
    jQuery.fn.extend({
        disable: function(state) {
            return this.each(function() {
                this.disabled = state;
            });
        }
    });
}(jQuery));