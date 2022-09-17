const mysql = require('mysql')
const express = require('express')
const session = require('express-session')
const crypto = require('crypto')
const util = require('util')
const mysqlstore = require('express-mysql-session')(session);
const pug = require('pug')

const app = express()
const bodyParser = require('body-parser')
const e = require('express')
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
	database: "airline",
	dateStrings: "true"
  });

const query = util.promisify(db.query).bind(db);
app.use(session({
	key: 'sessionid',
	secret: "airline",
	store: sessionStore,
	resave: false,
	saveUninitialized: false,
	cookie: { maxAge: 1000 * 60 * 60 * 24 },
}))

app.use(express.static('static'))

const authenticationMiddleware = async (req, res, next) => {
	if(req.session.email){
		//console.log(req.session)
		next()
	}
	else{
		return res.redirect('/')
	}
}

const indexHandler = async (req, res) => {
    //return res.send(pug.renderFile('templates/index.pug'))
	//req.session.userId = 'aaaa';
    //session = req.session;
	console.log(req.session)
	if(req.session.email){
		//console.log("logged in")
		return res.send(pug.renderFile('views/home.pug', {fn: req.session.name}))
	}
	res.send(pug.renderFile('views/home.pug'))
}

const getLoginHandler = async (req, res) => {
    return res.send(pug.renderFile('views/login.pug'))
}

const getRegisterHandler = async (req, res) => {
	if(req.session.email){
		return res.redirect('/')
	}
    return res.send(pug.renderFile('views/register.pug'))
}

const postRegisterHandler = async (req, res) => {
    //console.log(req.body)
	const { title, fn, ln, country, state, phone, email, dob, pass, cfm_pass } = req.body
	try{
		var rows = await query(`INSERT INTO users VALUES (0, ?, ?, ?, ?, ?, ?, ?)`, [email, pass, title, fn, ln, phone, dob])
		//res.status(200).send("Registration successful. Redirecting to home page...");
		res.session.email = rows[0].email
		req.session.name = fn + " " + ln

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
    if (!email || !password){
		return res.send(pug.renderFile('/login'))
	}
    const rows = await query(`SELECT * FROM users WHERE email = ? AND pass = ?`, [email, password])
    if (rows.length === 0){
        return res.status(401).send(pug.renderFile('views/login.pug', {err: "Wrong username or password"}))
	}
	//console.log(rows);
	req.session.email = rows[0].email
	req.session.name = rows[0].first_name + " " + rows[0].last_name
	//console.log(req.session)
    return res.redirect("/")
}

const getProfileHandler = async (req, res) => {
	const rows = await query(`SELECT email, title, first_name, last_name, phone, dob FROM users WHERE email = ?`, [req.session.email])
	console.log(rows)
	profileJSON = JSON.parse(JSON.stringify(rows))
	//console.log(rows_JSON)
	return res.send(pug.renderFile('views/profile.pug', {profile: profileJSON, fn: req.session.name}))
}

const getLogoutHandler = async (req, res) => {
	req.session.destroy();
	return res.redirect('/');
}

app.get('/', indexHandler)
app.get('/login', getLoginHandler)
app.post('/login', urlencodedParser, postLoginHandler)
app.get('/register', getRegisterHandler)
app.post('/register', urlencodedParser, postRegisterHandler)
app.get('/profile', authenticationMiddleware, getProfileHandler)
app.get('/logout', getLogoutHandler)
