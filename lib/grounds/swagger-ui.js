(function() {
  var SwaggerUi,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  SwaggerUi = (function() {

    SwaggerUi.prototype.dom_id = "swagger_ui";

    function SwaggerUi(options) {
      if (options == null) options = {};
      this.render = __bind(this.render, this);
      if (options.dom_id != null) {
        this.dom_id = options.dom_id;
        delete options.dom_id;
      }
      options.success = this.render;
      this.api = new SwaggerApi(options);
    }

    SwaggerUi.prototype.render = function() {
      if (!($("#" + this.dom_id).length > 0)) {
        $('body').append("<div id='" + this.dom_id + "'></div>");
      }
      this.ready = true;
      return this;
    };

    return SwaggerUi;

  })();

  window.SwaggerUi = SwaggerUi;

}).call(this);
