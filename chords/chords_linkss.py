
import urllib.request
import requests
base_url = 'https://holychords.com/files/chords/' # Em.png

# chords = [
# 	'Ab',
# 	'A',
# 	'Ax',
# 	'Bb',
# 	'H',
# 	'C',
# 	'Cx',
# 	'Db',
# 	'D',
# 	'Dx',
# 	'Eb',
# 	'E',
# 	'F',
# 	'Fx',
# 	'Gb',
# 	'G',
# 	'Gx',
# ]

# chords = [
# 	'Cm',
# 	'Dbm',
# 	'Dm',
# 	'Ebm',
# 	'Em',
# 	'Fm',
# 	'Fxm',
# 	'Gm',
# 	'Abm',
# 	'Am',
# 	'Bbm',
# 	'Bm',
# 	'C',
# 	'Db',
# 	'D',
# 	'Eb',
# 	'E',
# 	'F',
# 	'Fx',
# 	'G',
# 	'Ab',
# 	'A',
# 	'Bb',
# 	'B',
# ]

scale = [
	'A',
	'B',
	'C',
	'D',
	'E',
	'F',
	'G',
	'H',
]

# signs = [
# 	'',
# 	'b',
# 	'x',
# ]

# tonales = [
# 	'',
# 	'm',
# ]

# addons = [
# 	'',
# 	'5'
# 	'6',
# 	'7',
# 	'9',
# 	'11',
# 	'13',
# ]

# extensions = [
# 	'm',
# 	'7',
# 	'5',
# 	'dim',
# 	'dim7',
# 	'aug',
# 	'sus2',
# 	'sus',
# 	'maj7',
# 	'm7',
# 	'7sus4',
# 	'maj9',
# 	'maj11',
# 	'maj13',
# 	'maj9(#11)',
# 	'maj13(#11)',
# 	'add9',
# 	'6add9',
# 	'maj7(b5)',
# 	'maj7(#5)',
# 	'm6',
# 	'm9',
# 	'm11',
# 	'm13',
# 	'm(add9)',
# 	'm6add9',
# 	'mmaj7',
# 	'mmaj9',
# 	'm7b5',
# 	'm7#5',
# 	'6',
# 	'9',
# 	'11',
# 	'13',
# 	'7b5',
# 	'7#5',
# 	'7b9',
# 	'7#9',
# 	'7(b5',
# 	'7(b5',
# 	'7(#5',
# 	'7(#5',
# 	'9b5',
# 	'9#5',
# 	'13#11',
# 	'13b9',
# 	'11b9',
# 	'sus2sus4',
# 	'-5'
# ]

extensions = [
	'm',
	'7',
	'5',
	'dim',
	'dim7',
	'aug',
	'sus2',
	'sus',
	'maj7',
	'm7',
	'7sus4',
	'maj9',
	'maj11',
	'maj13',
	'maj9(x11)',
	'maj13(x11)',
	'add9',
	'6add9',
	'maj7(b5)',
	'maj7(x5)',
	'm6',
	'm9',
	'm11',
	'm13',
	'm(add9)',
	'm6add9',
	'mmaj7',
	'mmaj9',
	'm7b5',
	'm7x5',
	'6',
	'9',
	'11',
	'13',
	'7b5',
	'7x5',
	'7b9',
	'7x9',
	'7(b5',
	'7(b5',
	'7(x5',
	'7(x5',
	'9b5',
	'9x5',
	'13x11',
	'13b9',
	'11b9',
	'sus2sus4',
	'-5'
]


chords = []

for note in scale:
	for extension in extensions:
		chords.append(note + extension)

	# for sign in signs:
	# 	for tonale in tonales:
	# 		for addon in addons:
	# 			# print(note + sign + tonale + addon)
	# 			chords.append(note + sign + tonale + addon)




# https://youtu.be/gl0rnS6knd4

valid_chords = []

for chord in chords:
	url = base_url + chord + '.png'


	filename = '/home/bohuslav/Documents/chords/' + chord + '.png'  # for local files

	r = requests.get(url)
	# print(r.status_code)
	# print(url)
	if r.status_code == 200:
		valid_chords.append(chord)
		with open(filename, "wb") as f:
			f.write(r.content)
			# print(f)


print(valid_chords)
# with open('/home/bohuslav/Documents/chords/valid_chords.txt', "wb") as f:
# 	f.write(''.join(valid_chords))