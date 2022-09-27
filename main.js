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
const { count } = require('console')
const mysqloptions = {
	host: 'localhost',
	port: 3306,
	user: 'airline_admin',
	password: 'password',
	database: 'airline',
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
	dateStrings: "true",
	multipleStatements: true
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
	if(req.session.userid){
		//console.log(req.session)
		next()
	}
	else{
		return res.redirect('/')
	}
}

const loggedInMiddleware = async (req, res, next) => {
	if(!req.session.userid){
		return res.redirect('/')
	}
	next()
}

const indexHandler = async (req, res) => {
    //return res.send(pug.renderFile('templates/index.pug'))
    //session = req.session;
	//console.log("indexHandler(): " + String(req.session))
	console.log(req.session)
	if(req.session.userid){
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
	const { fn, ln, gender, dob, email, pass} = req.body
	try{
		var rows = await query(`INSERT INTO users VALUES (0, ?, ?, ?, ?, ?, ?)`, [email, pass, fn, ln, gender, dob])
		//res.status(200).send("Registration successful. Redirecting to home page...");
		rows = await query(`SELECT id, email, fname, lname FROM users WHERE email=?`, [email])
		req.session.name = rows[0].fname + " " + rows[0].lname
		req.session.email = rows[0].email
		req.session.userid = rows[0].id
		res.redirect("/");
	}
	catch (err){
		//console.log('MY SQL ERROR', err);
		console.log(err.sqlMessage);
		res.send(pug.renderFile('views/register.pug', {msg: err.sqlMessage}))
	}
	//return res.send(pug.renderFile('views/home.pug')
}

const postLoginHandler = async (req, res) => {
	//console.log(req.body)
	const { email, password } = req.body
    if (!email || !password){
		return res.send(pug.renderFile('/login'))
	}
    const rows = await query(`SELECT * FROM users WHERE email = ? AND password = ?`, [email, password])
    if (rows.length == 0){
        return res.status(401).send(pug.renderFile('views/login.pug', {msg: "Wrong username or password"}))
	}
	console.log(rows[0].email);
	req.session.email = rows[0].email
	req.session.name = rows[0].fname + " " + rows[0].lname
	req.session.userid = rows[0].id
	//console.log(req.session)
    return res.redirect("/")
}

const getProfileHandler = async (req, res) => {
	const rows = await query(`SELECT email, fname, lname, gender, dob FROM users WHERE id = ?`, [req.session.userid])
	if(rows.length == 0){
		return res.status(500).send('Something went wrong. Pls login again')
	}
	//console.log(rows)
	profileJSON = JSON.parse(JSON.stringify(rows))
	console.log(profileJSON)
	return res.send(pug.renderFile('views/profile.pug', {profile: profileJSON, fn: req.session.name}))
}

const postProfileHandler = async (req, res) => {
	const { title, fn, ln, gender, email, dob, pass} = req.body
	console.log(req.body)
	try{
		if(!pass){
			var rows = await query(`UPDATE users SET email=?, fname=?, lname=?, gender=?, dob=? WHERE id=?`, [email, fn, ln, gender, dob, req.session.userid])
		}
		if(pass){
			var rows = await query(`UPDATE users SET email=?, fname=?, lname=?, gender=?, dob=?, pass=? WHERE id=?`, [email, fn, ln, dob, pass, req.session.userid])
		}
		req.session.email = email
		req.session.name = fn + " " + ln
		return res.status(200).send("Profile updated")
	}
	catch (err){
		/*
		var rows = await query(`UPDATE users SET email=?, fname=?, lname=?, gender=?, dob=? WHERE email=?`, [email, title, fn, ln, gender, dob, req.session.email])
		profileJSON = JSON.parse(JSON.stringify(rows))
		console.log(err.sqlMessage);
		return res.send(pug.renderFile('views/profile.pug', {profile: profileJSON, msg: err.sqlMessage}))
		*/
		return res.status(500).send(err.sqlMessage)
	}
}


const getLogoutHandler = async (req, res) => {
	req.session.destroy();
	return res.redirect('/');
}



const postFlightSearchHandler = async (req, res) => {
	//console.log(req.body)
	let ts = Date.now() + (2 * 60 * 60 * 1000)

	let date_ob = new Date(ts)
	let date = ("0" + date_ob.getDate()).slice(-2)
	let month = ("0" + (date_ob.getMonth() + 1)).slice(-2)
	let year = date_ob.getFullYear()
	let hours = ("0" + (date_ob.getHours())).slice(-2)
	let minutes = ("0" + (date_ob.getMinutes())).slice(-2)
	let seconds = ("0" + (date_ob.getSeconds())).slice(-2)
	let timeSearch = hours + ':' + minutes + ':' + seconds
	//console.log(timeSearch);
	let sqlDpt = req.body.dpt + ' ' + timeSearch
	//console.log(sqlDpt);
	
	var rows = await query(`SELECT flt_num as "Flt #", ct1.name as "From Country", ct2.name as "To Country", ct1.iso2 as "fc_iso2", ct2.iso2 as "tc_iso2", ap1.name as "From Airport", ap2.name as "To Airport", ap1.iata_code as "fa_iata", ap2.iata_code as "ta_iata", depart as Depart, arrive as Arrive, price as Price from flights as flt
							join airlines as al on al.id = airline_id 
							join airports as ap1 on ap1.iata_code = src_airport_code 
							join airports as ap2 on ap2.iata_code = dst_airport_code 
							join countries as ct1 on ct1.iso2 = src_country_code 
							join countries as ct2 on ct2.iso2 = dst_country_code 
							where Depart >= ? and Arrive <= ? and src_country_code = ? and dst_country_code = ? and src_airport_code = ? and dst_airport_code = ?;`, 
							[sqlDpt, req.body.ret, req.body.from_cty, req.body.to_cty, req.body.from_ap, req.body.to_ap])
	var rowsJSON = JSON.parse(JSON.stringify(rows))
	var rowsKey = Object.keys(rowsJSON[0])
	delete rowsKey[3] //fc_iso2
	delete rowsKey[4] //tc_iso2
	delete rowsKey[7] //fa_iata
	delete rowsKey[8] //ta_iata
	var newRowsKey = rowsKey.filter(word => word)
	
	
	var newRowsKeyJSON = JSON.parse(JSON.stringify(newRowsKey))
	
	console.log(newRowsKeyJSON)
	//console.log(rowsJSON)
	//console.log(rowsKeyJSON)
	
	return res.send(pug.renderFile('views/flight_search_result.pug', {rowsJSON: rowsJSON, pax: req.body.pax, rowsKeyJSON: newRowsKeyJSON}))
}


const getFlightSearchResultHandler = async (req, res) => {
	
}


const getAdminHomeHandler = async (req, res) => {
	console.log("getAdminHomeHandler")
	return res.send(pug.renderFile('views/admin_home.pug', {admin: "admin"}))
}

const getAdminFlightHandler = async (req, res) => {
	//console.log("getAdminFlightHandler")
	/*
	rows = await query(`SELECT 	al.name, flt_num, ct.name as fm_country, ct.name as to_country, 
								ap.name as from_airport, ap.name as to_airport, depart, arrive, ac.company, ac.model
								from flights fl, airlines al, airports ap, countries ct, aircrafts ac 
								join on al.id = airline_id 
								join airports on ap.id = src_airport_id and 
						  title, first_name, last_name, phone, dob FROM users WHERE id = ?`, [req.session.userid])
	*/
	var rows = await query(`SELECT flt.id as ID, flt_num as "Flt #", al.name as "Airline", CONCAT(ac.company, " ", ac.model) as "Aircraft", ct1.name as "From Country", ct2.name as "To Country", ap1.name as "From Airport", ap2.name as "To Airport", depart as Depart, arrive as Arrive, price as Price, status as Status from flights as flt
							join airlines as al on al.id = airline_id
							join airports as ap1 on ap1.iata_code = src_airport_code
							join airports as ap2 on ap2.iata_code = dst_airport_code
							join countries as ct1 on ct1.iso2 = src_country_code
							join countries as ct2 on ct2.iso2 = dst_country_code
							join aircrafts as ac on ac.id = aircraft_id order by Depart asc`)
	var rowsJSON = JSON.parse(JSON.stringify(rows))
	if(rowsJSON.length == 0){
		return res.send(pug.renderFile('views/admin_flight.pug'))
	}
	var rowsKey = Object.keys(rowsJSON[0])
	var rowsKeyJSON = JSON.parse(JSON.stringify(rowsKey))
	//console.log(rowsJSON)
	//console.log(rowsKeyJSON)
	return res.send(pug.renderFile('views/admin_flight.pug', {rowsJSON: rowsJSON, rowsKeyJSON: rowsKeyJSON}))
}

const getAdminFlightAddHandler = async (req, res) => {
	var airlines = await query(`SELECT * FROM airlines`)
	var aircrafts = await query(`SELECT * FROM aircrafts`)
	var airports = await query(`SELECT * FROM airports ORDER BY country_iso2`)
	var countries = await query(`SELECT * FROM countries order by name`)
	var airlinesJSON = JSON.parse(JSON.stringify(airlines))
	var aircraftsJSON = JSON.parse(JSON.stringify(aircrafts))
	var airportsJSON = JSON.parse(JSON.stringify(airports))
	var countriesJSON = JSON.parse(JSON.stringify(countries))
	//console.log(countriesJSON)
	return res.send(pug.renderFile('views/admin_flight_add.pug', {airlines: airlinesJSON, aircrafts: aircraftsJSON, airports: airportsJSON, countries: countriesJSON}))
}

const postAdminFlightAddHandler = async (req, res) => {
	//console.log(req.body)
	var sqlDptDate = req.body.dpt_date + " " + req.body.dpt_time
	var sqlArrDate = req.body.arr_date + " " + req.body.arr_time
	try{
		/*
		var rows = await query(`INSERT INTO flights values (NULL,?,?,?,?,?,?,?,?,?,?,?)`, 
							[req.body.flt_num, Number(req.body.airline), Number(req.body.aircraft), Number(req.body.fm_airport), Number(req.body.to_airport), Number(req.body.fm_country), Number(req.body.to_country), sqlDptDate, sqlArrDate, Number(req.body.price), req.body.status])
		res.status(200).send("Flight added")
		*/
		var rows = await query(`CALL sp_flights_insert(?,?,?,?,?,?,?,?,?,?,?,@ret,@msg); SELECT @ret,@msg`, [req.body.flt_num, Number(req.body.airline), Number(req.body.aircraft), req.body.fm_airport, req.body.to_airport, req.body.fm_country, req.body.to_country, sqlDptDate, sqlArrDate, Number(req.body.price), req.body.status])
		var rowsJSON = JSON.stringify(rows)
		var rowsObj = JSON.parse(rowsJSON)
		console.log(rowsJSON)
		// return is [{"fieldCount":0,"affectedRows":1,"insertId":0,"serverStatus":10,"warningCount":0,"message":"","protocol41":true,"changedRows":0},[{"@ret":1,"@msg":null}]]
		// really confusing JSON
		// rowsObj[1] ==> [{"@ret":1,"@msg":null}] ---> still an array
		// rowsObj[1][0] ==> {"@ret":1,"@msg":null} ---> an object
		// rowsObj[1][0]['@ret'] ==> getting the data '@ret' = 1
		if(rowsObj[1][0]['@ret'] != 1){
			return res.status(500).send(rowsObj[1][0]['@msg'])
		}
		return res.status(200).send('Flight updated')
		//console.log("sp_flights_insert rows: " + rowsJSON)
		//call sp_flights_insert('1111',2,2,2,2,210,210,'1111-11-11 11:11:11','1111-11-12 11:11:12', 1111, 'active', @ret); select @ret;
		//res.redirect('/admin/flight/add')
	}
	catch (err){
		console.log(err);
		return res.status(500).send(err.sqlMessage);
	}		
}

const getAdminFlightEditHandler = async (req, res) => {
	var airlinesJSON = JSON.parse(JSON.stringify(await query(`SELECT * from airlines`)))
	var aircraftsJSON = JSON.parse(JSON.stringify(await query(`SELECT * from aircrafts`)))
	var airportsJSON = JSON.parse(JSON.stringify(await query(`SELECT * from airports`)))
	var countriesJSON = JSON.parse(JSON.stringify(await query(`SELECT * from countries`)))
	var rowsJSON = [{}]
	try{
		let rows = await query(`SELECT *, DATE_FORMAT(depart, '%Y-%m-%d %k:%i') as depart, DATE_FORMAT(arrive, '%Y-%m-%d %k:%i') as arrive FROM flights WHERE id=?`, [req.query.flt_id])
		rowsJSON = JSON.parse(JSON.stringify(rows))
	}
	catch (err){
		console.log(err.sqlMessage);
		return res.status(500).send(err.sqlMessage);
	}
	//console.log(rowsJSON)
	if(rowsJSON.length == 0){
		return res.status(500).send('No result returned');
	}
	rowsJSON[0].dpt_date = rowsJSON[0].depart.split(' ')[0]
	rowsJSON[0].arr_date = rowsJSON[0].arrive.split(' ')[0]
	rowsJSON[0].dpt_time = rowsJSON[0].depart.split(' ')[1]
	rowsJSON[0].arr_time = rowsJSON[0].arrive.split(' ')[1]
	//console.log(rowsJSON)
	return res.send(pug.renderFile('views/admin_flight_edit.pug', {airlines: airlinesJSON, aircrafts: aircraftsJSON, airports: airportsJSON, countries: countriesJSON, rowsJSON: rowsJSON}))
}

const postAdminFlightEditHandler = async (req, res) => {
	console.log(req.body)
	try{
		await query(`UPDATE flights SET status=? WHERE id=?`, [req.body.status, req.body.flt_id])
	}
	catch(err){
		return res.status(500).send(err.sqlMessage)
	}
	return res.redirect('/admin/flight')
}

const getAdminBookingHandler = async (req, res) => {
	console.log("getAdminBookingHandler")
	return res.send(pug.renderFile('views/admin_booking.pug', {admin: "admin"}))
}

app.get('/', indexHandler)
app.post('/flight/search', urlencodedParser, postFlightSearchHandler)
app.get('/flight/search/result', getFlightSearchResultHandler)
app.get('/login', getLoginHandler)
app.post('/login', urlencodedParser, postLoginHandler)
app.get('/register', getRegisterHandler)
app.post('/register', urlencodedParser, postRegisterHandler)
app.get('/profile', authenticationMiddleware, getProfileHandler)
app.post('/profile', authenticationMiddleware, loggedInMiddleware, urlencodedParser, postProfileHandler)
app.get('/logout', getLogoutHandler)
app.get('/admin', getAdminHomeHandler)
app.get('/admin/flight', getAdminFlightHandler)
app.get('/admin/booking', getAdminBookingHandler)
app.get('/admin/flight/add', getAdminFlightAddHandler)
app.post('/admin/flight/add', urlencodedParser, postAdminFlightAddHandler)
app.get('/admin/flight/edit', urlencodedParser, getAdminFlightEditHandler)
app.post('/admin/flight/edit', urlencodedParser, postAdminFlightEditHandler)