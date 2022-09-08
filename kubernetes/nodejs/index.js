const express = require('express')
const path = require('path')
const PORT = process.env.PORT || 8080
const ws = process.env.WORKSPACE || "local"

express()
  .use(express.static(path.join(__dirname, 'public')))
  .set('views', path.join(__dirname, 'views'))
  .set('view engine', 'ejs')
  .get('/', (req, res) => res.render('pages/index', {workspace: ws}))
  .listen(PORT, () => console.log(`Listening on ${ PORT }`))
