(function() {
  $(function() {
    $("#fullPage").fullpage({
      anchors: ['', 'eCigarettes', 'eLiquids', 'pricing'],
      verticalCentered: true,
      resize: false,
      css3: true,
      menu: "#menu",
      navigation: true
    });
    return $("#bgVid").get(0).play();
  });

}).call(this);
