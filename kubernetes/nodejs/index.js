const express = require('express')
const path = require('path')
const PORT = process.env.PORT || 8080
const dburl = process.env.DB_URL || "local.db"

express()
  .use(express.static(path.join(__dirname, 'public')))
  .set('views', path.join(__dirname, 'views'))
  .set('view engine', 'ejs')
  .get('/', (req, res) => res.render('pages/index', {dburl: dburl}))
  .listen(PORT, () => console.log(`Listening on ${ PORT }`))
