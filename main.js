const mysql = require('mysql')
const express = require('express')
const session = require('express-session')
const crypto = require('crypto')
const util = require('util')
const mysqlstore = require('express-mysql-session')(session);
const pug = require('pug')
const uuid = require("uuid")

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
	//console.log(req.session)
	var rows = await query('SELECT airport_name, airport_code FROM view_airports;')
	var rowsJSON = JSON.parse(JSON.stringify(rows))
	//console.log(rowsJSON)
	if(req.session.userid){
		return res.send(pug.renderFile('views/home.pug', {fn: req.session.name, rowsJSON: rowsJSON}))
	}
	res.send(pug.renderFile('views/home.pug', {rowsJSON: rowsJSON}))
}

const getLoginHandler = async (_req, res) => {
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

const getFlightSearchHandler = async (req, res) => {
	//console.log(req.query)
	let ts = Date.now() + (2 * 60 * 60 * 1000)

	let date_ob = new Date(ts)
	let date = ("0" + date_ob.getDate()).slice(-2)
	let month = ("0" + (date_ob.getMonth() + 1)).slice(-2)
	let year = date_ob.getFullYear()
	let hours = ("0" + (date_ob.getHours())).slice(-2)
	let minutes = ("0" + (date_ob.getMinutes())).slice(-2)
	let timeSearch = hours + ':' + minutes
	//console.log(timeSearch);
	let sqlDpt = req.query.dpt + ' ' + timeSearch
	let sqlArr = req.query.arr + ' ' + '23:59'
	//console.log(sqlDpt);

	let rows = await query(`CALL sp_select_flights_recurse(?,?,?,?,?)`, 
				[sqlDpt, sqlArr, req.query.src_airport, req.query.dst_airport, Number(req.query.pax)])

	// convert the concated fields into array
	for(let i = 0; i < rows[0].length; i++){
		rows[0][i]['dpt_arv'] = rows[0][i]['dpt_arv'].split("||")
		for(let j = 0; j < rows[0][i]['dpt_arv'].length; j++){
			rows[0][i]['dpt_arv'][j] = rows[0][i]['dpt_arv'][j].split(',')
		}
		rows[0][i]['path_ap_code'] = rows[0][i]['path_ap_code'].split("||")
		rows[0][i]['path_flt_id'] = rows[0][i]['path_flt_id'].split("||")
		rows[0][i]['path_ap_name'] = rows[0][i]['path_ap_name'].split("||")
		//console.log(rows[0][i]['dpt_arv'])
	}
	let src_airport_name = rows[0][0]['path_ap_name'][0]
	let dst_airport_name = rows[0][0]['path_ap_name'][rows[0][0]['path_ap_name'].length - 1]
	rows = JSON.parse(JSON.stringify(rows[0]))
	//console.log(rowsJSON)	
	return res.send(pug.renderFile('views/flight_search_result.pug', {rows: rows, pax: req.query.pax, src_airport_name: src_airport_name, dst_airport_name: dst_airport_name}))
}

const postFlightBookingPaxInfoHandler = async (req, res) => {
	//console.log(req.body)
	if(req.session.userid){
		var rows = await query('SELECT email,fname,lname,gender,dob FROM users WHERE id=?',[req.session.userid])
		return res.send(pug.renderFile('views/flight_booking_pax_info.pug', {pax : req.body.pax, rows : rows}))
	}
	req.body['flt_id'] = JSON.parse(req.body['flt_id'])
	//return res.send(pug.renderFile('views/flight_pax.pug', {pax : req.body.pax, flt_id : req.body.flt_id}))
	return res.send(pug.renderFile('views/flight_booking_pax_info.pug', {prev : req.body}))
}

const postFlightBookingSeatSelectHandler = async (req, res) => {
	let prevJSON = JSON.parse(req.body.prev)
	delete req.body.prev // delete the submitted JSON values from previous stage, then reassign them as JSON objects to the request body so that we can pass them to .pug as a whole
	req.body = Object.assign(prevJSON, req.body)
	//let rows = await query('SELECT id,seat_num FROM seats WHERE flt_id=? AND available=true', [req.body.flt_id])
	let seats = await query('SELECT flt_id, group_concat(seat_num) as seat_nums, group_concat(id) as seat_ids, count(id) as seat_count FROM seats WHERE flt_id IN (?) AND available=true GROUP BY flt_id', [req.body.flt_id])
	for(let i = 0; i < seats.length; i++){ // convert the seat_nums and seat_ids to array
		seats[i]['seat_nums'] = seats[i]['seat_nums'].split(',')
		seats[i]['seat_ids'] = seats[i]['seat_ids'].split(',')
	}
	seats = JSON.parse(JSON.stringify(seats))
	//console.log(seats)
	let flt_info = await query('SELECT depart,arrive,src_airport_code,dst_airport_code,src_airport_name,dst_airport_name FROM view_flights_informative WHERE flt_id in (?)', [req.body.flt_id])
	flt_info = JSON.parse(JSON.stringify(flt_info))
	//return res.send(pug.renderFile('views/flight_seat_select.pug', {pax : req.body.pax, flt_id : req.body.flt_id, seats : rowsJSON}))
	//console.log(req.body)
	return res.send(pug.renderFile('views/flight_booking_seat_select.pug', {prev : req.body, seats : seats, flt_info: flt_info, hops: flt_info.length}))
}


const postFlightBookingConfirmHandler = async (req, res) => {
	prevJSON = JSON.parse(req.body.prev)
	//console.log(prevJSON)
	//console.log(req.body)
	let seats_check = []
	let conflict = []
	let flt_info = await query('SELECT src_airport_code,dst_airport_code FROM view_flights_informative WHERE flt_id in (?)', [prevJSON['flt_id']])
	let pax = prevJSON['pax']
	flt_info = JSON.parse(JSON.stringify(flt_info))
	for(let i = 0; i < pax; i++){
		for(let j = 0; j < prevJSON['flt_id'].length; j++){
			let seat_form_id = ['seat',(i+1).toString(),prevJSON['flt_id'][j]].join('_')
			let seat_form_value = req.body[seat_form_id]
			let seat_db = [prevJSON['flt_id'][j],seat_form_value].join('_')
			//console.log(seat_db)
			if(seats_check.includes(seat_db)){
				let src_dst = [flt_info[j]['src_airport_code'],flt_info[j]['dst_airport_code']].join(' to ')
				conflict.push('Duplicate seats for passenger ' + Number(i+1) + ' on flight ' + src_dst)
				continue
			}
			seats_check.push(seat_db)
			//console.log(seats_check)
		}
	}
	//console.log(conflict.length)
	if(conflict.length > 0){
		let error = '<p>' + conflict.join('</p><p>')
		return res.status(500).send(error)
	}
	//console.log(seats_check)
	var ref_num = uuid.v4().substring(0,8)
	var email_for_retrieve = ''
	for (let i = 0; i < seats_check.length; i++){
		let pax_num = (i % pax)+1
		let email = ['email', pax_num.toString()].join('_')
		let fn = ['fn', pax_num.toString()].join('_')
		let ln = ['ln', pax_num.toString()].join('_')
		let gender = ['gender', pax_num.toString()].join('_')
		let dob = ['dob', pax_num.toString()].join('_')
		let flt_id = seats_check[i].split('_')[0]
		let seat_id = seats_check[i].split('_')[1]
		try{
			//console.log(ref_num)
			//rows = await query('INSERT INTO customers VALUES (NULL,NULL,NULL,NULL,NULL,NULL,NULL)')
			//var rows = await query('INSERT INTO customers VALUES (NULL,NULL,?,?,?,?,?)', [prevJSON[email],prevJSON[fn],prevJSON[ln],prevJSON[gender],prevJSON[dob]]);
			var rows = await query('CALL sp_ins_customer_and_booking(NULL,?,?,?,?,?,?,?,?);', [prevJSON[email],prevJSON[fn],prevJSON[ln],prevJSON[gender],prevJSON[dob],flt_id,seat_id,ref_num])
		}
		catch(e){
			console.log(e);
			return res.status(500).send('Internal Server Error: ' + e.sqlMessage)
		}		
	}
	let msg = 'Booking successful. Use reference number ' + ref_num + ' and registered email to check booking'
	return res.send(pug.renderFile('views/booking_success.pug', {msg: msg}))
	//rows = await query('')
}

const postBookingSearchHandler = async (req, res) => {
	//console.log(req.query)
	console.log(res.locals)
	let result
	let rows
	if(res.locals.booking_id){
		result = await query(`SELECT ref_num, email FROM view_bookings_informative WHERE booking_id = ?`,[res.locals.booking_id])
		result = JSON.parse(JSON.stringify(result[0]))
		rows = await query(`CALL sp_select_booking_by_ref_and_email(?,?)`,[result['ref_num'], result['email']])
	}
	else{
		rows = await query(`CALL sp_select_booking_by_ref_and_email(?,?)`,[req.body.ref_num, req.body.email])
	}
	var rowsJSON = JSON.parse(JSON.stringify(rows[0]))
	//console.log(rowsJSON)
	for(let i = 0; i < rowsJSON.length; i++){
		if(rowsJSON[i].booking_status == 'flt_cancelled'){
			
			rowsJSON[i].booking_status = "Cancelled by Flight Cancellation"
			continue
		}
		if(rowsJSON[i].booking_status == 'cust_cancelled'){
			rowsJSON[i].booking_status = "Cancelled by Passenger"
			continue
		}
		if(rowsJSON[i].booking_status == 'active'){
			rowsJSON[i].booking_status = "Active"
			continue
		}
	}	
	//console.log(rowsJSON)
	return res.send(pug.renderFile('views/booking_summary.pug', {rowsJSON: rowsJSON}))
}

const postBookingEditHandler = async (req, res, next) => {
	//console.log(req.body)
	let rows = await query(`UPDATE bookings SET seat_id = ? WHERE id = ?`,[Number(req.body.seat_id), Number(req.body.booking_id)])
	//console.log(rowsJSON)
	res.locals.booking_id = req.body.booking_id
	next()
	//return res.redirect('/booking/edit')
}

const getBookingEditHandler = async (req, res) => {
	let seats = await query(`SELECT id,seat_num FROM seats WHERE flt_id = (SELECT flt_id FROM bookings WHERE id = ?) and available=true; `,[req.query.booking_id]) 
	let curr_seat = await query(`SELECT seat_id, seat_num FROM view_bookings_informative WHERE booking_id = ?`, [req.query.booking_id])
	seats = JSON.parse(JSON.stringify(seats))
	curr_seat = JSON.parse(JSON.stringify(curr_seat[0]))
	//console.log(currSeatJSON)
	return res.send(pug.renderFile('views/booking_edit.pug', {curr_seat : curr_seat, seats: seats, booking_id: req.query.booking_id}))
}

const getBookingActionHandler = async (req, res) => {
	console.log(req.query)
	let param = `?booking_id=${req.query.booking_id}`
	if(req.query.edit_action){
		//console.log('edit action')
		let url = '/booking/edit' + param;
		return res.redirect(url)
	}
	if(req.query.cancel_action){
		let url = '/booking/cancel' + param;
		return res.redirect(307, url)
	}
}

const getBookingCancelHandler = async (req, res) => {
	//console.log(req.query)
	return res.send(pug.renderFile('views/booking_cancel_confirm.pug', {booking_id: req.query.booking_id}))
}

const postBookingCancelHandler = async (req, res, next) => {
	//console.log(req.body)
	try{
		var rows = await query('UPDATE bookings SET status=? WHERE id=?', ['cust_cancelled',req.body.booking_id])
	}
	catch(e){
		console.log(e);
		return res.status(500).send('Internal Server Error: ' + e.sqlMessage)
	}
	res.locals.booking_id = req.body.booking_id
	next()
}

const getAdminHomeHandler = async (_req, res) => {
	return res.send(pug.renderFile('views/admin_home.pug', {admin: "admin"}))
}

const getAdminFlightHandler = async (_req, res) => {
	var rows = await query(`SELECT * from view_flights_informative ORDER BY flt_id ASC;`)
	var rowsJSON = JSON.parse(JSON.stringify(rows))
	//console.log(rowsJSON)
	if(rowsJSON.length == 0){
		return res.send(pug.renderFile('views/admin_flight.pug'))
	}
	//var rowsKeyJSON = JSON.parse(JSON.stringify(rowsKey))
	//console.log(rowsJSON)
	//console.log(rowsKeyJSON)
	return res.send(pug.renderFile('views/admin_flight.pug', {rowsJSON: rowsJSON}))
}

const getAdminFlightAddHandler = async (_req, res) => {
	//var airlines = await query(`SELECT * FROM airlines`)
	var aircrafts = await query(`SELECT * FROM aircrafts`)
	var airports = await query(`SELECT * FROM airports ORDER BY country_iso2`)
	//var airlinesJSON = JSON.parse(JSON.stringify(airlines))
	var aircraftsJSON = JSON.parse(JSON.stringify(aircrafts))
	var airportsJSON = JSON.parse(JSON.stringify(airports))
	//console.log(countriesJSON)
	return res.send(pug.renderFile('views/admin_flight_add.pug', {aircrafts: aircraftsJSON, airports: airportsJSON}))
}

const postAdminFlightAddHandler = async (req, res) => {
	//console.log(req.body)
	var sqlDptDate = req.body.dpt_date + " " + req.body.dpt_time
	var sqlArrDate = req.body.arr_date + " " + req.body.arr_time
	try{
		var rows = await query(`CALL sp_flights_insert(?,?,?,?,?,?,?,?);`, [req.body.flt_num, Number(req.body.aircraft), req.body.fm_airport, req.body.to_airport, sqlDptDate, sqlArrDate, Number(req.body.price), req.body.status])
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
	//var airlinesJSON = JSON.parse(JSON.stringify(await query(`SELECT * from airlines`)))
	var aircraftsJSON = JSON.parse(JSON.stringify(await query(`SELECT * from aircrafts`)))
	var airportsJSON = JSON.parse(JSON.stringify(await query(`SELECT * from airports`)))
	var countriesJSON = JSON.parse(JSON.stringify(await query(`SELECT * from countries`)))
	//console.log(airportsJSON)
	//console.log(countriesJSON)
	var rowsJSON = [{}]
	try{
		let rows = await query(`SELECT * FROM view_flights_informative WHERE flt_id=?`, [req.query.flt_id])
		rowsJSON = JSON.parse(JSON.stringify(rows[0]))
	}
	catch (err){
		console.log(err.sqlMessage);
		return res.status(500).send(err.sqlMessage);
	}
	//console.log(rowsJSON)
	if(rowsJSON.length == 0){
		return res.status(500).send('No result returned');
	}
	rowsJSON.dpt_date = rowsJSON.depart.split(' ')[0]
	rowsJSON.arr_date = rowsJSON.arrive.split(' ')[0]
	rowsJSON.dpt_time = rowsJSON.depart.split(' ')[1]
	rowsJSON.arr_time = rowsJSON.arrive.split(' ')[1]
	//console.log(rowsJSON)
	return res.send(pug.renderFile('views/admin_flight_edit.pug', {aircrafts: aircraftsJSON, airports: airportsJSON, countries: countriesJSON, rowsJSON: rowsJSON}))
}

const postAdminFlightEditHandler = async (req, res) => {
	//console.log(req.body)
	var sqlDptDate = req.body.dpt_date + " " + req.body.dpt_time
	var sqlArrDate = req.body.arr_date + " " + req.body.arr_time
	try{
		await query(`CALL sp_update_flights(?,?,?,?,?,?,?,?,?)`, 
					[Number(req.body.flt_id), req.body.flt_num, Number(req.body.aircraft), req.body.fm_airport, req.body.to_airport, sqlDptDate, sqlArrDate, Number(req.body.price), req.body.status])
	}
	catch(err){
		return res.status(500).send(err.sqlMessage)
	}
	return res.redirect('/admin/flight')
}

const getAdminBookingHandler = async (_req, res) => {
	//console.log("getAdminBookingHandler")
	//var customersJSON = JSON.parse(JSON.stringify(await query(`SELECT b.id, b.ref_num, f.flt_num, c.fname, c.lname, b.status FROM bookings b, flights f, customers c WHERE b.id = c.id AND b.flt_id = f.id`)))
	var customersJSON = JSON.parse(JSON.stringify(await query(`SELECT cust_id, booking_id, ref_num, flt_num, fname, lname, booking_status FROM view_bookings_informative;`)))
	if(customersJSON.length == 0){
		return res.send(pug.renderFile('views/admin_booking.pug'))
	}

	return res.send(pug.renderFile('views/admin_booking.pug', {customers : customersJSON}))

}

const postAdminBookingHandler = async (req, res) => {
	console.log(req.body)
	try{
		await query (`DELETE FROM bookings WHERE ref_num=?`, [req.body.ref_num])
	}
	catch(err){
		return res.status(500).send(err.sqlMessage)
	}
	return res.redirect('/admin/booking')
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
app.get('/flight/search', urlencodedParser, getFlightSearchHandler)
//app.get('/flight/pax', getFlightPaxHandler)
app.post('/flight/booking/pax_information', urlencodedParser, postFlightBookingPaxInfoHandler)
app.post('/flight/booking/seat_selection', urlencodedParser, postFlightBookingSeatSelectHandler)
app.post('/flight/booking/confirm', urlencodedParser, postFlightBookingConfirmHandler)
app.post('/booking/search', urlencodedParser, postBookingSearchHandler)
app.get('/booking/action', urlencodedParser, getBookingActionHandler)
app.post('/booking/edit', urlencodedParser, postBookingEditHandler, postBookingSearchHandler)
app.get('/booking/edit', urlencodedParser, getBookingEditHandler)
app.get('/booking/cancel', urlencodedParser, getBookingCancelHandler)
app.post('/booking/cancel', urlencodedParser, postBookingCancelHandler, postBookingSearchHandler)
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
app.post('/admin/booking', urlencodedParser, postAdminBookingHandler)
app.get('/admin/flight/add', getAdminFlightAddHandler)
app.post('/admin/flight/add', urlencodedParser, postAdminFlightAddHandler)
app.get('/admin/flight/edit', urlencodedParser, getAdminFlightEditHandler)
app.post('/admin/flight/edit', urlencodedParser, postAdminFlightEditHandler)