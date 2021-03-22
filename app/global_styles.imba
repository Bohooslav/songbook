global css
	@root[data-light="dark"]
		--background-color: rgb(4,6,12)
		--text-color: rgb(255,238,238)
		--btn-bg: rgba(136,136,255,0.25)
		--btn-bg-hover: rgba(136,136,255,0.4)
		--accent-color: rgb(169,128,25)
		--accent-hover-color: rgba(225,175,51,0.996)


	@root[data-light="light"]
		--background-color: rgb(235, 219, 183)
		--text-color: rgb(46, 39, 36)
		--btn-bg: rgb(226, 204, 152)
		--btn-bg-hover: rgb(230, 211, 167)
		--accent-color: navy
		--accent-hover-color: rgba(65,118,144,0.996)


	*
		box-sizing: border-box
		scrollbar-color: $btn-bg-hover transparent
		scrollbar-width: auto
		margin: 0
		padding: 0
		scroll-behavior: smooth
		-webkit-tap-highlight-color: transparent
		transition: all 300ms ease 0s
		transition-delay: 0ms

	*::selection
		text-decoration-color: $background-color
		color: $background-color
		background-color: $accent-hover-color

	::-webkit-scrollbar 
		width: 12px

	::-webkit-scrollbar-track 
		background: transparent

	::-webkit-scrollbar-thumb 
		background: var(--btn-bg-hover)
		border-radius: 4px

	::-webkit-scrollbar-thumb:hover 
		background: var(--btn-bg)

	*:focus 
		outline: none
	
	input
		-webkit-appearance: none
		-moz-appearance: none
		appearance: none


	body
		font-family: sans, sans-serif, "Apple Color Emoji", "Droid Sans Fallback", "Noto Color Emoji", "Segoe UI Emoji"
		font-size: 18px
		background: $background-color
		color: $text-color
		# overflow: hidden
	