"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'UI.Examples.PlimboleCell'
	instanceVariableNames: 'location velocity plimbole palette'
	classVariableNames: ''
	imports: #(#{OS.Win32Constants})
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Examples.PlimboleCell guid: (Core.GUID fromString: '{a9d9ae5c-52b6-43b7-9e6c-1bb39ef49f8a}')!
UI.Examples.PlimboleCell comment: ''!
!UI.Examples.PlimboleCell categoriesForClass!Kernel-Objects! !
!UI.Examples.PlimboleCell methodsFor!

arrowImage
	| image directionIndex |
	image := self class arrowIcon bitmap.
	directionIndex := self directionIndex.
	directionIndex = 0 ifTrue: [^image rotateLeft].
	directionIndex = 1 ifTrue: [^image].
	directionIndex = 2 ifTrue: [^image rotateRight].
	directionIndex = 3 ifTrue: [^image rotateRight rotateRight].
	^image!

color
	^self palette at: self directionIndex + 2!

direction
	^self velocity degrees truncated!

directionIndex
	^self directions keyAtEqualValue: self velocity ifAbsent: nil!

directions
	^##((Dictionary new)
		at: 0 put: 0 @ -1;
		at: 1 put: 1 @ 0;
		at: 2 put: 0 @ 1;
		at: 3 put: -1 @ 0;
		yourself)!

drawOn: aCanvas inView: aView
	| cellCenter cellExtent cellRect arrow arrowExtent |
	cellExtent := aView cellExtent.
	cellCenter := (self location * cellExtent + (cellExtent / 2)) rounded.
	cellRect := (Rectangle center: cellCenter extent: cellExtent) insetBy: 2.
	aCanvas fillRectangle: cellRect color: self color.
	arrow := self arrowImage.
	arrowExtent := cellExtent // 2.
	arrow
		drawOn: aCanvas
		at: cellCenter - (arrowExtent // 2)
		extent: arrowExtent!

location
	^location!

location: aPoint 
	location := aPoint!

palette
	^palette ifNil: [palette := PlimbolePresenter defaultPalette]!

palette: anArrayOfColors
	palette := anArrayOfColors
!

printOn: aStream 
	self basicPrintOn: aStream.
	aStream
		nextPut: $(;
		display: self direction;
		nextPut: $)!

reverse
	self velocity: self velocity negated!

rotate
	| dir newVelocity |
	dir := self direction.
	dir = 0 ifTrue: [newVelocity := 0 @ 1].
	dir = 90 ifTrue: [newVelocity := -1 @ 0].
	dir = 180 ifTrue: [newVelocity := 0 @ -1].
	dir = 270 ifTrue: [newVelocity := 1 @ 0].
	self velocity: newVelocity!

setLocation: aPoint direction: directionIndex 
	location := aPoint.
	velocity := self directions at: directionIndex!

velocity
	^velocity!

velocity: aPoint 
	velocity := aPoint!

x
	^self location x!

y
	^self location y! !
!UI.Examples.PlimboleCell categoriesForMethods!
arrowImage!private! !
color!accessing!public! !
direction!accessing!public! !
directionIndex!accessing!private! !
directions!constants!private! !
drawOn:inView:!drawing!private! !
location!accessing!public! !
location:!accessing!public! !
palette!accessing!private! !
palette:!accessing!private! !
printOn:!printing!public! !
reverse!operations!public! !
rotate!operations!public! !
setLocation:direction:!initializing!private! !
velocity!accessing!public! !
velocity:!accessing!public! !
x!accessing!public! !
y!accessing!public! !
!

!UI.Examples.PlimboleCell class methodsFor!

arrowIcon
	^InternalIcon 
		fromBytes: #[137 80 78 71 13 10 26 10 0 0 0 13 73 72 68 82 0 0 0 48 0 0 0 48 8 6 0 0 0 87 2 249 135 0 0 0 1 115 82 71 66 0 174 206 28 233 0 0 0 4 103 65 77 65 0 0 177 143 11 252 97 5 0 0 0 9 112 72 89 115 0 0 14 195 0 0 14 195 1 199 111 168 100 0 0 1 147 73 68 65 84 104 67 237 152 189 74 195 80 20 128 163 109 197 199 80 112 18 31 193 89 220 138 110 14 78 46 46 46 117 113 84 112 20 29 68 74 17 68 116 16 7 7 221 20 223 193 205 39 17 197 191 196 239 246 28 132 114 147 33 45 54 39 114 62 56 28 110 206 201 205 151 208 38 185 73 28 199 113 28 199 113 106 64 150 101 139 105 154 222 19 79 196 30 227 150 150 236 131 240 2 241 134 244 47 140 111 72 77 109 177 13 178 135 162 61 8 219 47 73 13 109 179 11 162 167 162 28 67 173 71 154 208 86 155 32 185 34 186 249 80 63 34 217 61 137 32 135 228 73 223 182 0 234 251 218 110 19 28 39 137 243 190 109 49 59 218 110 19 4 155 92 233 107 113 205 135 250 150 182 219 4 199 41 36 239 68 55 134 218 55 177 161 237 54 193 115 26 201 71 81 142 161 246 69 172 105 251 104 48 209 18 241 76 164 58 255 88 224 112 31 68 91 53 134 131 9 102 137 87 157 115 236 132 99 19 115 170 83 30 118 238 232 92 149 129 195 182 234 148 199 200 9 116 84 167 60 236 92 245 79 232 133 52 163 58 195 193 36 85 253 137 223 137 101 213 176 5 126 225 54 250 32 170 49 212 62 137 85 109 183 5 126 45 228 110 69 53 134 90 120 6 172 107 187 45 240 107 32 119 37 170 49 212 2 155 218 110 11 252 194 27 233 153 168 198 136 251 8 183 204 191 4 191 32 127 44 170 133 236 106 187 61 144 111 171 100 46 212 15 72 118 23 52 8 134 101 99 46 212 186 36 243 75 202 112 133 35 216 126 65 170 197 162 126 158 24 120 162 51 174 207 103 149 0 178 245 253 176 229 56 142 227 56 206 255 36 73 126 0 57 213 176 107 74 125 11 203 0 0 0 0 73 69 78 68 174 66 96 130]!

icon
	^Plimbole icon!

location: aLocationPoint direction: directionIndex 
	^(super new)
		setLocation: aLocationPoint direction: directionIndex;
		yourself! !
!UI.Examples.PlimboleCell class categoriesForMethods!
arrowIcon!public! !
icon!constants!public! !
location:direction:!instance creation!public! !
!

