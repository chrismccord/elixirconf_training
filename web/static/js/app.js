// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "deps/phoenix_html/web/static/js/phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"
import {Socket} from "deps/phoenix/web/static/js/phoenix"
let socket = new Socket("/socket", {params: {token: window.userToken}})

socket.connect()
socket.onOpen( () => console.log("connected!") )

let App = {
  init(){
    let docId = $("#doc-form").data("id")
    let docChan = socket.channel("documents:" + docId)
    let editor = new Quill("#editor")

    editor.on("text-change", (ops, source) => {
      if(source !== "user"){ return }
      docChan.push("text_change", {ops: ops})
    })

    docChan.on("text_change", ({ops}) => {
      editor.updateContents(ops)
    })

    docChan.join()
      .receive("ok", resp => console.log("joined!", resp) )
      .receive("error", reason => console.log("error!", reason) )
  }
}

App.init()