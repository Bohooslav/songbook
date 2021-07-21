import './global_styles'
import './song'
import {songs} from './songs'

# Sort songs by alphabet
songs.sort(do |a, b|
	return ('' + a.name).localeCompare(b.name))

# Parse songs choirds
for song, index in songs
	songs[index].transposition = 0
	for line in song.lines
		if line.chords
			# Then parse the chords line and separate spaces from chords
			let chords = []
			let chord = ''
			let whitespace = ''
			for character in line.chords
				if /[0-9A-Za-z#]/.test(character)
					chord += character
					if whitespace
						chords.push whitespace
						whitespace = ''
				else
					if chord
						chords.push chord
						chord = ''
					whitespace += character
			if chord
				chords.push chord
			if whitespace
				chords.push whitespace

			line.chords = chords
			

const agent = window.navigator.userAgent;
const isWebkit = (agent.indexOf("AppleWebKit") > 0);
const isIPad = (agent.indexOf("iPad") > 0);
const isIOS = (agent.indexOf("iPhone") > 0 || agent.indexOf("iPod") > 0)
const isAndroid = (agent.indexOf("Android")  > 0)
const isNewBlackBerry = (agent.indexOf("AppleWebKit") > 0 && agent.indexOf("BlackBerry") > 0)
const isWebOS = (agent.indexOf("webOS") > 0);
const isWindowsMobile = (agent.indexOf("IEMobile") > 0)
const isSmallScreen = (screen.width < 767 || (isAndroid && screen.width < 1000))
const isUnknownMobile = (isWebkit && isSmallScreen)
const isMobile = (isIOS || isAndroid || isNewBlackBerry || isWebOS || isWindowsMobile || isUnknownMobile)
const isTablet = (isIPad || (isMobile && !isSmallScreen))

let MOBILE_PLATFORM = no

if isMobile && isSmallScreen && document.cookie.indexOf( "mobileFullSiteClicked=") < 0
	MOBILE_PLATFORM = yes

let menu_icons_transform = 0
let songbook_menu_left = -300
let settings_menu_left = -300

let inzone = no
let onzone = no



window.onscroll = do |e|
	let testsize = 2 - ((window.scrollY * 4) / window.innerHeight)

	const last_known_scroll_position = window.scrollY
	setTimeout(&, 100) do
		if window.scrollY < last_known_scroll_position || not window.scrollY
			menu_icons_transform = 0
		elif window.scrollY > last_known_scroll_position
			if window.innerWidth > 1024
				menu_icons_transform = -100
			else
				menu_icons_transform = 100

		imba.commit()


const scale = [
	'A'
	'B'
	'C'
	'D'
	'E'
	'F'
	'G'
]


tag app
	settings = {
			show_chords: yes
			show_text: yes
			theme: 'dark'
			word_wrap: no
			font: {
				size: 18,
				family: "Sans, sans-serif",
				name: "Sans",
				line-height: 1.6
			}
		}
	current_song_index = -1
	transpositions = []
	search_query = ''
	filtered_songs = []
	deferredPrompt = null
	available_for_install = no



	def setup
		if getCookie('theme')
			settings.theme = getCookie('theme')
			changeTheme(settings.theme)
		else
			document.documentElement.dataset.light = settings.theme
			document.documentElement.dataset.theme = settings.theme

		settings.show_chords = !(getCookie('show_chords') == 'false')
		settings.word_wrap = !(getCookie('word_wrap') == 'false')
		settings.font.size = parseInt(getCookie('font')) || settings.font.size
		settings.font.family = getCookie('font-family') || settings.font.family
		# settings.font.name = getCookie('font-name') || settings.font.name
		settings.font.line-height = parseFloat(getCookie('line-height')) || settings.font.line-height

		# If the user used this app before 
		# then show his the last viewed song
		let baked_current_song_name = getCookie('current_song_name')
		if baked_current_song_name
			current_song_index = songIndex(baked_current_song_name)
			# if current_song_index < 0
			# 	current_song_index = 0


		# If the user was transposing any of the songs
		# get the transposition data from the localStorage
		# and transpose the songs again.
		transpositions = JSON.parse(getCookie("transpositions")) || []

		for song in songs
			let was_the_song_transposed = transpositions.find(do |el| return el.song == song.name)

			if was_the_song_transposed
				transpose(song, was_the_song_transposed.transposition)
			else
				song.transposition = 0


		filtered_songs = songs

		window.addEventListener('beforeinstallprompt', do |e|
			e.preventDefault()
			deferredPrompt = e
			available_for_install = yes
			imba.commit!
		)

		document.oncopy = cleancopy



	def transpose song, transposition
		if -13 < song.transposition + transposition < 13
			const song_index = songIndex(song.name)
			songs[song_index].transposition += transposition
			const direction = transposition > 0

			for j in [0...Math.abs(transposition)]
				for line in songs[song_index].lines
					if line.chords
						for chord, i in line.chords
							if /[A-H]/.test(chord[0])
								# Parse the chord
								# We will change only the tone and sign
								# All the other parts are stable across all the keys.
								let tone = chord[0]
								let sign = chord[1] == '#'
								let leftover = '' # Stable parts

								if sign
									leftover = chord.slice(2, chord.length)
								else
									leftover = chord.slice(1, chord.length)

								# If the transposition goes up
								if direction
									if tone == 'G' && sign
										tone = 'A'
									elif tone == 'E' && not sign
										tone = 'F'
									elif (tone == 'B' || tone == 'H') && not sign
										tone = 'C'
									else
										if sign
											tone = scale[scale.indexOf(tone) + 1]
										else
											tone += '#'
								else
									if tone == 'A' && not sign
										tone = 'G#'
									elif tone == 'F' && not sign
										tone = 'E'
									elif tone == 'C' && not sign
										tone = 'H'
									elif tone == 'H' && not sign
										tone = 'A#'
									else
										if sign
											tone = tone[0]
										else
											tone = scale[scale.indexOf(tone) - 1] + '#'

								line.chords[i] = tone + leftover
		
			let is_already_transposed = transpositions.find(do |el| return el.song == song.name)
			if is_already_transposed
				transpositions[transpositions.indexOf(is_already_transposed)].transposition = song.transposition
			else
				transpositions.push({
					song: song.name
					transposition: song.transposition
				})
			setCookie('transpositions', JSON.stringify(transpositions))


	def goToSong song
		current_song_index = songIndex(song.name)
		setCookie('current_song_name', song.name)
		clearSpace!


	def songIndex name
		return songs.indexOf(songs.find(do |el| return el.name == name))


	# I call items from localStorage cookies :P
	def getCookie c_name
		window.localStorage.getItem(c_name)

	def setCookie c_name, value
		window.localStorage.setItem(c_name, value)

	def clearSpace
		settings_menu_left = -300
		songbook_menu_left = -300



	def toggleSongbookMenu parallel
		if songbook_menu_left
			if !settings_menu_left && MOBILE_PLATFORM
				clearSpace!
				return
			songbook_menu_left = 0
			settings_menu_left = -300
		else
			songbook_menu_left = -300

	def toggleSettingsMenu
		if settings_menu_left
			if !songbook_menu_left && MOBILE_PLATFORM
				clearSpace!
				return
			settings_menu_left = 0
			songbook_menu_left = -300
		else
			settings_menu_left = -300

	def boxShadow grade
		if settings.theme == 'light'
			return "box-shadow: 0 0 {(grade + 300) / 5}px rgba(0, 0, 0, 0.067);"
		else
			return ''

	def mousemove e
		if not MOBILE_PLATFORM
			if e.x < 32
				songbook_menu_left = 0
			elif e.x > window.innerWidth - 32
				settings_menu_left = 0
			elif 300 < e.x < window.innerWidth - 300
				songbook_menu_left = -300
				settings_menu_left = -300



	def showHideChords
		if settings.show_text
			settings.show_chords = not settings.show_chords
			setCookie('show_chords', settings.show_chords)

	def showHideText
		if settings.show_chords
			settings.show_text = not settings.show_text
			setCookie('show_text', settings.show_text)


	def wordWrap
		settings.word_wrap = not settings.word_wrap
		setCookie('word_wrap', settings.word_wrap)

	def changeTheme theme
		document.documentElement.dataset.pukaka = 'yes'

		if settings.sepia
			toggleSepia!

		settings.theme = theme
		document.documentElement.dataset.theme = settings.accent + settings.theme
		document.documentElement.dataset.light = settings.theme
		setCookie('theme', theme)

		setTimeout(&, 75) do
			imba.commit!.then do document.documentElement.dataset.pukaka = 'no'

	def decreaseFontSize
		if settings.font.size > 12
			settings.font.size -= 2
			setCookie('font', settings.font.size)

	def increaseFontSize
		if settings.font.size < 64 && window.innerWidth > 480
			settings.font.size = settings.font.size + 2
		elif settings.font.size < 40
			settings.font.size = settings.font.size + 2
		setCookie('font', settings.font.size)

	def changeLineHeight increase
		if increase && settings.font.line-height < 2.6
			settings.font.line-height += 0.2
		elif settings.font.line-height > 1.2
			settings.font.line-height -= 0.2
		setCookie('line-height', settings.font.line-height)



	def slidestart touch
		slidetouch = touch.changedTouches[0]

		if slidetouch.clientX < 16 or slidetouch.clientX > window.innerWidth - 16
			inzone = yes

	def slideend touch
		touch = touch.changedTouches[0]

		touch.dy = slidetouch.clientY - touch.clientY
		touch.dx = slidetouch.clientX - touch.clientX

		if songbook_menu_left > -300
			if inzone
				touch.dx < -64 ? songbook_menu_left = 0 : songbook_menu_left = -300
			else
				touch.dx > 64 ? songbook_menu_left = -300 : songbook_menu_left = 0
		elif settings_menu_left > -300
			if inzone
				touch.dx > 64 ? settings_menu_left = 0 : settings_menu_left = -300
			else
				touch.dx < -64 ? settings_menu_left = -300 : settings_menu_left = 0
		elif document.getSelection().isCollapsed && Math.abs(touch.dy) < 36 && !search.search_div && !show_history && !choosenid.length
			if window.innerWidth > 600
				if touch.dx < -32
					settingsp.display && touch.x > window.innerWidth / 2 ? prevChapter("true") : prevChapter()
				elif touch.dx > 32
					settingsp.display && touch.x > window.innerWidth / 2 ? nextChapter("true") : nextChapter()
			else
				if touch.dx < -32
					settingsp.display && touch.y > window.innerHeight / 2 ? prevChapter("true") : prevChapter()
				elif touch.dx > 32
					settingsp.display && touch.y > window.innerHeight / 2 ? nextChapter("true") : nextChapter()

		slidetouch = null
		inzone = no



	def closingdrawer e
		e.dx = e.changedTouches[0].clientX - slidetouch.clientX

		if songbook_menu_left > -300 && e.dx < 0
			songbook_menu_left = e.dx
		if settings_menu_left > -300 && e.dx > 0
			settings_menu_left = - e.dx
		onzone = yes

	def openingdrawer e
		if inzone
			e.dx = e.changedTouches[0].clientX - slidetouch.clientX

			if songbook_menu_left < 0 && e.dx > 0
				songbook_menu_left = e.dx - 300
			if settings_menu_left < 0 && e.dx < 0
				settings_menu_left = - e.dx - 300

	def closedrawersend touch
		touch.dx = touch.changedTouches[0].clientX - slidetouch.clientX

		if songbook_menu_left > -300
			touch.dx < -64 ? songbook_menu_left = -300 : songbook_menu_left = 0
		elif settings_menu_left > -300
			touch.dx > 64 ? settings_menu_left = -300 : settings_menu_left = 0
		onzone = no


	def install
		data.deferredPrompt.prompt()

	def stiingsMenuRight
		if MOBILE_PLATFORM
			return settings_menu_left
		else
			if settings_menu_left
				return settings_menu_left
			else
				return settings_menu_left + 12


	def cleanString s
		if s
			return s.toLowerCase().replace(/[^0-9a-zа-яіїєёґ\s]+/g, "")
		else return ''

	// Compute a search relevance score for an item.
	def scoreSearch item
		let thename = cleanString(item)
		search = cleanString(search_query)
		let score = 0
		let p = 0 # Position within the `item`
		# Look through each character of the search string, stopping at the end(s)...

		for i in [0 ... search.length]
			# Figure out if the current letter is found in the rest of the `item`.
			const index = thename.indexOf(search[i], p)
			# If not, stop here.
			if index < 0
				break
			#  If it is, add to the score...
			score++
			#  ... and skip the position within `item` forward.
			p = index

		return score


	def filterSongs
		if search_query.length
			filtered_songs = []
			for song in songs
				const score = scoreSearch(song.name)
				if score > 0
					filtered_songs.push({
						name: song.name
						score: score
					})
		else
			filtered_songs = songs

		filtered_songs = filtered_songs.sort(do |a, b| b.score - a.score)
		$search.focus!


	def cleanSearchField
		search_query = ''
		filtered_songs = songs
		$search.focus!

	def toggleSongsMenu
		if songbook_menu_left
			songbook_menu_left = 0
			settings_menu_left = -300
		else
			songbook_menu_left = -300




	def cleancopy event
		const selection = document.getSelection()
		# Fix selection of single node
		if selection.focusNode == selection.anchorNode
			return
		
		let result = ''
		let range

		# If multiple range. The user pressed Ctrl + A ???
		if selection.rangeCount > 1
			range = new Range()

			const song-node = document.getElementsByTagName('song-tag')[0]
			const last_child = song-node.lastChild.lastChild.lastChild.lastChild

			range.setStart(song-node.firstChild.firstChild, 0)
			range.setEnd(last_child, last_child.textContent.length)
		else
			range = selection.getRangeAt(0)



		# Iterate from startContainer to endContainer of the range
		let cnode = range.startContainer
		result += range.startContainer.textContent.substring(range.startOffset)

		# This incrementor will prevent infinity loop
		let incrementer = 1
		while incrementer < 1000
			incrementer++
			if cnode.nextSibling
				cnode = cnode.nextSibling
			else
				if cnode.parentNode.nextSibling
					cnode = cnode.parentNode.nextSibling
				else
					if cnode.parentNode.parentNode.nextSibling
						cnode = cnode.parentNode.parentNode.nextSibling
					else
						if cnode.parentNode.parentNode.parentNode.nextSibling
							cnode = cnode.parentNode.parentNode.parentNode.nextSibling
						else
							cnode = cnode.parentNode.parentNode.parentNode.parentNode.nextSibling

			# Safety check
			if cnode == null
				console.log 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAa'
				break
			# If user selected header text -- then we need to prevent jumping from pre node to nav
			if cnode.nodeName == "PRE"
				cnode = cnode.firstChild

			if cnode.contains(range.endContainer) && cnode.nodeName != 'PRE'
				result += '\n' + cnode.textContent.substring(0, range.endOffset)
				break

			# console.log cnode.textContent, cnode
			if cnode.textContent == ''
				result += '\n'
			else
				if cnode.nodeName != 'SPAN'
					result += '\n' + cnode.textContent
				else
					result += cnode.textContent

		event.clipboardData.setData('text/plain', result)
		event.preventDefault()




	def songbookIconTransform huh
		if (window.innerWidth > 1024) or huh
			return 300 + songbook_menu_left
		else
			return 0


	def settingsIconTransform huh
		if (window.innerWidth > 1024) or huh
			return -(300 + settings_menu_left)
		else
			return 0


	<self>
		<nav @touchstart=slidestart @touchend=closedrawersend @touchcancel=closedrawersend @touchmove=closingdrawer style="left: {songbook_menu_left}px; {boxShadow(songbook_menu_left)}{(onzone || inzone) ? 'transition:none;' : ''}">
			<h1[fs:20px pb:16px ta:center cursor:pointer c@hover:$accent-hover-color] @click=(current_song_index = -1)> 'СЛАВТЕ ГОСПОДА'
			<ul [h:calc(100% - 100px) ofy:auto]>
				for song, i in filtered_songs
					<li role='button' @click=goToSong(song)> song.name
				unless filtered_songs.length
					<pre[ff:inherit ta:center]> '(ಠ╭╮ಠ)    ¯\\_(ツ)_/¯   ノ( ゜-゜ノ)'
				<[h:128px]>
			<[d:flex]>
				<input$search aria-label='Пошук' placeholder='Пошук' bind=search_query @keyup=filterSongs>
				<button [
					bg:$background-color fs:2em c@hover:firebrick size:59px
					bd:none cursor:pointer
				] @click=cleanSearchField>
					<span[transform:rotate(45deg) d:inline-block o:0.7 @hover:1]> '+'


		if current_song_index < 0
			<main.full-screen [us:none]>
				<.full-screen[
					bgi: url('/images/green-leaves-plants.jpeg')
					bgp: 50% 50%
					bgr: no-repeat
					bgs: cover
					filter: contrast(150%) grayscale(60%)
				]>
				<.full-screen [d:flex fld:column ta:center bgc:#0006]>
					<h1 [c:white fs:3em m:auto auto 6vh]>
						'СЛАВТЕ'
						<br>
						'ГОСПОДА'

					<button [
						border:2px solid #fee
						bg:transparent
						fs:24px
						c:white
						m:0 auto auto
						p:4px 24px
						cursor:pointer
						transform@hover: scale(1.1)
					] @click=toggleSongsMenu> "СПІВАТИ"
					<p[margin:0 auto 16px color: #c2834e]> "БУШТИНО 2020"
		else
			<main[p:64px {settings.show_chords ? '24px' : '4vw'} 128px fs:{settings.font.size}px 16vh max-width:100% ofx:auto] @mousemove=mousemove>
				<song-tag song=songs[current_song_index] settings=settings>


			<div.aside_arrows[transform:translateX({songbookIconTransform(yes)}px)] @click=toggleSongsMenu>
				<svg .arrow_next=!songbookIconTransform(yes) .arrow_prev=songbookIconTransform(yes) [fill:$accent-color] width="16" height="10" viewBox="0 0 8 5">
					<title> 'Пісник'
					<polygon points="4,3 1,0 0,1 4,5 8,1 7,0">

			<div.aside_arrows[r:0 transform:translateX({settingsIconTransform(yes)}px)] @click=toggleSettingsMenu>
				<svg .arrow_next=settingsIconTransform(yes) .arrow_prev=!settingsIconTransform(yes) [fill:$accent-color] width="16" height="10" viewBox="0 0 8 5">
					<title> "Налаштування"
					<polygon points="4,3 1,0 0,1 4,5 8,1 7,0">

		unless current_song_index < 0
			<aside @touchstart=slidestart @touchend=closedrawersend @touchcancel=closedrawersend @touchmove=closingdrawer style="right:{stiingsMenuRight!}px;{boxShadow(settings_menu_left)}{(onzone || inzone) ? 'transition:none;' : ''}">
				<[m:auto]>
				if available_for_install
					<button.btnbox[d:flex ai:center font:inherit c:inherit @hover:$accent-hover-color bg:transparent bd:none fill:$text-color @hover:$accent-hover-color cursor:pointer] @click=install>
						<svg[size:32px fill:inherit mr:12px] xmlns="http://www.w3.org/2000/svg" height="24" viewBox="0 0 24 24" width="24">
							<title> "Встановити"
							<path d="M19 9h-4V3H9v6H5l7 7 7-7zM5 18v2h14v-2H5z">
						"Встановити"
				<p>
					'Транспозиція: '
					if songs[current_song_index].transposition > 0
						'+'
					songs[current_song_index].transposition

				<.btnbox>
					<button.cbtn @click.transpose(songs[current_song_index], -1) title="Збільшити тпанспозицію">
						<svg width="16" height="10" viewBox="0 0 8 5">
							<title> "Збільшити тпанспозицію"
							<polygon points="4,3 1,0 0,1 4,5 8,1 7,0">
					<button.cbtn @click.transpose(songs[current_song_index], 1) title="Зменшити тпанспозицію">
						<svg xmlns="http://www.w3.org/2000/svg" [transform:rotate(180deg)] width="16" height="10" viewBox="0 0 8 5">
							<title> "Зменшити тпанспозицію"
							<polygon points="4,3 1,0 0,1 4,5 8,1 7,0">

				<.btnbox>
					<svg.cbtn[p:8px] @click=changeTheme('dark') xmlns="http://www.w3.org/2000/svg" enable-background="new 0 0 24 24" viewBox="0 0 24 24" >
						<title> 'Нічна тема'
						<path d="M11.1,12.08C8.77,7.57,10.6,3.6,11.63,2.01C6.27,2.2,1.98,6.59,1.98,12c0,0.14,0.02,0.28,0.02,0.42 C2.62,12.15,3.29,12,4,12c1.66,0,3.18,0.83,4.1,2.15C9.77,14.63,11,16.17,11,18c0,1.52-0.87,2.83-2.12,3.51 c0.98,0.32,2.03,0.5,3.11,0.5c3.5,0,6.58-1.8,8.37-4.52C18,17.72,13.38,16.52,11.1,12.08z">
						<path d="M7,16l-0.18,0C6.4,14.84,5.3,14,4,14c-1.66,0-3,1.34-3,3s1.34,3,3,3c0.62,0,2.49,0,3,0c1.1,0,2-0.9,2-2 C9,16.9,8.1,16,7,16z">
					<svg.cbtn [p:8px] @click=changeTheme('light') xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20">
						<title> 'Денна тема'
						<path d="M10 14a4 4 0 1 1 0-8 4 4 0 0 1 0 8zM9 1a1 1 0 1 1 2 0v2a1 1 0 1 1-2 0V1zm6.65 1.94a1 1 0 1 1 1.41 1.41l-1.4 1.4a1 1 0 1 1-1.41-1.41l1.4-1.4zM18.99 9a1 1 0 1 1 0 2h-1.98a1 1 0 1 1 0-2h1.98zm-1.93 6.65a1 1 0 1 1-1.41 1.41l-1.4-1.4a1 1 0 1 1 1.41-1.41l1.4 1.4zM11 18.99a1 1 0 1 1-2 0v-1.98a1 1 0 1 1 2 0v1.98zm-6.65-1.93a1 1 0 1 1-1.41-1.41l1.4-1.4a1 1 0 1 1 1.41 1.41l-1.4 1.4zM1.01 11a1 1 0 1 1 0-2h1.98a1 1 0 1 1 0 2H1.01zm1.93-6.65a1 1 0 1 1 1.41-1.41l1.4 1.4a1 1 0 1 1-1.41 1.41l-1.4-1.4z">
				<.btnbox>
					<svg.cbtn @click.changeLineHeight(no) xmlns="http://www.w3.org/2000/svg" viewBox="0 0 38 14" fill="context-fill" [padding: 16px 0]>
						<title> 'Зменшити висоту рядка'
						<rect x="0" y="0" width="28" height="2">
						<rect x="0" y="6" width="38" height="2">
						<rect x="0" y="12" width="18" height="2">
					<svg.cbtn @click.changeLineHeight(yes) xmlns="http://www.w3.org/2000/svg" viewBox="0 0 38 24" fill="context-fill" [padding: 10px 0]>
						<title> 'Збільшити висоту рядка'
						<rect x="0" y="0" width="28" height="2">
						<rect x="0" y="11" width="38" height="2">
						<rect x="0" y="22" width="18" height="2">
				<.btnbox>
					<button.cbtn [padding: 12px font-size: 20px] @click=decreaseFontSize title="Зменшити шрифт"> "B-"
					<button.cbtn [padding: 8px font-size: 24px] @click=increaseFontSize title="Збільшити шрифт"> "B+"

				<.flexy-item @click=showHideChords .activated-checkbox=settings.show_chords>
					'Показати акорди'
					<p.checkbox> <span>
				<.flexy-item @click=showHideText .activated-checkbox=settings.show_text>
					'Показати текст'
					<p.checkbox> <span>			
				<.flexy-item @click=wordWrap .activated-checkbox=settings.word_wrap>
					'Перенос тексту на новий рядок'
					<p.checkbox> <span>

				<footer[ta:center mt:32px]>
					<p[fs:20px]>
						"♪└|∵|┐♪└|∵|┘♪┌|∵|┘♪"
					<address[fs:12px mt:16px c:gray]>
						"© "
						<time time.datetime="2020-02-24T12:38"> "2021 "
						<a target="_blank" rel="noreferrer" href="https://t.me/Boguslavv"> "Богуслав Павлишинець"
						" · "
						<a target="_blank" rel="noreferrer" href="https://t.me/yanch4i"> "Ян Кушілка"
						" · "
						<a target="_blank" rel="noreferrer" href="https://t.me/Tymkoo"> "Віталій Тимко"


		unless current_song_index < 0
			<section id="navrow" [t:0px @lt-lg:auto b:auto @lt-lg:0]>
				<[l:0 transform: translateY({menu_icons_transform}%)] @click=toggleSongbookMenu>
					<svg viewBox="0 0 16 16">
						<title> 'Пісник'
						<path d="M3 5H7V6H3V5ZM3 8H7V7H3V8ZM3 10H7V9H3V10ZM14 5H10V6H14V5ZM14 7H10V8H14V7ZM14 9H10V10H14V9ZM16 3V12C16 12.55 15.55 13 15 13H9.5L8.5 14L7.5 13H2C1.45 13 1 12.55 1 12V3C1 2.45 1.45 2 2 2H7.5L8.5 3L9.5 2H15C15.55 2 16 2.45 16 3ZM8 3.5L7.5 3H2V12H8V3.5ZM15 3H9.5L9 3.5V12H15V3Z">
					<p> 'Пісник'
				<[r:0 transform: translateY({menu_icons_transform}%)] @click=toggleSettingsMenu>
					<svg enable-background="new 0 0 24 24" height="24" viewBox="0 0 24 24" width="24">
						<title> "Налаштування"
						<g>#
							<path d="M19.14,12.94c0.04-0.3,0.06-0.61,0.06-0.94c0-0.32-0.02-0.64-0.07-0.94l2.03-1.58c0.18-0.14,0.23-0.41,0.12-0.61 l-1.92-3.32c-0.12-0.22-0.37-0.29-0.59-0.22l-2.39,0.96c-0.5-0.38-1.03-0.7-1.62-0.94L14.4,2.81c-0.04-0.24-0.24-0.41-0.48-0.41 h-3.84c-0.24,0-0.43,0.17-0.47,0.41L9.25,5.35C8.66,5.59,8.12,5.92,7.63,6.29L5.24,5.33c-0.22-0.08-0.47,0-0.59,0.22L2.74,8.87 C2.62,9.08,2.66,9.34,2.86,9.48l2.03,1.58C4.84,11.36,4.8,11.69,4.8,12s0.02,0.64,0.07,0.94l-2.03,1.58 c-0.18,0.14-0.23,0.41-0.12,0.61l1.92,3.32c0.12,0.22,0.37,0.29,0.59,0.22l2.39-0.96c0.5,0.38,1.03,0.7,1.62,0.94l0.36,2.54 c0.05,0.24,0.24,0.41,0.48,0.41h3.84c0.24,0,0.44-0.17,0.47-0.41l0.36-2.54c0.59-0.24,1.13-0.56,1.62-0.94l2.39,0.96 c0.22,0.08,0.47,0,0.59-0.22l1.92-3.32c0.12-0.22,0.07-0.47-0.12-0.61L19.14,12.94z M12,15.6c-1.98,0-3.6-1.62-3.6-3.6 s1.62-3.6,3.6-3.6s3.6,1.62,3.6,3.6S13.98,15.6,12,15.6z">
					<p> "Налаштування"

	css
		.arrow_next
			transform: rotate(-90deg)

		.arrow_prev
			transform: rotate(90deg)

		.aside_arrows
			w:2vw w:min(32px, max(16px, 2vw)) h:100% t:0 pos:fixed
			bg@hover:#8881 o:0 @hover:1 d:flex ai:center jc:center cursor:pointer
			zi:2

		#navrow
			position:fixed
			right:0
			left:0
			display: flex
			justify-content: space-between
			height: 0
			z-index: 2
			cursor: pointer
			us:none

		#navrow > div 
			padding: 3vw
			width: calc(32px + 6vw)
			height: calc(32px + 6vw)
			c@hover: $accent-hover-color
			width@lt-lg: 50%
			bottom@lt-lg: 0
			padding@lt-lg: 4px
			height@lt-lg: 54px
			position@lt-lg: absolute
			background-color@lt-lg: $background-color
			border-top@lt-lg: 1px solid $btn-bg
			display@lt-lg: flex
			flex-direction: column
			justify-content: center
			align-items: center

		#navrow svg 
			width: 32px
			height: 32px
			min-height: 32px
			fill: $text-color
			opacity@lt-lg: 0.75 @hover: 1

		#navrow > div@hover > svg 
			fill: $accent-hover-color

		#navrow p
			m:0
			display: none @lt-lg: inline-block
			padding: 0 8px
			opacity: 0.75
			font-size: 12px


		aside
			border-left: 1px solid $btn-bg
			padding: 32px 12px
			overflow-y: auto
			-webkit-overflow-scrolling: touch
			d:flex
			fld:column
			jc:end

		nav 
			border-right: 1px solid $btn-bg
			padding: 32px 0 0
			ofy:auto

		nav li
			p: 8px
			c@hover: $accent-hover-color
			cursor:pointer

		$search
			w:calc(100% - 59px)
			bg:$background-color
			fs:1.2em
			p:16px
			pr:0
			c:inherit
			bd:none


		nav, aside 
			position: fixed
			top: 0
			bottom: 0
			us:none
			width: 300px
			touch-action: pan-y
			z-index: 1000
			background-color: $background-color

		.flexy-item
			margin: 12px 0
			height: 38px
			cursor: pointer
			display: flex
			align-items: center
			opacity: 0.5
			
		.activated-checkbox
			o:1

		.checkbox
			width: 50px
			min-width: 50px
			height: 30px
			border: 2px solid $text-color
			border-radius: 40px
			margin-left: auto

		.checkbox span
			display: block
			size: 28px
			background: $text-color
			border-radius: 14px

		.activated-checkbox span
			transform: translateX(20px)


		.btnbox
			height: 46px
			margin: 16px 0
			
		.cbtn
			cursor: pointer
			width: 50%
			height: 100%
			fill: $text-color @hover: $accent-hover-color
			color: $text-color @hover: $accent-hover-color
			bgc:transparent @hover: $btn-bg-hover @active: $btn-bg
			display: inline-block
			text-align: center
			rd: 8px
			transform@active: translateY(4px)
			bd:none

		.full-screen
			pos:fixed r:0 l:0 t:0 b:0	
		
		a
			td:none
			c:gray @hover:$accent-hover-color


imba.mount <app>