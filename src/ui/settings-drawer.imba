import SunMoon from 'lucide-static/icons/sun-moon.svg'
import Moon from 'lucide-static/icons/moon.svg'
import Sun from 'lucide-static/icons/sun.svg'
import ChevronUp from 'lucide-static/icons/chevron-up.svg'
import ChevronDown from 'lucide-static/icons/chevron-down.svg'

tag settings-drawer < aside
	deferredPrompt = null

	def setup
		window.addEventListener('beforeinstallprompt', do |e|
			e.preventDefault()
			deferredPrompt = e
			imba.commit!
		)

	def install
		if deferredPrompt
			deferredPrompt.prompt()

	<self[d:flex fld:column jc:end]>
		if deferredPrompt
			<button.btnbox[d:flex ai:center font:inherit c:inherit @hover:$accent-hover-color bg:transparent bd:none fill:$text-color @hover:$accent-hover-color cursor:pointer] @click=install>
				<svg[size:32px fill:inherit mr:12px] xmlns="http://www.w3.org/2000/svg" height="24" viewBox="0 0 24 24" width="24">
					<title> "Встановити"
					<path d="M19 9h-4V3H9v6H5l7 7 7-7zM5 18v2h14v-2H5z">
				"Встановити"
		<p>
			'Транспозиція: '
			if songbook.currentSong.transposition > 0
				'+'
			songbook.currentSong.transposition

		<.btnbox>
			<button.cbtn [p:.5rem fs:1.5rem fw:100] @click=songbook.transpose(songbook.currentSong, 1) title="Підняти транспозицію">
				<svg src=ChevronUp aria-hidden="true" />
			<button.cbtn [p:.5rem fs:1.5rem fw:900] @click=songbook.transpose(songbook.currentSong, -1) title="Опустити транспозицію">
				<svg src=ChevronDown aria-hidden="true" />
		<.btnbox>
			<button.cbtn [p:.5rem fs:1.5rem fw:100] @click=(theme.theme = 'light') title="Денна тема">
				<svg src=Sun aria-hidden="true" />
			<button.cbtn [p:.5rem fs:1.5rem fw:900] @click=(theme.theme = 'dark') title="Нічна Тема">
				<svg src=Moon aria-hidden="true" />
		<.btnbox>
			<button[p:0.75rem fs:1.25rem].cbtn @click=theme.decreaseFontSize title="Зменшити розмір шрифту"> "B-"
			<button[p:.5rem fs:1.5rem].cbtn @click=theme.increaseFontSize title="Збільшити розмір шрифту"> "B+"
		<.btnbox>
			<svg.cbtn @click=theme.changeLineHeight(no) viewBox="0 0 38 14" fill="none" stroke="currentColor" stroke-width="1" stroke-linecap="round" stroke-linejoin="round" [p:1rem 0]>
				<title> "Зменшити міжрядковий інтервал"
				<rect x="0" y="0" width="28" height="1">
				<rect x="0" y="6" width="38" height="1">
				<rect x="0" y="12" width="18" height="1">
			<svg.cbtn @click=theme.changeLineHeight(yes) viewBox="0 0 38 24" fill="none" stroke="currentColor" stroke-width="1" stroke-linecap="round" stroke-linejoin="round" [p:0.5rem 0]>
				<title> "Збільшити міжрядковий інтервал"
				<rect x="0" y="0" width="28" height="1">
				<rect x="0" y="11" width="38" height="1">
				<rect x="0" y="22" width="18" height="1">

		<button.option-box.checkbox-parent @click=(theme.showChords = !theme.showChords) .checkbox-turned=theme.showChords>
			"Показувати акорди"
			<.checkbox> <span>
		<button.option-box.checkbox-parent @click=(theme.showText = !theme.showText) .checkbox-turned=theme.showText>
			"Показувати текст"
			<.checkbox> <span>
		<button.option-box.checkbox-parent @click=(theme.wordWrap = !theme.wordWrap) .checkbox-turned=theme.wordWrap>
			"Переносити слова"
			<.checkbox> <span>


		<footer[ta:center mt:32px]>
			css
				d:vflex ai:center jc:center
				text-align: center gap:1rem
				font-size: 0.875rem

				a
					color: $c
					color@hover:$accent-hover-color
					background-size: 100% 0.2em
					background-image: linear-gradient($c 0px, $c 100%) @hover: linear-gradient($accent-hover-color 0px, $accent-hover-color 100%)

			<p[fs:20px]>
				"♪└|∵|┐♪└|∵|┘♪┌|∵|┘♪"

			<address[fs:12px mt:16px c:gray]>
				"© "
				<time dateTime="2020-02-24T12:38"> "2021 "
				<a target="_blank" rel="noreferrer" href="https://t.me/Boguslavv"> "Богуслав Павлишинець"
				" · "
				<a target="_blank" rel="noreferrer" href="https://t.me/Tymkoo"> "Віталій Тимко"
				" · "
				<a target="_blank" rel="noreferrer" href="https://t.me/yanch4i"> "Ян Кушілка"


		unless activities.settingsDrawerOffset
			<global @click.outside.capture.stop.prevent=activities.toggleSettingsMenu>

	css
		.cbtn
			w: 50% h: 100%
			color: $c @hover:$accent-hover-color
			display: inline-block
			text-align: center
			bgc: transparent @hover:$btn-bg-hover
			border-radius: .5rem
			transform@active: translateY(2px)

		.btnbox
			cursor: pointer
			height: 2.875rem
			margin: 1rem 0

		.option-box
			d:flex ai:center
			padding-block:1rem
			cursor:pointer

		.checkbox-parent
			c:$c
			background-color: transparent
			text-align: left
			width: 100%
			font: inherit
			o: 0.8

		.checkbox
			width: 2.8em
			min-width: 2.8em
			height: 1.5em
			border: 2px solid $c
			border-radius: 2.24em
			margin-left: auto
			box-sizing: content-box

			span
				display: block
				width: 1.5em
				height: 1.5em
				background: $c
				border-radius: 0.8em
				transform: translateX(-1px)

		html[data-theme="dark"] .checkbox-turned
			div
				box-shadow: inset 0 0 0.8em 0.2em currentColor

		.checkbox-turned
			o: 1
			span
				transform: translateX(1.4em)
				opacity: 1


		.checkbox-parent
			c:$text-color
			background-color: transparent
			text-align: left
			width: 100%
			font: inherit
			o: 0.8

		.checkbox
			width: 2.8em
			min-width: 2.8em
			height: 1.5em
			border: 2px solid $text-color
			border-radius: 2.24em
			margin-left: auto
			box-sizing: content-box

			span
				display: block
				width: 1.5em
				height: 1.5em
				background: $text-color
				border-radius: 0.8em
				transform: translateX(-1px)

		html[data-theme="dark"] .checkbox-turned
			div
				box-shadow: inset 0 0 0.8em 0.2em currentColor

		.checkbox-turned
			o: 1
			span
				transform: translateX(1.4em)
				opacity: 1
