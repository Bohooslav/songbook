import chords from '../chords'

tag song-tag < main
	def chordImgUrl chord
		chord = chord.replace('#', 'x').replace('B', 'H')
		return chords[chord]

	<self[ff:{theme.fontFamily} fs:{theme.fontSize} lh:{theme.lineHeight}]>
		<h1[lh:1]>
			songbook.currentSong.name
			if songbook.currentSong.transposition > 0
				' +'
				songbook.currentSong.transposition
			elif songbook.currentSong.transposition < 0
				' '
				songbook.currentSong.transposition
		<pre .wrapped=theme.wordWrap>
			for line in songbook.currentSong.lines
				<div .break=line.break>
					if line.text && theme.showText
						<p> line.text
					elif line.refrain
						<p.refrain> line.refrain
					elif line.bridge
						<p.bridge> line.bridge
					elif line.chords && theme.showChords
						<p.chords .without_text=!theme.showText>
							for part in line.chords
								<span>
									if /[A-H]/.test(part[0])
										<span.chord>
											part
											if document.getSelection().isCollapsed
												<.chord_img>
													<img .invert=(theme.light == 'dark') src=chordImgUrl(part) alt=part>
									else
										part


	css
		d:flex
		fld:column

	css pre
		m:auto
		ff:inherit
	
	css p
		pb: 0.5em

	css .wrapped p
		word-break: normal
		white-space: pre-wrap
		text-indent: -2em
		margin-left: 2em

	css .break
		h:1.6em

	css h1
		m:2em auto

	css .bridge
		ta: right
		font-style: italic
		d:block
	
	css .refrain
		fw:bold
	
	css .chords
		lh:1
		pb:0

	css .without_text
		lh:inherit
		pb:inherit
		ws:pre-line

	
	css .chord
		pos:relative
		cursor:pointer
		c:$accent-hover-color @hover:$accent-color
		d:inline-flex
		jc:center
		text-indent:0

	css .chord > .chord_img
		o:0
		visibility:hidden
		transform: scale(0.8)
		origin: bottom center
	
	css .chord@hover > .chord_img
		o:1
		visibility:visible
		transform:none


	css .chord_img
		us:none
		bd:1px solid $btn-bg
		pos:absolute
		b:100%
		bg:$background-color
		p:8px 0
		rd:8px
		shadow: 0 0 0 1px rgba(53,72,91,.1),0 2px 2px rgba(0,0,0,.0274351),0 4px 4px rgba(0,0,0,.0400741),0 10px 8px rgba(0,0,0,.0499982),0 15px 15px rgba(0,0,0,.0596004),0 30px 30px rgba(0,0,0,.0709366),0 70px 65px rgba(0,0,0,.09)

	css .chord_img img
		size:64px


	css .invert
		filter: invert(100%)