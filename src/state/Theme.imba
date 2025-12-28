import { getValue, setValue } from '../utils' 

import type { colorTheme } from '../types'

const html = document.documentElement

const lights = {
	light: 'light',
	dark: 'dark',
}

class Theme
	fonts = [
		{
			name: "Sans Serif",
			code: "sans, sans-serif"
		},
		{
			name: "Raleway",
			code: "'Raleway', sans-serif"
		},
		{
			name: "David Libre",
			code: "'David Libre', serif"
		},
		{
			name: "Bellefair",
			code: "'Bellefair', serif"
		},
		{
			name: "Ezra SIL",
			code: "'Ezra SIL', serif"
		},
		{
			name: "Roboto Slab",
			code: "'Roboto Slab', sans-serif"
		},
		{
			name: "JetBrains Mono",
			code: "'JetBrains Mono', monospace"
		},
		{
			name: "Bookerly"
			code: "'Bookerly', sans-serif"
		},
		{
			name: "Deutsch Gothic",
			code: "'Deutsch Gothic', sans-serif"
		},
	]

	def constructor
		# Detect dark mode
		try
			if window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches && !getValue('theme')
				theme = 'dark'
		catch error
			console.warn "This browser doesn't support window.matchMedia: ", error

		# Setup some global events handlers
		# Detect change of dark/light mode
		# Are we sure we really want this? 🤔
		try
			if window.matchMedia
				window.matchMedia('(prefers-color-scheme: dark)')
				.addEventListener('change', do|event|
					if event.matches
						theme = 'dark'
					else
						theme = 'light'
				)
		catch error
			console.warn error
		
		fontSize = getValue('font') ?? 20
		fontFamily = getValue('font-family') ?? "'Ezra SIL', serif"
		fontName = getValue('font-name') ?? "Ezra SIL"
		lineHeight = getValue('line-height') ?? 1.8
		#theme = getValue('theme') ?? 'light'

		wordWrap = getValue('word-wrap') ?? no
		showText = getValue('show-text') ?? yes
		showChords = getValue('show-chords') ?? yes
		html.dataset.theme = #theme


	@observable #theme\colorTheme

	@computed get light
		if this.theme == 'dark' or this.theme == 'black'
			return lights.dark
		return lights.light

	@computed get isDark
		return this.theme == 'dark' or this.theme == 'black'

	set theme newTheme\colorTheme
		setValue "theme", newTheme
		html.dataset.theme = newTheme
		#theme = newTheme

	get theme
		return #theme

	def decreaseFontSize
		if #fontSize > 14
			fontSize -= 2

	def increaseFontSize
		if #fontSize < 64 && window.innerWidth > 480
			fontSize = #fontSize + 2
		elif #fontSize < 42
			fontSize = #fontSize + 2

	set fontSize newValue\number
		setValue "font", newValue
		#fontSize = newValue

	get fontSize
		return #fontSize

	set fontFamily newValue\string
		setValue "font-family", newValue
		#fontFamily = newValue

	get fontFamily
		return #fontFamily

	set fontName newValue\string
		setValue "font-name", newValue
		#fontName = newValue

	get fontName
		return #fontName

	set wordWrap newValue\boolean
		setValue "word-wrap", newValue
		#wordWrap = newValue

	get wordWrap
		return #wordWrap

	set showText newValue\boolean
		setValue "show-text", newValue
		#showText = newValue

	get showText
		return #showText

	set showChords newValue\boolean
		setValue "show-chords", newValue
		#showChords = newValue

	get showChords
		return #showChords


	def setFontFamily font\{name: string, code: string}
		fontFamily = font.code
		fontName = font.name

	set lineHeight newValue\number
		setValue "line-height", newValue
		#lineHeight = newValue

	get lineHeight
		return #lineHeight

	def changeLineHeight up\boolean
		if up && lineHeight < 2.6
			lineHeight += 0.2
		elif lineHeight > 1.2
			lineHeight -= 0.2



const theme = new Theme()

export default theme