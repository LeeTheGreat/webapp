const mysql = require('mysql')
const express = require('express')
const session = require('express-session')
const crypto = require('crypto')
const util = require('util')
const mysqlstore = require('express-mysql-session')(session);
const pug = require('pug')

const app = express()
const bodyParser = require('body-parser')
const mysqloptions = {
	host: 'localhost',
	port: 3306,
	user: 'airline_admin',
	password: 'password',
	database: 'airline'
}
const sessionStore = new mysqlstore(mysqloptions);

app.listen(80, "localhost")
const urlencodedParser = bodyParser.urlencoded({ extended: false })

var msg = 'hello world'
console.log(msg)

const db = mysql.createConnection({
	host: "localhost",
	port: 3306,
	user: "airline_admin",
	password: "password",
	database: "airline"
  });

const query = util.promisify(db.query).bind(db);
app.use(session({
	key: 'sessionid',
	secret: crypto.randomBytes(32).toString('hex'),
	store: sessionStore,
	resave: false,
	saveUninitialized: true,
	cookie: { maxAge: 1000 * 60 * 60 * 24 },
}))

app.use(express.static('static'))

const authenticationMiddleware = async (req, res, next) => {
	/*
	if(req.session.userId){
		next()
	}
	*/
	next()
}

const indexHandler = async (req, res) => {
    //return res.send(pug.renderFile('templates/index.pug'))
	//req.session.userId = 'aaaa';
	return res.send(pug.renderFile('views/home.pug'))
}

const getLoginHandler = async (req, res) => {
    return res.send(pug.renderFile('views/login.pug'))
}

const getRegisterHandler = async (req, res) => {
    return res.send(pug.renderFile('views/register.pug'))
}

const postRegisterHandler = async (req, res) => {
    console.log(req.body)
	const { title, ln, fn, cty, state, phone, email, dob_d, dob_m, dob_y, pass, cfm_pass, register } = req.body
	console.log(title);
	//const rows = await query(`INSERT INTO users VALUES(NULL, ?, ?, ?, ?, ?, ?, ?) * FROM users WHERE email = ? AND password = ?`, [email, password])
	//return res.send(pug.renderFile('views/home.pug')
}

const postLoginHandler = async (req, res) => {
    const { email, password } = req.body
    if (!email || !password)
        return res.status(400).send({ message: 'Missing email or password' })

    const rows = await query(`SELECT * FROM users WHERE email = ? AND password = ?`, [email, password])
    if (rows.length === 0)
        return res.status(401).send({ message: 'Invalid email or password' })

    req.session.userId = rows[0].id
    return res.status(200).send({ message: "Success" })
}

app.get('/', authenticationMiddleware, indexHandler)
app.get('/login', authenticationMiddleware, getLoginHandler)
app.get('/register', authenticationMiddleware, getRegisterHandler)
app.post('/register', authenticationMiddleware, urlencodedParser, postRegisterHandler)