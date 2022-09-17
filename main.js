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
	saveUninitialized: false,
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
    //session = req.session;
	//console.log(req.session)
	if(req.session.userId){
		console.log("logged in")
		return res.send(pug.renderFile('views/home.pug', {fn: ""}))
	}
	res.send(pug.renderFile('views/home.pug'))
}

const getLoginHandler = async (req, res) => {
    return res.send(pug.renderFile('views/login.pug'))
}

const getRegisterHandler = async (req, res) => {
    return res.send(pug.renderFile('views/register.pug'))
}

const postRegisterHandler = async (req, res) => {
    //console.log(req.body)
	const { title, ln, fn, country, state, phone, email, dob, pass, cfm_pass } = req.body
	try{
		const rows = await query(`INSERT INTO users VALUES (0, ?, ?, ?, ?, ?, ?, ?, ?, ?)`, [email, pass, title, fn, ln, phone, dob, country, state])
		//res.status(200).send("Registration successful. Redirecting to home page...");
		res.redirect("/");
	}
	catch (err){
		//console.log('MY SQL ERROR', err);
		console.log(err.sqlMessage);
		res.send(pug.renderFile('views/register.pug', {err: err.sqlMessage}))
	}
	//return res.send(pug.renderFile('views/home.pug')
}

const postLoginHandler = async (req, res) => {
	//console.log(req.body)
	const { email, password } = req.body
    if (!email || !password){}
    const rows = await query(`SELECT * FROM users WHERE email = ? AND pass = ?`, [email, password])
    if (rows.length === 0){
        return res.status(401).send(pug.renderFile('views/login.pug', {err: "Wrong username or password"}))
	}
	req.session.userId = email
	//console.log(req.session)
    return res.redirect("/")
}

app.get('/', authenticationMiddleware, indexHandler)
app.get('/login', authenticationMiddleware, getLoginHandler)
app.post('/login', authenticationMiddleware, urlencodedParser, postLoginHandler)
app.get('/register', authenticationMiddleware, getRegisterHandler)
app.post('/register', authenticationMiddleware, urlencodedParser, postRegisterHandler)