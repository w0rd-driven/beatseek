// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"

let Hooks = {}

Hooks.Menu = {
  getAttr(name){
    let val = this.el.getAttribute(name)
    if(val === null){ throw(new Error(`no ${name} attribute configured for menu`)) }
    return val
  },
  reset(){
    this.enabled = false
    this.activeClass = this.getAttr("data-active-class")
    this.deactivate(this.menuItems())
    this.activeItem = null
    window.removeEventListener("keydown", this.handleKeyDown)
  },
  destroyed(){ this.reset() },
  mounted(){
    this.menuItemsContainer = document.querySelector(`[aria-labelledby="${this.el.id}"]`)
    this.reset()
    this.handleKeyDown = (e) => this.onKeyDown(e)
    this.el.addEventListener("keydown", e => {
      if((e.key === "Enter" || e.key === " ") && e.currentTarget.isSameNode(this.el)){
        this.enabled = true
      }
    })
    this.el.addEventListener("click", e => {
      console.log("click")
      if(!e.currentTarget.isSameNode(this.el)){ return }

      window.addEventListener("keydown", this.handleKeyDown)
      // disable if button clicked and click was not a keyboard event
      if(this.enabled){
        console.log("activate")
        window.requestAnimationFrame(() => this.activate(0))
      }
    })
    this.menuItemsContainer.addEventListener("phx:hide-start", () => this.reset())
  },
  activate(index, fallbackIndex){
    let menuItems = this.menuItems()
    this.activeItem = menuItems[index] || menuItems[fallbackIndex]
    this.activeItem.classList.add(this.activeClass)
    this.activeItem.focus()
  },
  deactivate(items){ items.forEach(item => item.classList.remove(this.activeClass)) },
  menuItems(){ return Array.from(this.menuItemsContainer.querySelectorAll("[role=menuitem]")) },
  onKeyDown(e){
    if(e.key === "Escape"){
      document.body.click()
      this.el.focus()
      this.reset()
    } else if(e.key === "Enter" && !this.activeItem){
      this.activate(0)
    } else if(e.key === "Enter"){
      this.activeItem.click()
    }
    if(e.key === "ArrowDown"){
      e.preventDefault()
      let menuItems = this.menuItems()
      this.deactivate(menuItems)
      this.activate(menuItems.indexOf(this.activeItem) + 1, 0)
    } else if(e.key === "ArrowUp"){
      e.preventDefault()
      let menuItems = this.menuItems()
      this.deactivate(menuItems)
      this.activate(menuItems.indexOf(this.activeItem) - 1, menuItems.length - 1)
    } else if (e.key === "Tab"){
      e.preventDefault()
    }
  }
}

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
  hooks: Hooks,
  params: {_csrf_token: csrfToken}
})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket
