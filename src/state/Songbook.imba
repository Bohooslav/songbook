import {songs as allSongs} from '../songs.imba'
import { getValue, setValue } from '../utils'
import activities from './Activities'

# Sort songs by alphabet
allSongs.sort(do |a, b|
	return ('' + a.name).localeCompare(b.name))

# Parse allSongs chords
for song, index in allSongs
	allSongs[index].transposition = 0
	for line in song.lines
		if line.chords
			# Then parse the chords line and separate spaces from chords
			let chords\string[] = []
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
			

const scale = [
	'A'
	'B'
	'C'
	'D'
	'E'
	'F'
	'G'
]

class SongBook
	songs = allSongs
	transpositions = getValue("transpositions") ?? []
	currentSongIndex = songIndex[getValue('current_song_name')] || -1

	def constructor
		for song in songs
			let was_the_song_transposed = transpositions.find(do |el| return el.song == song.name)

			if was_the_song_transposed
				transpose(song, was_the_song_transposed.transposition)
			else
				song.transposition = 0


	def transpose song, transposition
		if -13 < song.transposition + transposition < 13
			const song_index = songIndex[song.name]
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
			setValue('transpositions', transpositions)


	def goToSong song
		currentSongIndex = songIndex[song.name]
		setValue('current_song_name', song.name)
		activities.cleanUp!

	get songIndex
		const index = {}
		for song, i in songs
			index[song.name] = i
		return index

	get currentSong
		if currentSongIndex >= 0 && currentSongIndex < songs.length
			return songs[currentSongIndex]
		else
			return {
				name: ''
				lines: []
			}


const songbook = new SongBook()
export default songbook
