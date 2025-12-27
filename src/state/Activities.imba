class Activities 
	show_accents = no
	show_themes = no
	show_fonts = no
	show_languages = no

	blockInScroll = null
	scrollLockTimeout = null

	songsDrawerOffset = -300
	settingsDrawerOffset = -300

	activeModal = ''

	# Clean all the variables in order to free space around the text
	@action def cleanUp
		if activeModal == 'theme'
			if #hadTransitionsEnabled
				document.documentElement.dataset.transitions = 'true'

		# If user write a note then instead of clearing everything just hide the note panel.
		if activeModal == "notes"
			activeModal = ''
			return

			window.history.back()

		show_accents = no
		show_themes = no
		show_fonts = no
		show_languages = no

		songsDrawerOffset = -300
		settingsDrawerOffset = -300
		imba.commit!


	def toggleSongsMenu
		if songsDrawerOffset
			if !settingsDrawerOffset
				return cleanUp!
			songsDrawerOffset = 0
		else
			imba.commit!.then do
				songsDrawerOffset = -300
				imba.commit!

	def toggleSettingsMenu
		if settingsDrawerOffset
			if !songsDrawerOffset
				return cleanUp!
			settingsDrawerOffset = 0
		else
			imba.commit!.then do
				settingsDrawerOffset = -300
				imba.commit!

	def openModal modal_name\string
		if activeModal !== modal_name
			activeModal = modal_name
			window.history.pushState({}, modal_name)


const activities = new Activities()

export default activities
