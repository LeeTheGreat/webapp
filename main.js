const mysql = require('mysql2')
const express = require('express')
const session = require('express-session')
const bcrypt = require('bcrypt');
const saltRounds = 10;
const util = require('util')
const mysqlstore = require('express-mysql-session')(session);
const pug = require('pug')
const cookieParser = require('cookie-parser');

const app = express()
const bodyParser = require('body-parser')
const { count, profile } = require('console')
const mysqloptions = {
	host: 'localhost',
	port: 3306,
	user: 'tic4303',
	password: 'tic4303',
	database: 'tic4303',
}
const sessionStore = new mysqlstore(mysqloptions);

app.listen(80, "localhost")
const urlencodedParser = bodyParser.urlencoded({ extended: false })

console.log('application start')

//const scanner = require('sonarqube-scanner').default;

/*
scanner(
  {
    serverUrl: 'http://localhost:9000/',
    token: 'sqp_615808eb37380f5b599506611997b84d21601854',
    options: {
      'sonar.projectName': 'My App',
      'sonar.projectDescription': 'Description for "My App" project...',    
      'sonar.projectKey': 'web-app-on-mainjs'
    },
  },
  error => {
    if (error) {
      console.error(error);
    }
    process.exit();
  },
);
*/

const db = mysql.createConnection({
	host: "localhost",
	port: 3306,
	user: "tic4303",
	password: "tic4303",
	database: "tic4303",
	dateStrings: "true",
});

const query = util.promisify(db.query).bind(db);
app.use(session({
	key: 'session_id'
	,secret: "tic4303"
	,store: sessionStore
	,resave: true
	,saveUninitialized: false
	,httpOnly: true
	,cookie: { maxAge: 1000 * 60 * 60 }
    
}))

app.use(express.static('static'))
app.use(cookieParser())

const authenticationMiddleware = async (req, res, next) => {
	if(req.session.userid){
        console.log('authenticationMiddleware with session.userid')
		next()
	}
	else{
        console.log('authenticationMiddleware without session.userid')
        req.session.destroy()
		return res.redirect('/')
	}
}

const adminAuthenticationMiddleware = async (req, res, next) => {
	if(req.session.admin == 'admin'){
		next()
	}
	else{
		return res.redirect('/admin/login')
	}
}

const InternalServerError_500 = async (req, res) => {
	return res.status(500).send('500 Internal Server Error')
}

const indexHandler = async (req, res) => {
    console.log(req.session)
	try{
        if(!req.session || !req.session.userid){
            console.log('indexHandler without session.userid')
            res.send(pug.renderFile('views/index.pug'))
        }
        else{
            console.log('indexHandler with session.userid')
            res.redirect('/profile')
        }
	}
	catch(e){
		console.log(e)
		InternalServerError_500(req,res)
	}
}

const getLoginHandler = async (req, res) => {
	try{
        console.log('getLoginHandler')
    	return res.send(pug.renderFile('views/login.pug'))
	}
	catch(e){
		console.log(e);
		InternalServerError_500(req,res)
	}
}

const getRegisterHandler = async (req, res) => {
	try{
		if(req.session.email){
            console.log('getRegisterHandler redirect /')
			return res.redirect('/')
		}
        console.log('getRegisterHandler register')
		return res.send(pug.renderFile('views/register_user.pug'))
	}
	catch(e){
		console.log(e);
		InternalServerError_500(req,res)
	}
}

const postRegisterHandler = async (req, res, next) => {
	try{
		let { name, phone, country, gender, qualification, email, password } = req.body
		const salt = await bcrypt.genSalt(10)
		password = await bcrypt.hash(password, salt)
		let rows = await query(`INSERT INTO users (email, password, name, phone, country, gender, qualification) values (?, ?, ?, ?, ?, ?, ?)`, [email, password, name, phone, country, gender, qualification])
		rows = await query(`SELECT * FROM users WHERE email = ? LIMIT 1`, [email])
        rows = rows[0]
        req.session.userid = rows.id
        console.log('postRegisterHandler')
		next()
	}
	catch (e){
		console.log(e)
		InternalServerError_500(req,res)
	}
}

const getRegisterSuccessHandler = async (req, res) => {
	try{
        return res.send(pug.renderFile('views/register_user_success.pug'))
	}
	catch (e){
		console.log(e)
		InternalServerError_500(req,res)
	}
}

const postLoginHandler = async (req, res) => {
	try{
		let { email, password } = req.body
		if (!email || !password){
			return res.send(pug.renderFile('/login'))
		}
		let rows = await query(`SELECT * FROM users WHERE email = ? LIMIT 1`, [email])
		if(rows.length == 0){
			return res.send(pug.renderFile('views/login.pug', {msg: "Wrong username or password"}))	
		}
		rows = rows[0]
		const verified = bcrypt.compareSync(password, rows.password)
		if(!verified){
			return res.send(pug.renderFile('views/login.pug', {msg: "Wrong username or password"}))	
		}
        req.session.userid = rows.id
		return res.redirect("/")
	}
	catch(e){
		console.log(e)
		InternalServerError_500(req,res)
	}
}

const getProfileHandler = async (req, res) => {
	try{
        let rows = await query(`SELECT * FROM users WHERE id = ? LIMIT 1`, [req.session.userid])
        rows = rows[0]
        //console.log(rows)
		let profile = JSON.stringify(rows)
        console.log(profile)
        //return res.send(pug.renderFile('views/profile.pug', {profile: JSON.parse(req.session.profile)}))
        return res.send(pug.renderFile('views/profile.pug', {profile: JSON.parse(profile)}))
	}
	catch(e){
		console.log(e);
		InternalServerError_500(req,res)
	}
}

const postProfileHandler = async (req, res) => {
	try{
		let { name, phone, country, gender, qualification, email, password } = req.body
		//console.log(req.body)
		if(!password){
			var rows = await query(`UPDATE users SET email=?, name=?, phone=?, country=?, gender=?, qualification=? WHERE id=?`, [email, name, phone, country, gender, qualification, req.session.userid])
		}
		if(password){
            const salt = await bcrypt.genSalt(10)
            password = await bcrypt.hash(password, salt)
			var rows = await query(`UPDATE users SET email=?, password=?, name=?, phone=?, country=?, gender=?, qualification=? WHERE id=?`, [email, password, name, phone, country, gender, qualification, req.session.userid])
		}
        var rows = await query(`SELECT * FROM users WHERE id = ? LIMIT 1`, [req.session.userid])
        rows = rows[0]
        let profile = JSON.stringify(rows)
        return res.send(pug.renderFile('views/profile_update_success.pug', {profile: JSON.parse(profile)}))
	}
	catch (e){
		console.log(e)
		InternalServerError_500(req,res)
	}
}


const getLogoutHandler = async (req, res, next) => {
	try{
		req.session.destroy()
		res.redirect('/')
	}
	catch(e){
		console.log(e)
		InternalServerError_500(req,res)
	}
}

app.get('/', indexHandler)
app.get('/login', getLoginHandler)
app.post('/login', urlencodedParser, postLoginHandler)
app.get('/register', getRegisterHandler)
app.post('/register', urlencodedParser, postRegisterHandler, getRegisterSuccessHandler)
app.get('/profile', authenticationMiddleware, getProfileHandler)
app.post('/profile', authenticationMiddleware, urlencodedParser, postProfileHandler)
app.get('/logout', getLogoutHandler)