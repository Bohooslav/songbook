import {songs} from "./songs.imba"

songs.sort(do |a, b|
	return ('' + a:title).localeCompare(b:title))

let settings = {
	theme: 'dark',
	font: {
		size: 20,
		family: "Sans, sans-serif",
		name: "Sans",
		line-height: 1.6
	}
}
let inzone = no
let onzone = no
let songs_menu_left = -300
let settings_menu_left = -300
let show_history
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


document:onkeyup = do |e|
	var e = e || window:event
	if document.getElementById("search") != document:activeElement
		if e:code == "ArrowRight" && e:ctrlKey
			let songbook = document:getElementsByClassName("SongBook")
			songbook[0]:_tag.slideSong(1)
		elif e:code == "ArrowLeft" && e:ctrlKey
			let songbook = document:getElementsByClassName("SongBook")
			songbook[0]:_tag.slideSong(-1)


tag SongBook
	prop query default: ""
	prop current_song default: ""
	prop text default: ""
	prop thesong default: {}
	prop show_fonts default: no
	prop history default: []
	prop addBtn default: no
	prop deferredPrompt

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
		settings:font:size = parseInt(getCookie('font')) || settings:font:size
		settings:font:family = getCookie('font-family') || settings:font:family
		settings:font:name = getCookie('font-name') || settings:font:name
		settings:font:line-height = parseFloat(getCookie('line-height')) || settings:font:line-height

		window.addEventListener('beforeinstallprompt', do |e|
			e.preventDefault()
			deferredPrompt = e
			addBtn = yes
			Imba.commit()
		)


	def getCookie c_name
		window:localStorage.getItem(c_name)

	def setCookie c_name, value
		window:localStorage.setItem(c_name, value)

	def onmousemove e
		if window:innerWidth > 1024
			if e.x < 32
				songs_menu_left = 0
			elif e.x > window:innerWidth - 32
				settings_menu_left = 0
			elif 300 < e.x < window:innerWidth - 300
				songs_menu_left = -300
				settings_menu_left = -300

	def toggleSongsMenu
		if songs_menu_left
			songs_menu_left = 0
			settings_menu_left = -300
		else
			songs_menu_left = -300

	def toggleSettingsMenu
		if settings_menu_left
			settings_menu_left = 0
			songs_menu_left = -300
		else
			settings_menu_left = -300

	def ontouchstart touch
		if touch.x < 32 || touch.x > window:innerWidth - 32
			inzone = yes
		elif songs_menu_left > -300 || settings_menu_left > -300
			onzone = yes
		self

	def ontouchupdate touch
		if inzone
			if songs_menu_left < 0 && touch.dx > 0
				songs_menu_left = touch.dx - 300
			if settings_menu_left < 0 && touch.dx < 0
				settings_menu_left = - touch.dx - 300
		else
			if songs_menu_left > -300 && touch.dx < 0
				songs_menu_left = touch.dx
			if settings_menu_left > -300 && touch.dx > 0
				settings_menu_left = - touch.dx
		Imba.commit

	def ontouchend touch
		if songs_menu_left > -300
			if inzone
				touch.dx > 64 ? songs_menu_left = 0 : songs_menu_left = -300
			else
				touch.dx < -64 ? songs_menu_left = -300 : songs_menu_left = 0
		elif settings_menu_left > -300
			if inzone
				touch.dx < -64 ? settings_menu_left = 0 : settings_menu_left = -300
			else
				touch.dx > 64 ? settings_menu_left = -300 : settings_menu_left = 0
		inzone = no
		onzone = no
		Imba.commit

	def slideSong value
		let index_of_current_song = songs.indexOf(songs.find(do |song| return song:name == @thesong:name))
		if songs[index_of_current_song + value]
			@thesong = songs[index_of_current_song + value]
			setCookie('song', @thesong:title)
			saveHistory(@thesong:title)
			setTimeout(&, 200) do window.scroll(0,0)
			Imba.commit()

	def getSong songtitle
		let index_of_current_song = songs.indexOf(songs.find(do |song| return song:title == songtitle))
		if songs[index_of_current_song]
			@thesong = songs[index_of_current_song]
		else
			@thesong = {name: ''}
		setCookie('song', @thesong:title)
		setTimeout(&, 200) do window.scroll(0,0)
		saveHistory(@thesong:title)
		settings_menu_left = -300
		songs_menu_left = -300
		@query = ''
		show_history = no

	def saveHistory song_name
		if getCookie("history")
			@history = JSON.parse(getCookie("history"))
		if @history.find(do |element| return element:song == song_name)
			@history.splice(@history.indexOf(@history.find(do |element| return element:song == song_name)), 1)
		@history.push({"song": song_name})
		window:localStorage.setItem("history", JSON.stringify(@history))

	def turnHistory
		show_history = !show_history
		settings_menu_left = -300

	def clearHistory
		turnHistory
		@history = []
		window:localStorage.setItem("history", "[]")

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

	def featherSearch feather, haystack
		feather = feather.toLowerCase()
		haystack = haystack.toLowerCase()
		let haystackLength = haystack:length
		let featherLength = feather:length

		if featherLength > haystackLength
			return false

		if featherLength is haystackLength
			return feather is haystack

		let featherLetter = 0
		while featherLetter < featherLength
			let haystackLetter = 0
			let match = false
			var featherLetterCode = feather.charCodeAt(featherLetter++)

			while haystackLetter < haystackLength
				if haystack.charCodeAt(haystackLetter++) is featherLetterCode
					break match = true

			continue if match
			return false
		return true

	def filteredSongs
		let filtered = []
		for song in songs
			if featherSearch(@query, song:title)
				filtered.push(song)
		return filtered

	def boxShadow grade
		if settings:theme == 'light'
			return "box-shadow: 0 0 {(grade + 300) / 4}px #0001;"
		else return ''

	def install
		deferredPrompt.prompt()

	def render
		<self .padding=@thesong:name>
			<span#top tabindex="0">
			<nav style="left: {songs_menu_left}px; {boxShadow(songs_menu_left)} {songs_menu_left > - 300 && (inzone || onzone) ? 'transition: none;will-change: left;' : ''}">
				<h1 :tap.prevent.getSong('')> "СЛАВТЕ ГОСПОДА"
				<.songs_list>
					for song in filteredSongs()
						<p.song_name .active_song=song:title==@thesong:title :tap.prevent.getSong(song:title)> song:title
					if !filteredSongs:length
						<p.song_name style="white-space: pre;"> "(ಠ╭╮ಠ)    ¯\\_(ツ)_/¯   ノ( ゜-゜ノ)"
					<.freespace>
				<input#search[@query] aria-label="Пошук" placeholder="Пошук">
			if @thesong:name
				<main#main style="font-family: {settings:font:family}; font-size: {settings:font:size}px; line-height: {settings:font:line-height};">
					<h1> <header-as-html[{html: @thesong:name}]> 
					<text-as-html[@thesong]>
					<.arrows>
						<a.arrow :tap.prevent.slideSong(-1) title="Попередня">
							<svg:svg.arrow_prew xmlns="http://www.w3.org/2000/svg" width="8" height="5" viewBox="0 0 8 5">
								<svg:title> "Попередня"
								<svg:polygon points="4,3 1,0 0,1 4,5 8,1 7,0">
						<a.arrow :tap.prevent.slideSong(1) title="Наступна">
							<svg:svg.arrow_next xmlns="http://www.w3.org/2000/svg" width="8" height="5" viewBox="0 0 8 5">
								<svg:title> "Наступна"
								<svg:polygon points="4,3 1,0 0,1 4,5 8,1 7,0">

				<footer>
					<h1 style="font-size: 32px;">
						"♪└|∵|┐♪└|∵|┘♪┌|∵|┘♪"
					<address>
						"© "
						<time time:datetime="2020-02-24T12:38"> "2020 "
						<a target="_blank" href="https://t.me/yanch4i"> "Ян Кушілка"
						" | "
						<a target="_blank" href="https://t.me/Boguslavv"> "Богуслав Павлишинець"
			else
				<main.main>
					<#background>
					<#wrapper>
						<h1> "СЛАВТЕ", <br>, "ГОСПОДА"
						<button :tap.prevent.toggleSongsMenu()> "СПІВАТИ"
						<p> "БУШТИНО 2020"
			<aside style="right: {settings_menu_left}px; {boxShadow(settings_menu_left)}{settings_menu_left > - 300 && (inzone || onzone) ? 'transition: none;will-change: right;' : ''}">
				if addBtn
					<.aside_flex style="margin-top: auto;" :tap.prevent.install()>
						<svg:svg.helpsvg xmlns="http://www.w3.org/2000/svg" height="24" viewBox="0 0 24 24" width="24">
							<svg:title> "Встановити"
							<svg:path d="M19 9h-4V3H9v6H5l7 7 7-7zM5 18v2h14v-2H5z">
						"Встановити"
				<.aside_flex :tap.prevent.turnHistory()>
					<svg:svg.helpsvg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
						<svg:title> "Історія"
						<svg:path d="M13 3c-4.97 0-9 4.03-9 9H1l3.89 3.89.07.14L9 12H6c0-3.87 3.13-7 7-7s7 3.13 7 7-3.13 7-7 7c-1.93 0-3.68-.79-4.94-2.06l-1.42 1.42C8.27 19.99 10.51 21 13 21c4.97 0 9-4.03 9-9s-4.03-9-9-9zm-1 5v5l4.28 2.54.72-1.21-3.5-2.08V8H12z">
					"Історія"
				<.aside_flex :tap.prevent=(do @show_fonts = !@show_fonts)>
					<span.font_icon> "B"
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

			<svg:svg.navigation :tap.prevent.toggleSongsMenu() style="left: 0;" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16">
				<svg:title> "Пісні"
				<svg:path d="M3 5H7V6H3V5ZM3 8H7V7H3V8ZM3 10H7V9H3V10ZM14 5H10V6H14V5ZM14 7H10V8H14V7ZM14 9H10V10H14V9ZM16 3V12C16 12.55 15.55 13 15 13H9.5L8.5 14L7.5 13H2C1.45 13 1 12.55 1 12V3C1 2.45 1.45 2 2 2H7.5L8.5 3L9.5 2H15C15.55 2 16 2.45 16 3ZM8 3.5L7.5 3H2V12H8V3.5ZM15 3H9.5L9 3.5V12H15V3Z">
			<svg:svg.navigation :tap.prevent.toggleSettingsMenu() style="right: 0;" xmlns="http://www.w3.org/2000/svg" enable-background="new 0 0 24 24" height="24" viewBox="0 0 24 24" width="24">
				<svg:title> "Налаштування"
				<svg:g>
					<svg:path d="M0,0h24v24H0V0z" fill="none">
					<svg:path d="M19.14,12.94c0.04-0.3,0.06-0.61,0.06-0.94c0-0.32-0.02-0.64-0.07-0.94l2.03-1.58c0.18-0.14,0.23-0.41,0.12-0.61 l-1.92-3.32c-0.12-0.22-0.37-0.29-0.59-0.22l-2.39,0.96c-0.5-0.38-1.03-0.7-1.62-0.94L14.4,2.81c-0.04-0.24-0.24-0.41-0.48-0.41 h-3.84c-0.24,0-0.43,0.17-0.47,0.41L9.25,5.35C8.66,5.59,8.12,5.92,7.63,6.29L5.24,5.33c-0.22-0.08-0.47,0-0.59,0.22L2.74,8.87 C2.62,9.08,2.66,9.34,2.86,9.48l2.03,1.58C4.84,11.36,4.8,11.69,4.8,12s0.02,0.64,0.07,0.94l-2.03,1.58 c-0.18,0.14-0.23,0.41-0.12,0.61l1.92,3.32c0.12,0.22,0.37,0.29,0.59,0.22l2.39-0.96c0.5,0.38,1.03,0.7,1.62,0.94l0.36,2.54 c0.05,0.24,0.24,0.41,0.48,0.41h3.84c0.24,0,0.44-0.17,0.47-0.41l0.36-2.54c0.59-0.24,1.13-0.56,1.62-0.94l2.39,0.96 c0.22,0.08,0.47,0,0.59-0.22l1.92-3.32c0.12-0.22,0.07-0.47-0.12-0.61L19.14,12.94z M12,15.6c-1.98,0-3.6-1.62-3.6-3.6 s1.62-3.6,3.6-3.6s3.6,1.62,3.6,3.6S13.98,15.6,12,15.6z">

			<section.history .show_history=show_history>
				<.history_hat css:margin="0">
					<svg:svg.close_history :tap.prevent.turnHistory xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" tabindex="0">
							<svg:title> "Закрити"
							<svg:path d="M10 8.586L2.929 1.515 1.515 2.929 8.586 10l-7.071 7.071 1.414 1.414L10 11.414l7.071 7.071 1.414-1.414L11.414 10l7.071-7.071-1.414-1.414L10 8.586z">
					<h1 css:margin="0 0 0 8px"> "Історія"
					<svg:svg.close_history :tap.prevent.clearHistory xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" style="padding: 0; margin: 0 12px 0 16px; width: 32px;" alt="Видалити" css:margin-left="auto">
						<svg:title> "Видалити"
						<svg:path d="M15 16h4v2h-4v-2zm0-8h7v2h-7V8zm0 4h6v2h-6v-2zM3 20h10V8H3v12zM14 5h-3l-1-1H6L5 5H2v2h12V5z">
				<article.historylist>
					if @history:length
						for h in @history.slice().reverse
							if h:song
								<a.song_name style="padding: 12px 8px;" :tap.prevent.getSong(h:song)>
									h:song
					else
						<p css:padding="12px"> "Історія пуста"

tag text-as-html < p
	prop thegiventext default: ""

	def mount
		schedule(events: yes)
		dom:innerHTML = @data:html
		@thegiventext = @data:html

	def tick
		if @data:html != @thegiventext
			dom:innerHTML = @data:html
			@thegiventext = @data:html
			render

	def render
		<self>

tag header-as-html < span
	prop thegiventext default: ""

	def mount
		schedule(events: yes)
		dom:innerHTML = @data:html
		@thegiventext = @data:html

	def tick
		if @data:html != @thegiventext
			dom:innerHTML = @data:html
			@thegiventext = @data:html
			render

	def render
		<self>

Imba.mount <SongBook>
