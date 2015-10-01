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
let socket = new Socket("/socket", {
  logger: (kind, msg, data) => {
    console.log(`${kind}: ${msg}`, data)
  },
  params: {token: window.userToken}
})

socket.connect()
socket.onOpen( () => console.log("connected!") )

let App = {
  init(){
    let docId = $("#doc-form").data("id")
    if(!docId){ return }

    let docChan = socket.channel("documents:" + docId)
    docChan.params["last_message_id"] = 0
    let editor = new Quill("#editor")
    let editorContainer = $("#editor")
    let docForm = $("#doc-form")
    let msgContainer = $("#messages")
    let msgInput = $("#message-input")
    let saveTimer = null

    msgInput.on("keypress", e => { if(e.which !== 13){ return }
      docChan.push("new_message", {body: msgInput.val()})
      msgInput.val("")
    })


    editorContainer.on("keydown", e => {
      if(!(e.which === 13 && e.metaKey)){ return }

      let {start, end} = editor.getSelection()
      let expr = editor.getText(start, end)
      docChan.push("compute_img", {expr, start, end})
    })

    docChan.on("insert_img", ({url, start, end}) => {
      editor.deleteText(start, end)
      editor.insertEmbed(start, "image", url)
    })

    docChan.on("new_message", msg => {
      this.appendMessage(msg, msgContainer, docChan)
    })

    editor.on("text-change", (ops, source) => {
      if(source !== "user"){ return }
      clearTimeout(saveTimer)
      saveTimer = setTimeout(() => {
        this.save(docChan, editor)
      }, 2500)
      docChan.push("text_change", {ops: ops})
    })

    docForm.on("submit", e => {
      e.preventDefault()
      this.save(docChan, editor)
    })

    docChan.on("text_change", ({ops}) => {
      editor.updateContents(ops)
    })

    docChan.on("messages", ({messages}) => {
      messages.reverse().forEach( msg => {
        this.appendMessage(msg, msgContainer, docChan)
      })
    })

    docChan.join()
      .receive("ok", () => { })
      .receive("error", reason => console.log("error!", reason) )
  },

  save(docChan, editor){
    let body = editor.getHTML()
    let title = $("#document_title").val()
    docChan.push("save", {body: body, title: title})
      .receive("ok", () => console.log("saved!") )
  },

  appendMessage(msg, msgContainer, docChan){
    if(docChan.params["last_message_id"] < msg.id){
      docChan.params["last_message_id"] = msg.id
    }
    msgContainer.append(`<br/>${msg.body}`)
    msgContainer.scrollTop(msgContainer.prop("scrollHeight"))
  }

}

App.init()