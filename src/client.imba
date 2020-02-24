import {songs} from "./songs.imba"

let settings = {
	theme: 'light',
	font: {
		size: 24,
		family: "Sans",
		name: "Sans",
		line-height: 1.6
	}
}
let mobimenu = ''
let inzone = no
let onzone = no
let songs_menu_left = -300
let settings_menu_left = -300
let slide_deviation = 0
let fonts = [
	{
		name: "Vollkorn",
		code: "'Vollkorn', serif"
	},
	{
		name: "Roboto Slab",
		code: "'Roboto Slab', serif"
	},
	{
		name: "Montserrat",
		code: "'Montserrat', sans-serif"
	},
	{
		name: "M PLUS 1p",
		code: "'M PLUS 1p', sans-serif"
	},
	{
		name: "System UI",
		code: "system-ui"
	}
	{
		name: "Sans",
		code: "Sans, Sans-serif"
	},
	{
		name: "Monospace",
		code: "monospace"
	},
]


tag SongBook
	prop query default: ""
	prop current_song default: ""
	prop text default: ""
	prop show_fonts default: no

	def build
		if getCookie('theme')
			settings:theme = getCookie('theme')
			let html = document.querySelector('#html')
			html:dataset:theme = settings:theme
		else
			let html = document.querySelector('#html')
			html:dataset:theme = settings:theme
		if getCookie('song')
			getSong(getCookie('song'))
		if getCookie('font')
			settings:font:size = parseInt(getCookie('font'))
		if getCookie('font-family')
			settings:font:family = getCookie('font-family')
		if getCookie('font-name')
			settings:font:name = getCookie('font-name')
		if getCookie('line-height')
			settings:font:line-height = parseFloat(getCookie('line-height'))


	def getCookie c_name
		window:localStorage.getItem(c_name)

	def setCookie c_name, value
		window:localStorage.setItem(c_name, value)

	def onmousemove e
		if window:innerWidth > 600
			if e.x < 32
				songs_menu_left = 0
				mobimenu = 'show_songs'
			elif e.x > window:innerWidth - 32
				settings_menu_left = 0
				mobimenu = 'show_settings'
			elif 300 < e.x < window:innerWidth - 300
				songs_menu_left = -300
				settings_menu_left = -300
				mobimenu = ''

	def ontouchstart touch
		if touch.x < 32 || touch.x > window:innerWidth - 32
			inzone = true
		elif mobimenu
			onzone = true
		self

	def ontouchupdate touch
		if inzone
			if (songs_menu_left < 0 && touch.dx < 300) && mobimenu != 'show_settings'
				songs_menu_left = touch.dx - 300
			if (settings_menu_left < 0 && touch.dx > -300) && mobimenu != 'show_songs'
				settings_menu_left = - 300 - touch.dx
		else
			if mobimenu == 'show_songs' && touch.dx < 0
				songs_menu_left = touch.dx
			if mobimenu == 'show_settings' && touch.dx > 0
				settings_menu_left = - touch.dx
		if document.getSelection == '' && Math.abs(touch.dy) < 36 && !mobimenu
			if touch.dx < -64
				slide_deviation = Math.tanh(touch.dx) * 64
			elif touch.dx > 64
				slide_deviation = Math.tanh(touch.dx) * 64
		Imba.commit

	def ontouchend touch
		if inzone && mobimenu == ''
			if touch.dx > 64 && mobimenu != 'show_settings'
				songs_menu_left = 0
				mobimenu = 'show_songs'
			elif touch.dx < -64 && mobimenu != 'show_songs'
				settings_menu_left = 0
				mobimenu = 'show_settings'
			else
				settings_menu_left = -300
				songs_menu_left = -300
				mobimenu = ''
		elif mobimenu == 'show_songs'
			if touch.dx < -64
				songs_menu_left = -300
				mobimenu = ''
			else songs_menu_left = 0
		elif mobimenu == 'show_settings'
			if touch.dx > 64
				settings_menu_left = -300
				mobimenu = ''
			else settings_menu_left = 0
		elif document.getSelection == '' && Math.abs(touch.dy) < 36 && !mobimenu
			if touch.dx < -64
				slideSong(1)
			elif touch.dx > 64
				slideSong(-1)
		inzone = no
		onzone = no
		slide_deviation = 0
		Imba.commit
	
	def slideSong value
		let index_of_current_song = songs.indexOf(songs.find(do |song| return song:name == @current_song))
		if songs[index_of_current_song + value]
			@text = songs[index_of_current_song + value]:html
			@current_song = songs[index_of_current_song + value]:name

	def getSong songname
		let index_of_current_song = songs.indexOf(songs.find(do |song| return song:name == songname))
		if songs[index_of_current_song]
			@text = songs[index_of_current_song]:html
			@current_song = songs[index_of_current_song]:name
		setCookie('song', @current_song)

	def changeTheme theme
		let html = document.querySelector('#html')
		if theme == 'light'
			html:dataset:theme = 'light'
		else
			html:dataset:theme = 'dark'
		settings:theme = theme
		setCookie('theme', theme)

	def decreaseFontSize
		if settings:font:size > 16
			settings:font:size -= 2
			setCookie('font', settings:font:size)

	def increaseFontSize
		if settings:font:size < 64 && window:innerWidth > 480
			settings:font:size = settings:font:size + 2
			setCookie('font', settings:font:size)
		elif settings:font:size < 40
			settings:font:size = settings:font:size + 2
			setCookie('font', settings:font:size)

	def setFontFamily font
		settings:font:family = font:code
		settings:font:name = font:name
		setCookie('font-family', font:code)
		setCookie('font-name', font:name)

	def changeLineHeight increase
		if increase && settings:font:line-height < 2.6
			settings:font:line-height += 0.2
		elif settings:font:line-height > 1.2
			settings:font:line-height -= 0.2
		setCookie('line-height', settings:font:line-height)


	def render
		<self .hold_by_finger=(inzone || onzone)>
			<nav style="left: {songs_menu_left}px; box-shadow: 0 0 {(songs_menu_left + 300) / 12}px rgba(0, 0, 0, 0.3);">
				<input#search[@query] placeholder="Пошук">
				<.songs_list>
					for song in songs when song:name.toLowerCase().indexOf(query.toLowerCase()) >= 0
						<p.song_name :tap.prevent.getSong(song:name)> song:name
					if !(songs.filter(do |song| return song:name.toLowerCase().indexOf(query.toLowerCase()) >= 0):length)
						<p.song_name style="white-space: pre;"> "(ಠ╭╮ಠ)    ¯\\_(ツ)_/¯   ノ( ゜-゜ノ)"
					<.freespace>
			<main#main style="font-family: {settings:font:family}; font-size: {settings:font:size}px; line-height: {settings:font:line-height};transform: translateX({slide_deviation}px)">
				<h1> @current_song
				<text-as-html[{text: @text}]>
			<aside style="right: {settings_menu_left}px; box-shadow: 0 0 {(settings_menu_left + 300) / 12}px rgba(0, 0, 0, 0.3);">
				<.languageflex :tap.prevent=(do @show_fonts = !@show_fonts)>
					<button.change_language>
						settings:font:name
					<.languages .show_languages=@show_fonts>
						for font in fonts
							<button :tap.prevent.setFontFamily(font) css:font-family=font:code> font:name
				<.btnbox>
					<svg:svg.cbtn :tap.prevent.changeTheme("dark") style="padding: 8px;" xmlns="http://www.w3.org/2000/svg" enable-background="new 0 0 24 24" height="24" viewBox="0 0 24 24" width="24">
						<svg:title> "Нічна тема"
						<svg:g>
							<svg:rect fill="none" height="24" width="24">
						<svg:g>
							<svg:path d="M11.1,12.08C8.77,7.57,10.6,3.6,11.63,2.01C6.27,2.2,1.98,6.59,1.98,12c0,0.14,0.02,0.28,0.02,0.42 C2.62,12.15,3.29,12,4,12c1.66,0,3.18,0.83,4.1,2.15C9.77,14.63,11,16.17,11,18c0,1.52-0.87,2.83-2.12,3.51 c0.98,0.32,2.03,0.5,3.11,0.5c3.5,0,6.58-1.8,8.37-4.52C18,17.72,13.38,16.52,11.1,12.08z">
						<svg:path d="M7,16l-0.18,0C6.4,14.84,5.3,14,4,14c-1.66,0-3,1.34-3,3s1.34,3,3,3c0.62,0,2.49,0,3,0c1.1,0,2-0.9,2-2 C9,16.9,8.1,16,7,16z">
					<svg:svg.cbtn :tap.prevent.changeTheme("light") style="padding: 8px;" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20">
						<svg:title> "Дення тема"
						<svg:path d="M10 14a4 4 0 1 1 0-8 4 4 0 0 1 0 8zM9 1a1 1 0 1 1 2 0v2a1 1 0 1 1-2 0V1zm6.65 1.94a1 1 0 1 1 1.41 1.41l-1.4 1.4a1 1 0 1 1-1.41-1.41l1.4-1.4zM18.99 9a1 1 0 1 1 0 2h-1.98a1 1 0 1 1 0-2h1.98zm-1.93 6.65a1 1 0 1 1-1.41 1.41l-1.4-1.4a1 1 0 1 1 1.41-1.41l1.4 1.4zM11 18.99a1 1 0 1 1-2 0v-1.98a1 1 0 1 1 2 0v1.98zm-6.65-1.93a1 1 0 1 1-1.41-1.41l1.4-1.4a1 1 0 1 1 1.41 1.41l-1.4 1.4zM1.01 11a1 1 0 1 1 0-2h1.98a1 1 0 1 1 0 2H1.01zm1.93-6.65a1 1 0 1 1 1.41-1.41l1.4 1.4a1 1 0 1 1-1.41 1.41l-1.4-1.4z">
				<.btnbox>
					<a.cbtn style="padding: 12px; font-size: 20px;" :tap.prevent.decreaseFontSize title="Зменшити шрифт"> "B-"
					<a.cbtn style="padding: 8px; font-size: 24px;" :tap.prevent.increaseFontSize title="Збільшити шрифт"> "B+"
				<.btnbox>
					<svg:svg.cbtn :tap.prevent.changeLineHeight(no) xmlns="http://www.w3.org/2000/svg" width="38" height="14" viewBox="0 0 38 14" fill="context-fill" style="padding: calc(42px - 26px) 0;">
						<svg:title> "Зменшити висоту рядка"
						<svg:rect x="0" y="0" width="28" height="2">
						<svg:rect x="0" y="6" width="38" height="2">
						<svg:rect x="0" y="12" width="18" height="2">
					<svg:svg.cbtn :tap.prevent.changeLineHeight(yes) xmlns="http://www.w3.org/2000/svg" width="38" height="24" viewBox="0 0 38 24" fill="context-fill" style="padding: calc(42px - 32px) 0;">
						<svg:title> "Збільшити висоту рядка"
						<svg:rect x="0" y="0" width="28" height="2">
						<svg:rect x="0" y="11" width="38" height="2">
						<svg:rect x="0" y="22" width="18" height="2">
			<footer>
				<h1>
					"♪└|∵|┐♪└|∵|┘♪┌|∵|┘♪"
				<address>
					<p>
						"© "
						<time time:datetime="2020-02-24T12:38"> "2020"
						<a target="_blank" href="mailto:bpavlisinec@gmail.com"> " Павлишинець Богуслав "
						<a target="_blank" href="https://t.me/Boguslavv">
							"| Telegram"
							# <img src="/images/Telegram_logo.svg">




tag text-as-html < p
	prop thegiventext default: ""

	def mount
		schedule(events: yes)
		dom:innerHTML = @data:text
		@thegiventext = @data:text

	def tick
		if @data:text != @thegiventext
			dom:innerHTML = @data:text
			@thegiventext = @data:text
			render

	def render
		<self>

Imba.mount <SongBook>
