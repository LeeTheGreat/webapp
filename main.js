const mysql = require('mysql')
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
});

const query = util.promisify(db.query).bind(db);
app.use(session({
	key: 'sessionid',
	secret: "airline",
	store: sessionStore,
	resave: true,
	saveUninitialized: false,
	httpOnly: true,
	cookie: { maxAge: 1000 * 60 * 60 }, // 1 hour
}))

app.use(express.static('static'))
app.use(cookieParser())

const authenticationMiddleware = async (req, res, next) => {
	if(req.session.profile){
		next()
	}
	else{
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

const refNumMiddleware = async (req, res, next) => {
	if(!req.session.authorized_ref_num || req.session.authorized_ref_num == ''){
		return res.redirect('/')
	}
	next()
}

const InternalServerError_500 = async (req, res) => {
	return res.status(500).send('500 Internal Server Error')
}

const indexHandler = async (req, res) => {
	try{
		var rows = await query(`SELECT REPLACE(airport_name,'International','Intl') as airport_name, airport_code, country, region FROM view_airports;`)
	
		if(req.session.profile){
			res.send(pug.renderFile('views/home.pug', {rows: rows, profile: JSON.parse(req.session.profile)}))
		}
		else{
			res.send(pug.renderFile('views/home.pug', {rows: rows}))
		}
	}
	catch(e){
		console.log(e)
		InternalServerError_500(req,res)
	}
}

const getLoginHandler = async (req, res) => {
	try{
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
			return res.redirect('/')
		}
		return res.send(pug.renderFile('views/register.pug'))
	}
	catch(e){
		console.log(e);
		InternalServerError_500(req,res)
	}
}

const postRegisterHandler = async (req, res) => {
	try{
		let { fn, pass, ln, gender, dob, email} = req.body
		const salt = await bcrypt.genSalt(10)
		pass = await bcrypt.hash(pass, salt)	
		let rows = await query(`CALL sp_ins_user(?, ?, ?, ?, ?, ?)`, [email, pass, fn, ln, gender, dob])
		let profile = {'email' : email, 'fname': fn, 'lname': ln, 'gender': gender, 'dob': dob}
		req.session.profile = JSON.stringify(profile)
		res.redirect("/")
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
		let rows = await query(`SELECT * FROM users WHERE email = ? AND role = 'user' AND password IS NOT NULL LIMIT 1`, [email])
		if(rows.length == 0){
			return res.status(401).send(pug.renderFile('views/login.pug', {msg: "Wrong username or password"}))	
		}
		rows = rows[0]
		const verified = bcrypt.compareSync(password, rows.password)
		if(!verified){
			return res.status(401).send(pug.renderFile('views/login.pug', {msg: "Wrong username or password"}))	
		}
		let profile = {'email' : rows.email, 'fname': rows.fname, 'lname': rows.lname, 'gender': gender, 'dob': dob}
		req.session.profile = JSON.parse(profile)
		return res.redirect("/")
	}
	catch(e){
		console.log(e)
		InternalServerError_500(req,res)
	}
}

const getProfileHandler = async (req, res) => {
	try{
		return res.send(pug.renderFile('views/profile.pug', {profile: JSON.parse(req.session.profile)}))
	}
	catch(e){
		console.log(e);
		InternalServerError_500(req,res)
	}
}

const postProfileHandler = async (req, res) => {
	try{
		const { title, fn, ln, gender, email, dob, pass} = req.body
		console.log(req.body)
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
	catch (e){
		console.log(e)
		InternalServerError_500(req,res)
	}
}


const getLogoutHandler = async (req, res) => {
	try{
		let admin = false;
		if(req.session.admin){
			admin = true;
		}
		req.session.destroy();
		if(admin){
			return res.redirect('/admin')
		}
		return res.redirect('/');
	}
	catch(e){
		console.log(e)
		InternalServerError_500(req,res)
	}
}

const getFlightSearchHandler = async (req, res) => {
	try{
		let ts = Date.now() + (2 * 60 * 60 * 1000)
		let date_ob = new Date(ts)
		let date = ("0" + date_ob.getDate()).slice(-2)
		let month = ("0" + (date_ob.getMonth() + 1)).slice(-2)
		let year = date_ob.getFullYear()
		let hours = ("0" + (date_ob.getHours())).slice(-2)
		let minutes = ("0" + (date_ob.getMinutes())).slice(-2)
		let timeSearch = hours + ':' + minutes
		let sqlDpt = req.query.dpt + ' ' + timeSearch
		let sqlArr = req.query.arr + ' ' + '23:59'
		let rows = await query(`CALL sp_select_flights_recurse(?,?,?,?,?)`, 
					[sqlDpt, sqlArr, req.query.src_airport, req.query.dst_airport, Number(req.query.pax)])

		// convert the concated fields into array
		if(rows[0].length == 0){
			return res.send(pug.renderFile('views/flight_search_result.pug', {msg: 'No flights available'}))	
		}
		for(let i = 0; i < rows[0].length; i++){
			rows[0][i]['dpt_arv'] = rows[0][i]['dpt_arv'].split("||")
			for(let j = 0; j < rows[0][i]['dpt_arv'].length; j++){
				rows[0][i]['dpt_arv'][j] = rows[0][i]['dpt_arv'][j].split(',')
			}
			rows[0][i]['path_ap_code'] = rows[0][i]['path_ap_code'].split("||")
			rows[0][i]['path_flt_id'] = rows[0][i]['path_flt_id'].split("||")
			rows[0][i]['path_ap_name'] = rows[0][i]['path_ap_name'].split("||")
		}
		
		let src_airport_name = rows[0][0]['path_ap_name'][0]
		let dst_airport_name = rows[0][0]['path_ap_name'][rows[0][0]['path_ap_name'].length - 1]
		rows = JSON.parse(JSON.stringify(rows[0]))
		res.cookie('booking_data', JSON.stringify({'pax': req.query.pax}), { maxAge: 1800000, httpOnly: true }) // 30 minutes
		//res.cookie('flt_data', JSON.stringify(rows[0]))
		//return res.send(pug.renderFile('views/flight_search_result.pug', {rows: rows, pax: req.query.pax, src_airport_name: src_airport_name, dst_airport_name: dst_airport_name}))
		return res.send(pug.renderFile('views/flight_search_result.pug', {rows: rows, src_airport_name: src_airport_name, dst_airport_name: dst_airport_name}))
	}
	catch(e){
		console.log(e)
		InternalServerError_500(req,res)
	}
}

const postFlightBookingPaxInfoHandler = async (req, res) => {
	try{
		if(req.cookies.booking_data == undefined){ // user skipped first part (search flight). A client-side validation, but not really an issue
			res.redirect('/')
		}
		if(req.session.userid){
			var rows = await query('SELECT email,fname,lname,gender,dob FROM users WHERE id=?',[req.session.userid])
			return res.send(pug.renderFile('views/flight_booking_pax_info.pug', {pax : req.body.pax, rows : rows}))
		}
		let booking_data = JSON.parse(req.cookies.booking_data)
		booking_data.flt_id = JSON.parse(req.body.flt_id)
		res.cookie('booking_data', JSON.stringify(booking_data), { maxAge: 1800000, httpOnly: true }) // 30 minutes
		return res.send(pug.renderFile('views/flight_booking_pax_info.pug', {pax: booking_data.pax}))
	}
	catch(e){
		console.log(e)
		InternalServerError_500(req,res)
	}
}

const postFlightBookingSeatSelectHandler = async (req, res) => {
	try{
		if(req.cookies.booking_data == undefined){ // user skipped first or second part (search flight, pax info). A client-side validation, but not really an issue as it's all client data
			res.redirect('/')
		}
		let booking_data = JSON.parse(req.cookies.booking_data)
		booking_data['pax_info'] = req.body
		res.cookie('booking_data', JSON.stringify(booking_data), { maxAge: 1800000, httpOnly: true })
		let seats = await query('SELECT flt_id, group_concat(seat_num) as seat_nums, count(seat_num) as seat_count FROM seats WHERE flt_id IN (?) AND available=true GROUP BY flt_id', [booking_data.flt_id])
		for(let i = 0; i < seats.length; i++){ // convert the seat_nums array
			seats[i]['seat_nums'] = seats[i]['seat_nums'].split(',')
		}
		// query again to make sure we are getting the latest data
		let flt_info = await query('SELECT flt_id,depart,arrive,src_airport_code,dst_airport_code,src_airport_name,dst_airport_name FROM view_flights_join WHERE flt_id in (?)', [booking_data.flt_id])
		return res.send(pug.renderFile('views/flight_booking_seat_select.pug', {pax : booking_data.pax, seats : seats, flt_info: flt_info, hops: flt_info.length}))
	}
	catch(e){
		console.log(e);
		InternalServerError_500(req,res)
	}
}


const postFlightBookingConfirmHandler = async (req, res) => {
	try{
		let booking_data = JSON.parse(req.cookies.booking_data)
		let seats_check = []
		let conflict = []
		// query again to make sure we are getting the latest data
		let flt_info = await query('SELECT src_airport_name, src_airport_code, dst_airport_name, dst_airport_code FROM view_flights_join WHERE flt_id in (?)', [booking_data.flt_id])
		let pax = booking_data.pax
		for(let i = 0; i < pax; i++){
			for(let j = 0; j < booking_data.flt_id.length; j++){
				let seat_form_num = ['seat',(i+1).toString(),booking_data['flt_id'][j]].join('_')
				let seat_form_value = req.body[seat_form_num]
				let seat_db = [booking_data['flt_id'][j],seat_form_value].join('_')
				if(seats_check.includes(seat_db)){
					let src_dst = [flt_info[j]['src_airport_code'],flt_info[j]['dst_airport_code']].join(' to ')
					conflict.push('Duplicate seats ' + seat_form_value + ' for passenger ' + Number(i+1) + ' on flight ' + src_dst)
					continue
				}
				seats_check.push(seat_db)
			}
		}
		if(conflict.length > 0){
			let error = '<p>' + conflict.join('</p><p>')
			return res.status(500).send(error)
		}
		let ref_num = ''
		let ref_num_all = []
		let pax_info = booking_data.pax_info
		for (let i = 0; i < seats_check.length; i++){
			// here, we form the dictionary key according to the pax_info in the cookie
			let pax_num = (i % pax)+1
			let email = ['email', pax_num.toString()].join('_')
			let fn = ['fn', pax_num.toString()].join('_')
			let ln = ['ln', pax_num.toString()].join('_')
			let gender = ['gender', pax_num.toString()].join('_')
			let dob = ['dob', pax_num.toString()].join('_')
			let flt_id = seats_check[i].split('_')[0]
			let seat_num = seats_check[i].split('_')[1]
			// for multi flight, we use the pax_num to help us determine if we're adding seats for a new flt_id
			// whenever pax_num cycles back to 1, we're adding another flt_id. So, reset ref_num back to blank
			if(pax_num == 1){ 
				ref_num = '';
			}
			if(ref_num == ''){ // for the first user, the ref_num will be blank as we generate it using MySQL
				let rows = await query('CALL sp_ins_user_and_booking(?,?,?,?,?,?,?,?);', [pax_info[email],pax_info[fn],pax_info[ln],pax_info[gender],pax_info[dob],flt_id,seat_num,''])
				let rowsJSON = JSON.parse(JSON.stringify(rows[0]))
				ref_num = rowsJSON[0].ref_num_uuid
				ref_num_all.push(ref_num)
			}
			else{ // for subsequent users, the ref_num would be set. So, we use it so that all bookings will have same ref_num
				let rows = await query('CALL sp_ins_user_and_booking(?,?,?,?,?,?,?,?);', [pax_info[email],pax_info[fn],pax_info[ln],pax_info[gender],pax_info[dob],flt_id,seat_num,ref_num])
			}
		}
		var msg = []
		for (let i = 0; i < ref_num_all.length; i++){
			let src_msg = flt_info[i]['src_airport_name'] + ' (' + flt_info[i]['src_airport_code'] + ')'
			let dst_msg = flt_info[i]['dst_airport_name'] + ' (' + flt_info[i]['dst_airport_code'] + ')'
			msg[i] = 'Booking successful. Use reference number ' + ref_num_all[i] + ' and registered email to check booking for flight ' + src_msg + ' >>> ' + dst_msg
		}
		delete req.session.booking_data
		return res.send(pug.renderFile('views/booking_success.pug', {msgs: msg}))
	}
	catch(e){
		console.log(e);
		InternalServerError_500(req,res)
	}
}

const postBookingSearchHandler = async (req, res, next) => {
	let rows
	req.session.authorized_ref_num = ''
	try{
		rows = await query(`CALL sp_verify_refnum_email(?,?)`,[req.body.ref_num, req.body.email])
		rows = rows[0]
		if(rows.length > 0){
			req.session.authorized_ref_num = rows[0].ref_num
		}
		next()
	}
	catch(e){
		console.log(e);
		InternalServerError_500(req,res)
	}
}

const getBookingSearchHandler = async (req, res) => {
	try{
		let rows = []
		if(req.session.authorized_ref_num){ // we don't submit GET query for booking search as it reveals the info on the URL. So, we check if the user has successfully verified him/herself via cookie
			rows = await query(`SELECT * FROM view_bookings_join WHERE ref_num = ?`,[req.session.authorized_ref_num])
		}
		for(let i = 0; i < rows.length; i++){
			if(rows[i].flt_status == 'flt_cancelled'){
				rows[i].booking_status = "Flight Cancelled"
			}
			else if(rows[i].booking_status == 'active'){
				rows[i].booking_status = "Active"
			}
		}
		return res.send(pug.renderFile('views/booking_summary.pug', {rows: rows}))
	}
	catch(e){
		console.log(e);
		InternalServerError_500(req,res)
	}
}

const postBookingEditHandler = async (req, res, next) => {
	try{
		let rows = await query(`UPDATE bookings SET seat_num = ? WHERE id = ?`,[req.body.seat_num, Number(req.body.booking_id)])
		return res.redirect('/booking/search')
	}
	catch(e){
		console.log(e);
		InternalServerError_500(req,res)
	}
}

const getBookingEditHandler = async (req, res) => {
	try{
		let all_seats = await query(`SELECT flt_id,seat_num FROM seats WHERE flt_id ? and available=true; `,[req.query.booking_id]) 
		let curr_seat = await query(`SELECT seat_num FROM view_bookings_join WHERE booking_id = ?`, [req.query.booking_id])
		all_seats = JSON.parse(JSON.stringify(all_seats))
		curr_seat = JSON.parse(JSON.stringify(curr_seat[0]))
		return res.send(pug.renderFile('views/booking_edit.pug', {curr_seat : curr_seat, all_seats: all_seats, booking_id: req.query.booking_id}))
	}
	catch(e){
		console.log(e);
		InternalServerError_500(req,res)
	}
}

const getBookingActionHandler = async (req, res) => {
	try{
		let param = `?booking_id=${req.query.booking_id}`
		if(req.query.edit_action){
			//console.log('edit action')
			let url = '/booking/edit' + param;
			return res.redirect(url)
		}
		if(req.query.cancel_action){
			let url = '/booking/cancel' + param;
			return res.redirect(url)
		}
	}
	catch(e){
		console.log(e);
		InternalServerError_500(req,res)
	}
}

const getBookingCancelHandler = async (req, res) => {
	try{
		return res.send(pug.renderFile('views/booking_cancel_confirm.pug', {booking_id: req.query.booking_id, ref_no: req.query.refno}))
	}
	catch(e){
		console.log(e);
		InternalServerError_500(req,res)
	}
}

const postBookingCancelHandler = async (req, res, next) => {
	try{
		var rows = await query('DELETE FROM bookings WHERE id=?', [req.body.booking_id])
		return res.redirect('/booking/search')
	}
	catch(e){
		console.log(e);
		InternalServerError_500(req,res)
	}	
}

const getAdminLoginHandler = async (req, res) => {
	try{
		return res.send(pug.renderFile('views/admin/admin_login.pug'))
	}
	catch(e){
		console.log(e);
		InternalServerError_500(req,res)
	}	
}

const postAdminLoginHandler = async(req, res) =>{
	try{
		let { username, password } = req.body
		if(!username || !password){
			return res.send(pug.renderFile('/login'))
		}
		let rows = await query(`SELECT * FROM users WHERE email = ? AND role = 'admin'`, [username, password])
		if(rows.length == 0){
			return res.status(401).send(pug.renderFile('views/admin/admin_login.pug', {msg: "Wrong username or password"}))	
		}
		rows = rows[0]
		const verified = bcrypt.compareSync(password, rows.password)
		if(!verified){
			return res.status(401).send(pug.renderFile('views/admin/admin_login.pug', {msg: "Wrong username or password"}))	
		}
		let profile = {'email' : rows.email, 'fname': rows.fname, 'lname': rows.lname, 'gender': rows.gender, 'dob': rows.dob}
		req.session.profile = JSON.stringify(profile)
		req.session.admin = 'admin';
		return res.redirect("/admin")
	}
	catch(e){
		console.log(e);
		InternalServerError_500(req,res)
	}	
}

const getAdminHomeHandler = async (req, res) => {
	try{
		return res.send(pug.renderFile('views/admin/admin_home.pug', {profile: JSON.parse(req.session.profile)}))
	}
	catch(e){
		console.log(e);
		InternalServerError_500(req,res)
	}
}

const getAdminFlightHandler = async (req, res) => {
	try{
		var rows = await query(`SELECT * from view_flights_join ORDER BY flt_id ASC;`)
		if(rows.length == 0){
			return res.send(pug.renderFile('views/admin/admin_flight.pug'))
		}
		return res.send(pug.renderFile('views/admin/admin_flight.pug', {rows: rows, profile: req.session.profile}))
	}
	catch(e){
		console.log(e)
		InternalServerError_500(req,res)
	}
}

const getAdminFlightAddHandler = async (req, res) => {
	try{
		var aircrafts = await query(`SELECT * FROM aircrafts`)
		var airports = await query(`SELECT * FROM airports ORDER BY country_iso2`)
		return res.send(pug.renderFile('views/admin/admin_flight_add.pug', {aircrafts: aircrafts, airports: airports}))
	}
	catch(e){
		console.log(e)
		return InternalServerError_500(req,res)
	}
}

const postAdminFlightAddHandler = async (req, res) => {
	try{
		var sqlDptDate = req.body.dpt_date + " " + req.body.dpt_time
		var sqlArrDate = req.body.arr_date + " " + req.body.arr_time
		var rows = await query(`CALL sp_flights_insert(?,?,?,?,?,?,?,?);`, [req.body.flt_num, Number(req.body.aircraft), req.body.fm_airport, req.body.to_airport, sqlDptDate, sqlArrDate, Number(req.body.price), req.body.status])
		return res.status(200).send('Flight updated')
	}
	catch (e){
		console.log(e);
		InternalServerError_500(req,res)
	}		
}

const getAdminFlightEditHandler = async (req, res) => {
	try{
		let aircrafts = await query(`SELECT * from aircrafts`)
		let airports = await query(`SELECT * from airports`)
		let countries = await query(`SELECT * from countries`)
		let rows
		rows = await query(`SELECT * FROM view_flights_join WHERE flt_id=?`, [req.query.flt_id])
		rows = rows[0]
		if(rows.length == 0){
			return res.status(500).send('No result returned');
		}
		rows.dpt_date = rows.depart.split(' ')[0]
		rows.arr_date = rows.arrive.split(' ')[0]
		rows.dpt_time = rows.depart.split(' ')[1]
		rows.arr_time = rows.arrive.split(' ')[1]
		return res.send(pug.renderFile('views/admin/admin_flight_edit.pug', {aircrafts: aircrafts, airports: airports, countries: countries, rows: rows}))
	}
	catch (err){
		console.log(e);
		InternalServerError_500(req,res)
	}
}

const postAdminFlightEditHandler = async (req, res) => {	
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

const getAdminBookingHandler = async (req, res) => {
	try{
		let users = await query(`SELECT booking_id, ref_num, flt_id, flt_num, seat_num, email, fname, lname, booking_status FROM view_bookings_join;`)
		return res.send(pug.renderFile('views/admin/admin_booking.pug', {users : users, profile: req.session.profile}))
	}
	catch(e){
		console.log(e);
		InternalServerError_500(req,res)
	}

}

const getAdminBookingEditHandler = async (req, res) => {
	try{
		let {flt_id, booking_id} = req.query
		let all_seats = await query(`SELECT seat_num FROM seats WHERE flt_id = ? and available=true; `,[flt_id]) 
		let curr_seat = await query(`SELECT seat_num FROM view_bookings_join WHERE booking_id = ?`, [booking_id])
		let rows = await query (`SELECT * FROM view_bookings_join WHERE booking_id = ?`,[booking_id])
		curr_seat = curr_seat[0]
		rows = rows[0]
		return res.send(pug.renderFile('views/admin/admin_booking_edit.pug', {rows: rows, all_seats: all_seats, curr_seat: curr_seat}))
	}
	catch(e){
		console.log(e)
		InternalServerError_500(req,res)
	}
}

const postAdminBookingEditHandler = async (req, res, next) => {
	try{
		let {email, old_email, seat_num, booking_id} = req.body
		if(email != old_email){
			let rows = await query (`UPDATE users SET email = ? WHERE email = ?`, [email, old_email])
		}
		let rows = await query (`UPDATE bookings SET seat_num = ? WHERE id = ?`, [seat_num, booking_id])
		next()
	}
	catch(e){
		console.log(e)
		InternalServerError_500(req,res)
	}
}

const getAdminBookingDeleteHandler = async (req, res, next) => {
	try{
		let {booking_id} = req.query
		let rows = await query (`SELECT * FROM view_bookings_join WHERE booking_id = ?`,[booking_id])
		rows = rows[0]
		return res.send(pug.renderFile('views/admin/admin_booking_delete.pug', {rows: rows}))
	}
	catch(e){
		console.log(e)
		InternalServerError_500(req,res)
	}
}

const postAdminBookingDeleteHandler = async (req, res, next) => {
	try{
		let {booking_id} = req.body
		let rows = await query (`DELETE FROM bookings WHERE id = ?`, [booking_id])
		next()
	}
	catch(e){
		console.log(e)
		InternalServerError_500(req,res)
	}
}

const getAdminStatisticsHandler = async (req, res) => {
	console.log('test')
	try{
		let top_10_dst = await query (`SELECT COUNT(booking_id) AS Bookings, dst_country_name AS Destination FROM view_bookings_join GROUP BY dst_country_name ORDER BY Bookings DESC LIMIT 10;`)
		let bookings_per_season = await query (`SELECT COUNT(b.id) AS Bookings, FLOOR((MONTH(b.purchase_datetime) % 12) / 3) AS Season FROM bookings b GROUP BY season;`)
		let top_rev_dst_per_year = await query (`SELECT SUM(price) AS Revenue, dst_country_name AS Destination, YEAR(purchase_datetime) AS Year FROM view_bookings_join vbj1 GROUP BY Year, Destination HAVING SUM(price) >= ALL (SELECT sum(vbj2.price) FROM view_bookings_join vbj2 WHERE Year = YEAR(vbj2.purchase_datetime) GROUP BY YEAR(vbj2.purchase_datetime), vbj2.dst_country_name);`)
		let rev_season_per_year = await query (`SELECT COUNT(booking_id) AS Bookings, SUM(price) AS Revenue, YEAR(purchase_datetime) AS Year, FLOOR((MONTH(depart) % 12) / 3) AS Season FROM view_bookings_join GROUP BY YEAR(purchase_datetime), Season ORDER BY Year;`)
		return res.send(pug.renderFile('views/admin/admin_statistics.pug', {top_10_dst: top_10_dst, bookings_per_season: bookings_per_season, top_rev_dst_per_year: top_rev_dst_per_year, rev_season_per_year: rev_season_per_year}))
	}
	catch(e){
		console.log(e)
		InternalServerError_500(req,res)
	}
}

app.get('/', indexHandler)
app.get('/flight/search', urlencodedParser, getFlightSearchHandler)
app.post('/flight/booking/pax_information', urlencodedParser, postFlightBookingPaxInfoHandler)
app.post('/flight/booking/seat_selection', urlencodedParser, postFlightBookingSeatSelectHandler)
app.post('/flight/booking/confirm', urlencodedParser, postFlightBookingConfirmHandler)
app.get('/booking/search', urlencodedParser, getBookingSearchHandler)
app.post('/booking/search', urlencodedParser, postBookingSearchHandler, getBookingSearchHandler)
app.get('/booking/action', refNumMiddleware, urlencodedParser, getBookingActionHandler)
app.post('/booking/edit', refNumMiddleware, urlencodedParser, postBookingEditHandler, postBookingSearchHandler)
app.get('/booking/edit', refNumMiddleware, urlencodedParser, getBookingEditHandler)
app.get('/booking/cancel', refNumMiddleware, urlencodedParser, getBookingCancelHandler)
app.post('/booking/cancel', refNumMiddleware, urlencodedParser, postBookingCancelHandler, postBookingSearchHandler)
app.get('/login', getLoginHandler)
app.post('/login', urlencodedParser, postLoginHandler)
app.get('/register', getRegisterHandler)
app.post('/register', urlencodedParser, postRegisterHandler)
app.get('/profile', authenticationMiddleware, getProfileHandler)
app.post('/profile', authenticationMiddleware, urlencodedParser, postProfileHandler)
app.get('/logout', getLogoutHandler)
app.get('/admin/login', getAdminLoginHandler)
app.post('/admin/login', urlencodedParser, postAdminLoginHandler)
app.get('/admin', adminAuthenticationMiddleware, getAdminHomeHandler)
app.get('/admin/flight', adminAuthenticationMiddleware, getAdminFlightHandler)
app.get('/admin/booking', adminAuthenticationMiddleware, getAdminBookingHandler)
app.get('/admin/booking/edit', adminAuthenticationMiddleware, getAdminBookingEditHandler)
app.post('/admin/booking/edit', adminAuthenticationMiddleware, urlencodedParser, postAdminBookingEditHandler, getAdminBookingHandler)
app.get('/admin/booking/delete', adminAuthenticationMiddleware, getAdminBookingDeleteHandler)
app.post('/admin/booking/delete', adminAuthenticationMiddleware, urlencodedParser, postAdminBookingDeleteHandler, getAdminBookingHandler)
app.get('/admin/flight/add', adminAuthenticationMiddleware, getAdminFlightAddHandler)
app.post('/admin/flight/add', adminAuthenticationMiddleware, urlencodedParser, postAdminFlightAddHandler)
app.get('/admin/flight/edit', adminAuthenticationMiddleware, urlencodedParser, getAdminFlightEditHandler)
app.post('/admin/flight/edit', adminAuthenticationMiddleware, urlencodedParser, postAdminFlightEditHandler)
app.get('/admin/statistics', adminAuthenticationMiddleware, getAdminStatisticsHandler)