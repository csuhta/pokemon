//= require lib/jquery

$(function() {
  $("form").submit(function(event) {
    event.preventDefault();
    var $self = $(event.target);
    var query = $self.find("input").val();
    window.location = $self.data("query") + query;
  })
});

(function(i,s,o,g,r,a,m){i["GoogleAnalyticsObject"]=r;i[r]=i[r]||function(){
(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
})(window,document,"script","https://www.google-analytics.com/analytics.js","ga");

ga("create", "UA-80913523-2", "auto");
ga("send", "pageview");
