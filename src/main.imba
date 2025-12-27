import './global_styles.imba'
import './state'
import './ui'

import ChevronRight from 'lucide-static/icons/chevron-right.svg'
import ChevronLeft from 'lucide-static/icons/chevron-left.svg'
import BookOpenText from 'lucide-static/icons/book-open-text.svg'
import SlidersHorizontal from 'lucide-static/icons/sliders-horizontal.svg'

import './service?serviceworker'

const hasTouchEvents = 'ontouchstart' in window || navigator.maxTouchPoints > 0;

let menu_icons_transform = 0


window.onscroll = do |e|
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


tag app
	initialTouch = null
	inTouchZone = no
	inClosingTouchZone = no

	def setup
		document.oncopy = cleancopy

	def interpolate value, max
		# result should be between 0 and max
		Math.min(Math.max(value, 0), max)

	def boxShadow grade\number
		const abs = grade + 300
		return "0 0 0 {interpolate(abs, 1)}px var(--btn-bg-hover), 0 {interpolate(abs,1)}px {interpolate(abs, 6)}px var(--btn-bg-hover), 0 {interpolate(abs,3)}px {interpolate(abs, 36)}px var(--btn-bg-hover), 0 9px {interpolate(abs, 128)}px -{interpolate(abs, 64)}px var(--btn-bg-hover)"


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


	def slidestart touch
		unless touch.changedTouches.length
			return
		initialTouch = touch.changedTouches[0]
		if initialTouch.clientX < 16 or initialTouch.clientX > window.innerWidth - 16
			inTouchZone = yes

	def slideend touch
		unless initialTouch
			return
		touch = touch.changedTouches[0]

		touch.dy = initialTouch.clientY - touch.clientY
		touch.dx = initialTouch.clientX - touch.clientX

		if activities.songsDrawerOffset > -300
			if inTouchZone
				touch.dx < -64 ? activities.songsDrawerOffset = 0 : activities.songsDrawerOffset = -300
			else
				touch.dx > 64 ? activities.songsDrawerOffset = -300 : activities.songsDrawerOffset = 0
		elif activities.settingsDrawerOffset > -300
			if inTouchZone
				touch.dx > 64 ? activities.settingsDrawerOffset = 0 : activities.settingsDrawerOffset = -300
			else
				touch.dx < -64 ? activities.settingsDrawerOffset = -300 : activities.settingsDrawerOffset = 0

		initialTouch = null
		inTouchZone = no


	def closingdrawer e
		unless e.changedTouches.length
			return
		e.dx = e.changedTouches[0].clientX - initialTouch.clientX

		if activities.songsDrawerOffset > -300 && e.dx < 0
			activities.songsDrawerOffset = e.dx
		if activities.settingsDrawerOffset > -300 && e.dx > 0
			activities.settingsDrawerOffset = - e.dx
		inClosingTouchZone = yes

	def openingdrawer e
		unless e.changedTouches.length
			return
		if inTouchZone
			e.dx = e.changedTouches[0].clientX - initialTouch.clientX

			if activities.songsDrawerOffset < 0 && e.dx > 0
				activities.songsDrawerOffset = e.dx - 300
			if activities.settingsDrawerOffset < 0 && e.dx < 0
				activities.settingsDrawerOffset = - e.dx - 300

	def closedrawersend touch
		unless touch.changedTouches.length
			return
		touch.dx = touch.changedTouches[0].clientX - initialTouch.clientX

		if activities.songsDrawerOffset > -300
			touch.dx < -64 ? activities.songsDrawerOffset = -300 : activities.songsDrawerOffset = 0
		elif activities.settingsDrawerOffset > -300
			touch.dx > 64 ? activities.settingsDrawerOffset = -300 : activities.settingsDrawerOffset = 0
		inClosingTouchZone = no

	def openSongsDrawer
		unless hasTouchEvents
			activities.songsDrawerOffset = 0
	
	def closeSongsDrawer
		unless hasTouchEvents
			activities.songsDrawerOffset = -300
	
	def openSettingsDrawer
		unless hasTouchEvents
			activities.settingsDrawerOffset = 0

	def closeSettingsDrawer
		unless hasTouchEvents
			activities.settingsDrawerOffset = -300

	get drawerTransiton
		(inClosingTouchZone || inTouchZone) ? '0' : '450ms'

	get songbookIconTransform
		if window.innerWidth >= 1024
			return 300 + activities.songsDrawerOffset
		return 0

	get settingsIconTransform
		if window.innerWidth >= 1024
			return -300 - activities.settingsDrawerOffset
		return 0

	<self[d:flex]>
		if songbook.currentSongIndex < 0
			<main.full-screen [us:none]>
				<.full-screen[
					bgi: url('../images/green-leaves-plants.jpeg')
					bgp: 50% 50%
					bgr: no-repeat
					bgs: cover
					filter: contrast(150%) grayscale(60%)
				]>
				<.full-screen [d:flex fld:column ta:center bgc:rgba(0, 0, 0, 0.375)]>
					<h1 [c:white fs:3em m:auto auto 6vh]>
						'СЛАВТЕ'
						<br>
						'ГОСПОДА'

					<button [
						border:2px solid #ffeeee
						bg:transparent
						fs:24px
						c:white
						m:0 auto auto
						p:4px 24px
						cursor:pointer
						transform@hover: scale(1.1)
					] @click=activities.toggleSongsMenu> "СПІВАТИ"
		else
			<button.drawer-handle
				[transform:translateX({songbookIconTransform}px)]
				@pointerenter=openSongsDrawer
				@click=activities.toggleSongsMenu>
				<svg src=ChevronRight aria-label="Пісник"
					[transform:rotate({180*+!!songbookIconTransform}deg)]>

			<song-tag [p:4rem 0 128px fs:{theme.fontSize}px fl:1]>

			<button.drawer-handle
				[transform:translateX({settingsIconTransform}px)]
				@pointerenter=openSettingsDrawer
				@click=activities.toggleSettingsMenu>
				<svg src=ChevronLeft aria-label="Налаштування"
					[transform:rotate({180*+!!settingsIconTransform}deg)]>

		<global>
			<songs-drawer
				[l:{activities.songsDrawerOffset}px bxs:{boxShadow(activities.songsDrawerOffset)} transition-duration:{drawerTransiton}]
				@touchstart=slidestart @touchend=closedrawersend @touchcancel=closedrawersend @touchmove=closingdrawer @pointerleave=closeSongsDrawer
				>

			<settings-drawer
				[r:{activities.settingsDrawerOffset}px bxs:{boxShadow(activities.settingsDrawerOffset)} transition-duration:{drawerTransiton}]
				@touchstart=slidestart @touchend=closedrawersend @touchcancel=closedrawersend @touchmove=closingdrawer @pointerleave=closeSettingsDrawer>

			unless songbook.currentSongIndex < 0
				<section [o@off:0 t@lg:0px b@lt-lg:{-menu_icons_transform}px] ease>
					css
						pos:fixed right:0px left:0px
						bgc@lt-lg:$background-color d:flex jc:space-between
						w:100% height:auto @lg:0px zi:2 cursor:pointer
						bdt@lt-lg:1px solid $btn-bg
						button
							padding:3em @lt-lg:0
							width:calc(100% / 2) @lg:auto
							height:2.75rem @lg:auto
							bgc:transparent
							c:$accent-color @lt-lg:$text-color @hover:$acc-hover
							d@lt-lg:hcc
						svg
							o@lt-lg:0.75 @hover:1

					<button[transform: translateY({menu_icons_transform}%) translateX({songbookIconTransform}px)] @click=activities.toggleSongsMenu title="Пісник">
						<svg src=BookOpenText aria-hidden=yes>
					<button[transform: translateY({menu_icons_transform}%) translateX({settingsIconTransform}px)] @click=activities.toggleSettingsMenu title="Налаштування">
						<svg src=SlidersHorizontal aria-hidden=yes>

	css
		.drawer-handle
			w:2vw w:min(1.5rem, max(1rem, 2vw))
			h:100vh
			bgc:gray4/25
			o:0 @hover:1
			d:hcc cursor:pointer zi:2 c:$acc
			bd:none
			pos:sticky t:0

		nav, aside
			h: 100vh
			position: fixed
			top: 0
			bottom: 0
			us:none
			width: 300px
			touch-action: pan-y
			z-index: 1000
			background-color: $background-color

		nav
			transition-property: left
			will-change: left


		aside
			transition-property: right
			will-change: right
			padding-inline: 0.75rem
			padding-block: 1rem 2rem
			overflow-y: auto
			-webkit-overflow-scrolling: touch

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