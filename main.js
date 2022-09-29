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

const SQLError = async (req,res,error) => {
	console.log(error);
	return res.status(500).send("Server Error: " + error.sqlMessage);
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
	//console.log(rows[0].email);
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
	
	var rows = await query(`SELECT flt.id, flt_num as "Flt #", ct1.name as "From Country", ct2.name as "To Country", ct1.iso2 as "fc_iso2", ct2.iso2 as "tc_iso2", ap1.name as "From Airport", ap2.name as "To Airport", ap1.iata_code as "fa_iata", ap2.iata_code as "ta_iata", depart as Depart, arrive as Arrive, price as Price from flights as flt
							join airlines as al on al.id = airline_id 
							join airports as ap1 on ap1.iata_code = src_airport_code 
							join airports as ap2 on ap2.iata_code = dst_airport_code 
							join countries as ct1 on ct1.iso2 = src_country_code 
							join countries as ct2 on ct2.iso2 = dst_country_code 
							where Depart >= ? and Arrive <= ? and src_country_code = ? and dst_country_code = ? and src_airport_code = ? and dst_airport_code = ?;`, 
							[sqlDpt, req.body.ret, req.body.from_cty, req.body.to_cty, req.body.from_ap, req.body.to_ap])
	var rowsJSON = JSON.parse(JSON.stringify(rows))
	var rowsKey = Object.keys(rowsJSON[0])
	delete rowsKey[0] //fc_iso2
	delete rowsKey[4] //fc_iso2
	delete rowsKey[5] //tc_iso2
	delete rowsKey[8] //fa_iata
	delete rowsKey[9] //ta_iata
	var newRowsKey = rowsKey.filter(word => word)
	var newRowsKeyJSON = JSON.parse(JSON.stringify(newRowsKey))
	
	//console.log(newRowsKeyJSON)
	//console.log(rowsJSON)
	//console.log(rowsKeyJSON)
	
	return res.send(pug.renderFile('views/flight_search_result.pug', {rowsJSON: rowsJSON, pax: req.body.pax, rowsKeyJSON: newRowsKeyJSON}))
}

const getFlightSearchHandler = async (req, res) => {
	return res.redirect('/')
}

const postFlightPaxHandler = async (req, res) => {
	//console.log(req.body)
	if(req.session.userid){
		var rows = await query('SELECT email,fname,lname,gender,dob FROM users WHERE id=?',[req.session.userid])
		rowsJSON = JSON.parse(JSON.stringify(rows))
		return res.send(pug.renderFile('views/flight_pax.pug', {pax : req.body.pax, rowsJSON : rowsJSON}))
	}
	prevStageJSON = JSON.parse(JSON.stringify(req.body))
	//console.log(prevStageJSON)
	//return res.send(pug.renderFile('views/flight_pax.pug', {pax : req.body.pax, flt_id : req.body.flt_id}))
	return res.send(pug.renderFile('views/flight_pax.pug', {prev : prevStageJSON}))
}

const postFlightSeatHandler = async (req, res) => {
	prevJSON = JSON.parse(req.body.prev)
	delete req.body.prev
	req.body = Object.assign(prevJSON, req.body)
	var rows = await query('SELECT id,seat_num FROM seats WHERE flt_id=? AND available=true', [req.body.flt_id])
	rowsJSON = JSON.parse(JSON.stringify(rows))
	//console.log(req.body)
	prevStageJSON = JSON.parse(JSON.stringify(req.body))
	//console.log(prevStageJSON)
	//return res.send(pug.renderFile('views/flight_seat_select.pug', {pax : req.body.pax, flt_id : req.body.flt_id, seats : rowsJSON}))
	return res.send(pug.renderFile('views/flight_seat_select.pug', {prev : prevStageJSON, seats : rowsJSON}))
}


const postFlightConfirmHandler = async (req, res) => {
	prevJSON = JSON.parse(req.body.prev)
	delete req.body.prev
	console.log(prevJSON)
	//console.log(req.body)
	console.log(Math.random().toString(36).slice(2))
	for (let i = 0; i < prevJSON.pax; i++){
		let email = 'email_' + (i+1).toString()
		let fn = 'fn_' + (i+1).toString()
		let ln = 'ln_' + (i+1).toString()
		let gender = 'gender_' + (i+1).toString()
		let dob = 'dob_' + (i+1).toString()
		let seat = 'seat_' + (i+1).toString()
		try{
			//rows = await query('INSERT INTO customers VALUES (NULL,NULL,NULL,NULL,NULL,NULL,NULL)')
			//var rows = await query('INSERT INTO customers VALUES (NULL,NULL,?,?,?,?,?)', [prevJSON[email],prevJSON[fn],prevJSON[ln],prevJSON[gender],prevJSON[dob]]);
			var rows = await query('CALL sp_ins_customer_and_booking(NULL,?,?,?,?,?,?,?);', [prevJSON[email],prevJSON[fn],prevJSON[ln],prevJSON[gender],prevJSON[dob],prevJSON.flt_id,req.body[seat]])
		}
		catch(e){
			console.log(e);
			return res.status(500).send('Internal Server Error: ' + e.sqlMessage)
		}		
	}
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
		var rows = await query(`CALL sp_flights_insert(?,?,?,?,?,?,?,?,?,?,?);`, [req.body.flt_num, Number(req.body.airline), Number(req.body.aircraft), req.body.fm_airport, req.body.to_airport, req.body.fm_country, req.body.to_country, sqlDptDate, sqlArrDate, Number(req.body.price), req.body.status])
		//var rowsJSON = JSON.stringify(rows)
		//var rowsObj = JSON.parse(rowsJSON)
		//console.log(rowsJSON)
		return res.status(200).send('Flight updated')
		//console.log("sp_flights_insert rows: " + rowsJSON)
		//call sp_flights_insert('1111',2,2,2,2,210,210,'1111-11-11 11:11:11','1111-11-12 11:11:12', 1111, 'active', @ret); select @ret;
		//res.redirect('/admin/flight/add')
	}
	catch (e){
		console.log(e);
		return res.status(500).send("Internal Server Error: " + e.sqlMessage);
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

/*const getBooking = async (req, res) => {
	const fromcountrySQL = 'SELECT name FROM country WHERE name like ?'
	const tocountrySQL = 'SELECT name FROM country WHERE name like ?'
	const departdateSQL = 'SELECT depart_time FROM flights WHERE depart_time like ?'
	const arrivaldateSQL = 'SELECT arrival_time FROM flights where arrival_time like ?'
	const flightSQL = 'SELECT f.id , c.name , f.depart_time , f.arrival_time FROM flights f , country c WHERE FromCountry like ? AND ToCountry like ? AND DepartDate like ? AND ArriveDate like ? 
	AND c.id = f.src_country_id AND c.id = f.dst_country_id WHERE 
	let fromcountry = {};
	let tocountry = {};
	let departdate = {};
	let arrivaldate = {};
	try{
		fromcountry = await queryAsync(fromcountrySQL)
	await query(
	}
}*/

app.get('/', indexHandler)
app.post('/flight/search', urlencodedParser, postFlightSearchHandler)
app.get('/flight/search', getFlightSearchHandler)
//app.get('/flight/pax', getFlightPaxHandler)
app.post('/flight/pax', urlencodedParser, postFlightPaxHandler)
app.post('/flight/seat', urlencodedParser, postFlightSeatHandler)
app.post('/flight/confirm', urlencodedParser, postFlightConfirmHandler)
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