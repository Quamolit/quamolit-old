doctype

html
  head
    title "Quamolit"
    meta (:charset utf-8)
    script(:src build/vendor.js)
    @if (@ dev)
      @block
        link (:rel stylesheet) (:href src/main.css)
        script (:defer) (:src build/main.js)
      @block
        link (:rel stylesheet) (:href build/main.css)
        script (:defer) (:src build/main.js)
  body
