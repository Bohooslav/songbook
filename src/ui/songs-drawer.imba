import { scoreSearch } from '../utils'
import {songs} from '../songs.imba'


tag songs-drawer < nav
	@observable query = ''

	def cleanString s
		if s
			return s.toLowerCase().replace(/[^0-9a-zа-яіїєёґ\s]+/g, "")
		else return ''

	@computed get filterSongs
		if query.length > 1
			const filtered_songs = []
			const clean_search = cleanString(query)
			for song in songs
				const score = scoreSearch(cleanString(song.name), clean_search)
				if score > clean_search.length * 2
					filtered_songs.push({
						name: song.name
						score: score
					})
			return filtered_songs.sort(do |a, b| b.score - a.score)
		else
			return songs
	

	<self[d:flex h:100% fld:column]>
		<h2 @click=(songbook.currentSongIndex = -1)> 'СЛАВТЕ ГОСПОДА'
		<ul [fl:1 ofy:auto]>
			for song, i in filterSongs
				<li[p:.5rem 1rem c@hover: $accent-hover-color cursor:pointer] role='button' @click=songbook.goToSong(song)> song.name
			unless filterSongs.length
				<pre[ff:inherit ta:center]> '(ಠ╭╮ಠ)    ¯\\_(ツ)_/¯   ノ( ゜-゜ノ)'
			<[h:128px]>
		<[d:flex]>
			<input$search aria-label='Пошук' placeholder='Пошук' bind=query>
			<button [
				bg:$background-color fs:2em c@hover:firebrick size:59px
				bd:none cursor:pointer
			] @click=(query = '')>
				<span[transform:rotate(45deg) d:inline-block o:0.7 @hover:1]> '+'


	css
		h2
			fs:1.25rem py:1rem
			ta:center cursor:pointer
			c@hover:$accent-hover-color

		$search
			w:calc(100% - 59px)
			bg:$background-color
			fs:1.2em
			p:16px
			pr:0
			c:inherit
			bd:none
